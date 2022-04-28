package com.protek.rfid.zebra_rfd8500;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.zebra.rfid.api3.ACCESS_OPERATION_CODE;
import com.zebra.rfid.api3.ACCESS_OPERATION_STATUS;
import com.zebra.rfid.api3.Antennas;
import com.zebra.rfid.api3.ENUM_TRANSPORT;
import com.zebra.rfid.api3.ENUM_TRIGGER_MODE;
import com.zebra.rfid.api3.HANDHELD_TRIGGER_EVENT_TYPE;
import com.zebra.rfid.api3.INVENTORY_STATE;
import com.zebra.rfid.api3.InvalidUsageException;
import com.zebra.rfid.api3.OperationFailureException;
import com.zebra.rfid.api3.RFIDReader;
import com.zebra.rfid.api3.ReaderDevice;
import com.zebra.rfid.api3.Readers;
import com.zebra.rfid.api3.RfidEventsListener;
import com.zebra.rfid.api3.RfidReadEvents;
import com.zebra.rfid.api3.RfidStatusEvents;
import com.zebra.rfid.api3.START_TRIGGER_TYPE;
import com.zebra.rfid.api3.STATUS_EVENT_TYPE;
import com.zebra.rfid.api3.STOP_TRIGGER_TYPE;
import com.zebra.rfid.api3.TagData;
import com.zebra.rfid.api3.TriggerInfo;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

class RFIDHandlerHelper implements Readers.RFIDReaderEventHandler {
    private static RFIDHandleTagData rfidHandleTagData;
    final static String TAG = "RFID_SAMPLE";
    // RFID Reader
    private static Readers readers;
    private static ArrayList<ReaderDevice> availableRFIDReaderList;
    private static ReaderDevice readerDevice;
    private static String lastConnectedReaderName;
    public static RFIDReader reader;
    private EventHandler eventHandler;
    // Context
    private Context context;
    private ZebraRfd8500Plugin plugin;
    // general
    private int MAX_POWER = 270;
    // In case of RFD8500 change reader name with intended device below from list of
    // paired RFD8500

    RFIDHandlerHelper(Context context, ZebraRfd8500Plugin plugin) {
        this.context = context;
        this.plugin = plugin;
        rfidHandleTagData = new RFIDHandleTagData(this);
        readers = new Readers(context, ENUM_TRANSPORT.BLUETOOTH);
        Log.d(TAG, "Attach set");
    }

    ArrayList<String> getAvailableRFIDReaderList() throws InvalidUsageException {

        if (reader != null && reader.isConnected()) {
            disconnect(true);
        }

        ArrayList<String> result = new ArrayList<String>();
        ;
        if (readers == null) {
            Log.d(TAG, "Reader is null");
        }
        ArrayList<ReaderDevice> list = readers.GetAvailableRFIDReaderList();
        Log.d(TAG, "GET LIST SUCCESS");
        for (int i = 0; i < list.size(); i++) {
            String hostName = list.get(i).getRFIDReader().getHostName();
            result.add(hostName);
        }
        return result;
    }

    public boolean isReaderConnected() {
        if (reader != null && reader.isConnected())
            return true;
        else {
            Log.d(TAG, "reader is not connected");
            return false;
        }
    }

    //
    // Activity life cycle behavior
    //

    boolean onResume() {
        return connect();
    }

    void onPause() {
        disconnect(true);
    }

    void onDestroy() {
        dispose();
    }

    //
    // RFID SDK
    //

    void connectToScanner(String scannerName) {
        Log.d(TAG, "connectToScanner");
        if (reader != null && reader.isConnected()) {
            disconnect(true);
        }
        new ConnectionTask(scannerName).execute();
    }

    private class ConnectionTask extends AsyncTask<Void, Void, String> {

        String scannerName;

        ConnectionTask(String scannerName) {
            this.scannerName = scannerName;
        }

        @Override
        protected String doInBackground(Void... voids) {
            Log.d(TAG, "ConnectionTask");
            try {
                GetAvailableReader(scannerName);
            } catch (InvalidUsageException e) {
                e.printStackTrace();
                return "fail";
            }
            if (reader != null) {
                boolean result = connect();
                return result ? "success" : "fail";
            }
            return "fail";
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);
            if (result == "success") {
                lastConnectedReaderName = scannerName;
                plugin.notifyReaderConnectionStatus(true, reader.getHostName());
            } else {
                // send fail signal to flutter
                plugin.notifyReaderConnectionStatus(false, reader.getHostName());
            }
        }
    }

    private synchronized void GetAvailableReader(String scannerName) throws InvalidUsageException {
        Log.d(TAG, "GetAvailableReader");
        if (readers != null) {
            readers.attach(this);
            if (readers.GetAvailableRFIDReaderList() != null) {
                availableRFIDReaderList = readers.GetAvailableRFIDReaderList();

                if (availableRFIDReaderList.size() != 0) {
                    if (availableRFIDReaderList.size() == 1 || scannerName == null) {
                        readerDevice = availableRFIDReaderList.get(0);
                        reader = readerDevice.getRFIDReader();
                    } else {
                        for (ReaderDevice device : availableRFIDReaderList) {
                            if (device.getName().equals(scannerName)) {
                                readerDevice = device;
                                reader = readerDevice.getRFIDReader();
                            }
                        }
                    }
                }
            }
        }
    }

    // handler for receiving reader appearance events
    @Override
    public void RFIDReaderAppeared(ReaderDevice readerDevice) {
        Log.d(TAG, "RFIDReaderAppeared " + readerDevice.getName());
        // if (lastConnectedReaderName == readerDevice.getName())
        plugin.notifyReaderListChange(true, readerDevice.getName());
    }

    @Override
    public void RFIDReaderDisappeared(ReaderDevice readerDevice) {
        Log.d(TAG, "RFIDReaderDisappeared " + readerDevice.getName());
        plugin.notifyReaderListChange(false, readerDevice.getName());
        if (readerDevice.getName().equals(reader.getHostName()))
            disconnect(false);
    }

    public void connectRFIDReader() {

    }

    private synchronized boolean connect() {
        if (reader != null) {
            Log.d(TAG, "1");
            Log.d(TAG, "connect " + reader.getHostName());
            try {
                if (!reader.isConnected()) {
                    // Establish connection to the RFID Reader
                    reader.connect();
                    ConfigureReader();
                    return true;
                }
            } catch (InvalidUsageException e) {
                e.printStackTrace();
                return false;
            } catch (OperationFailureException e) {
                e.printStackTrace();
                Log.d(TAG, "OperationFailureException " + e.getVendorMessage());
                String des = e.getResults().toString();
                return false;
            }
        }
        return false;
    }

    private void ConfigureReader() {
        Log.d(TAG, "ConfigureReader " + reader.getHostName());
        if (reader.isConnected()) {
            TriggerInfo triggerInfo = new TriggerInfo();
            triggerInfo.StartTrigger.setTriggerType(START_TRIGGER_TYPE.START_TRIGGER_TYPE_IMMEDIATE);
            triggerInfo.StopTrigger.setTriggerType(STOP_TRIGGER_TYPE.STOP_TRIGGER_TYPE_IMMEDIATE);
            try {
                // receive events from reader
                if (eventHandler == null)
                    eventHandler = new EventHandler();
                reader.Events.addEventsListener(eventHandler);
                // HH event
                reader.Events.setHandheldEvent(true);
                reader.Events.setReaderDisconnectEvent(true);

                // tag event with tag data
                reader.Events.setTagReadEvent(true);
                reader.Events.setAttachTagDataWithReadEvent(false);
                // set trigger mode as rfid so scanner beam will not come
                reader.Config.setTriggerMode(ENUM_TRIGGER_MODE.RFID_MODE, true);
                // set start and stop triggers
                reader.Config.setStartTrigger(triggerInfo.StartTrigger);
                reader.Config.setStopTrigger(triggerInfo.StopTrigger);
                // power levels are index based so maximum power supported get the last one
                // MAX_POWER = reader.ReaderCapabilities.getTransmitPowerLevelValues().length -
                // 1;
                // // set antenna configurations
                // Antennas.AntennaRfConfig config =
                // reader.Config.Antennas.getAntennaRfConfig(1);
                // config.setTransmitPowerIndex(MAX_POWER);
                // config.setrfModeTableIndex(0);
                // config.setTari(0);
                // reader.Config.Antennas.setAntennaRfConfig(1, config);
                // // Set the singulation control
                // Antennas.SingulationControl s1_singulationControl =
                // reader.Config.Antennas.getSingulationControl(1);
                // s1_singulationControl.setSession(SESSION.SESSION_S0);
                // s1_singulationControl.Action.setInventoryState(INVENTORY_STATE.INVENTORY_STATE_A);
                // s1_singulationControl.Action.setSLFlag(SL_FLAG.SL_ALL);
                // reader.Config.Antennas.setSingulationControl(1, s1_singulationControl);
                // // delete any prefilters
                // reader.Actions.PreFilters.deleteAll();
                //
            } catch (InvalidUsageException | OperationFailureException e) {
                e.printStackTrace();
                disconnect(true);
            }
        }
    }

    private synchronized void disconnect(boolean shouldNotify) {
        Log.d(TAG, "disconnect " + reader);
        try {
            if (reader != null) {
                String readerName = reader.getHostName();
                reader.Events.removeEventsListener(eventHandler);
                reader.disconnect();
                if (shouldNotify)
                    plugin.notifyReaderConnectionStatus(false, readerName);
                return;
                // send disconnect msg back to flutter
            }
        } catch (InvalidUsageException e) {
            e.printStackTrace();
        } catch (OperationFailureException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private synchronized void dispose() {
        try {
            if (readers != null) {
                reader = null;
                readers.Dispose();
                readers = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // synchronized void performInventory() {
    // // check reader connection
    // if (!isReaderConnected())
    // return;
    // try {
    // reader.Actions.Inventory.perform();
    // } catch (InvalidUsageException e) {
    // e.printStackTrace();
    // } catch (OperationFailureException e) {
    // e.printStackTrace();
    // }
    // }
    //
    // synchronized void stopInventory() {
    // // check reader connection
    // if (!isReaderConnected())
    // return;
    // try {
    // reader.Actions.Inventory.stop();
    // } catch (InvalidUsageException e) {
    // e.printStackTrace();
    // } catch (OperationFailureException e) {
    // e.printStackTrace();
    // }
    // }

    // Read/Status Notify handler
    // Implement the RfidEventsLister class to receive event notifications
    public class EventHandler implements RfidEventsListener {
        // Read Event Notification
        public void eventReadNotify(RfidReadEvents e) {
            // Recommended to use new method getReadTagsEx for better performance in case of
            // large tag population
            TagData[] myTags = reader.Actions.getReadTags(100);
            ArrayList<String> rfidList = new ArrayList<String>();
            if (myTags != null) {
                for (int index = 0; index < myTags.length; index++) {
                    rfidList.add(myTags[index].getTagID());
                    Log.d(TAG, "Tag ID " + myTags[index].getTagID());
                    if (myTags[index].getOpCode() == ACCESS_OPERATION_CODE.ACCESS_OPERATION_READ &&
                            myTags[index].getOpStatus() == ACCESS_OPERATION_STATUS.ACCESS_SUCCESS) {
                        if (myTags[index].getMemoryBankData().length() > 0) {
                            Log.d(TAG, " Mem Bank Data " + myTags[index].getMemoryBankData());
                        }
                    }
                    if (myTags[index].isContainsLocationInfo()) {
                        short dist = myTags[index].LocationInfo.getRelativeDistance();
                        Log.d(TAG, "Tag relative distance " + dist);
                    }
                }

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        plugin.notifyRfidData(rfidList);
                    }
                });
            }
        }

        // Status Event Notification
        public void eventStatusNotify(RfidStatusEvents rfidStatusEvents) {
            Log.d(TAG, "Status Notification: " + rfidStatusEvents.StatusEventData.getStatusEventType());
            if (rfidStatusEvents.StatusEventData.getStatusEventType() == STATUS_EVENT_TYPE.DISCONNECTION_EVENT) {
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        plugin.notifyReaderConnectionStatus(false, reader.getHostName());
                    }
                });
                disconnect(false);
            }
            if (rfidStatusEvents.StatusEventData.getStatusEventType() == STATUS_EVENT_TYPE.HANDHELD_TRIGGER_EVENT) {
                if (rfidStatusEvents.StatusEventData.HandheldTriggerEventData
                        .getHandheldEvent() == HANDHELD_TRIGGER_EVENT_TYPE.HANDHELD_TRIGGER_PRESSED) {
                    new AsyncTask<Void, Void, Void>() {
                        @Override
                        protected Void doInBackground(Void... voids) {
                            rfidHandleTagData.handleTriggerPress(true);
                            return null;
                        }
                    }.execute();
                }
                if (rfidStatusEvents.StatusEventData.HandheldTriggerEventData
                        .getHandheldEvent() == HANDHELD_TRIGGER_EVENT_TYPE.HANDHELD_TRIGGER_RELEASED) {
                    new AsyncTask<Void, Void, Void>() {
                        @Override
                        protected Void doInBackground(Void... voids) {
                            rfidHandleTagData.handleTriggerPress(false);
                            return null;
                        }
                    }.execute();
                }
            }
        }
    }

    // private class AsyncDataUpdate extends AsyncTask<ArrayList<String>, Void,
    // Void> {
    // @Override
    // protected Void doInBackground(ArrayList<String>... params) {
    // ArrayList<String> list = params[0];
    // plugin.notifyRfidData(list);
    //// rfidHandleTagData.handleTagData(params[0]);
    //// List<String> list = Arrays.stream(params[0]).map((tagData)-> tagData.g)
    // return null;
    // }
    // }

    interface ResponseHandlerInterface {
        void handleTagData(TagData[] tagData);

        void handleTriggerPress(boolean pressed);
        // void handleStatusEvents(Events.StatusEventData eventData);
    }

}
