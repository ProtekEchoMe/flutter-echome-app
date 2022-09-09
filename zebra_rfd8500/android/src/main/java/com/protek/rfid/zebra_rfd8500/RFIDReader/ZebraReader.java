package com.protek.rfid.zebra_rfd8500.RFIDReader;

import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.rscja.deviceapi.exception.ConfigurationException;
import com.zebra.rfid.api3.*;

import java.util.ArrayList;
import java.util.HashMap;

public class ZebraReader extends rfidReader {

    private String TAG = "zebraReader";

    private boolean loopFlag = false;
    private boolean playSound = false;
    private Handler handler;
    private HashMap<String, String> map;
    private ArrayList<HashMap<String, String>> tagList = new ArrayList<HashMap<String, String>>();
    private RFIDReader reader;
    private EventHandler eventHandler;
    private boolean isRunning = false;

    public ZebraReader(RFIDReader reader) throws ConfigurationException {
        this.reader = reader;
//        init();
    }
    @Override
    public boolean connect() {
        Log.d(TAG, "connectToScanner");
        if (reader != null && reader.isConnected()) {
            disconnect();
//            return true;
        }
        new ConnectionTask().execute();
        return true;
    }

    @Override
    public boolean disconnect() {
        Log.d(TAG, "disconnect " + reader);
        try {
            if (reader != null) {
                String readerName = reader.getHostName();
                reader.Events.removeEventsListener(eventHandler);
                reader.disconnect();
                return true;
                // send disconnect msg back to flutter
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean startInventory() {
        if (isRunning)
            return false;

        try {
            reader.Actions.Inventory.perform();
            isRunning = true;
        } catch (InvalidUsageException | OperationFailureException e) {
            e.printStackTrace();
        }

        return true;
    }

    @Override
    public boolean stopInventroy() {
        if (!reader.isConnected() || !isRunning)
            return false;
        try {
            reader.Actions.Inventory.stop();
            isRunning = false;
            return true;
        } catch (InvalidUsageException | OperationFailureException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public String readSingleTag() {
        return null;
    }

    @Override
    public boolean setPower(int power) {
        try {
            Antennas.AntennaRfConfig antennaRfConfig = reader.Config.Antennas.getAntennaRfConfig(1);
            antennaRfConfig.setTransmitPowerIndex(power);
            reader.Config.Antennas.setAntennaRfConfig(1,antennaRfConfig);
            return true;
        }catch (InvalidUsageException | OperationFailureException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public int getPower() {
        return 0;
    }

    @Override
    public String performTagLocating(String rfid){return "";}

    @Override
    public boolean stopTagLocating() {
        return false;
    }



    public class EventHandler implements RfidEventsListener {
        // Read Event Notification
        public void eventReadNotify(RfidReadEvents e) {
            // Recommended to use new method getReadTagsEx for better performance in case of
            // large tag population
            TagData[] myTags = reader.Actions.getReadTags(100);
            ArrayList<String> rfidList = new ArrayList<String>();
            ArrayList<String> relativeDistanceList = new ArrayList<String>();

            if (myTags != null) {
                for (int index = 0; index < myTags.length; index++) {
//                    log( "Tag ID class " + myTags[index].getTagID().getClass().getSimpleName());
                    if(myTags[index].getTagID() != null) {
                        rfidList.add(myTags[index].getTagID());
                    }
                    log( "Tag ID " + myTags[index].getTagID());
                    log( "Tag RSSI " + myTags[index].getPeakRSSI());
                    if (myTags[index].getOpCode() == ACCESS_OPERATION_CODE.ACCESS_OPERATION_READ &&
                            myTags[index].getOpStatus() == ACCESS_OPERATION_STATUS.ACCESS_SUCCESS) {
                        if (myTags[index].getMemoryBankData().length() > 0) {
                            log( " Mem Bank Data " + myTags[index].getMemoryBankData());
                        }
                    }
                    if (myTags[index].isContainsLocationInfo()) {
                        short dist = myTags[index].LocationInfo.getRelativeDistance();
                        relativeDistanceList.add(String.valueOf(dist));
                        log( "Tag relative distance " + dist);
                    }
                }

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
//                        plugin.notifyRfidData(rfidList);
                        if(rfidList != null && !rfidList.isEmpty()){
                            log( "rfidList:  " + rfidList);
//                            plugin.notifyRfidData(rfidList);
                        }
                        if(relativeDistanceList != null && !relativeDistanceList.isEmpty()){
                            log( "relativeDistanceList:  " + relativeDistanceList);
//                            plugin.notifyRfidLocatingData(relativeDistanceList);
                        }
                    }
                });
            }
        }

        // Status Event Notification
        public void eventStatusNotify(RfidStatusEvents rfidStatusEvents) {
            log( "Status Notification: " + rfidStatusEvents.StatusEventData.getStatusEventType());
            if (rfidStatusEvents.StatusEventData.getStatusEventType() == STATUS_EVENT_TYPE.DISCONNECTION_EVENT) {
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
//                        plugin.notifyReaderConnectionStatus(false, reader.getHostName());
                    }
                });
                disconnect();
            }
            if (rfidStatusEvents.StatusEventData.getStatusEventType() == STATUS_EVENT_TYPE.HANDHELD_TRIGGER_EVENT) {
                if (rfidStatusEvents.StatusEventData.HandheldTriggerEventData
                        .getHandheldEvent() == HANDHELD_TRIGGER_EVENT_TYPE.HANDHELD_TRIGGER_PRESSED) {
                    new AsyncTask<Void, Void, Void>() {
                        @Override
                        protected Void doInBackground(Void... voids) {
                            startInventory();
                            return null;
                        }
                    }.execute();
                }
                if (rfidStatusEvents.StatusEventData.HandheldTriggerEventData
                        .getHandheldEvent() == HANDHELD_TRIGGER_EVENT_TYPE.HANDHELD_TRIGGER_RELEASED) {
                    new AsyncTask<Void, Void, Void>() {
                        @Override
                        protected Void doInBackground(Void... voids) {
                            stopInventroy();
                            return null;
                        }
                    }.execute();
                }
            }
        }
    }

    private class ConnectionTask extends AsyncTask<Void, Void, String> {



        @Override
        protected String doInBackground(Void... voids) {
            Log.d(TAG, "ConnectionTask");

            if (reader != null) {
                boolean result = connectToReader();
                return result ? "success" : "fail";
            }
            return "fail";
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);
//            if (result == "success") {
//                lastConnectedReaderName = scannerName;
////                plugin.notifyReaderConnectionStatus(true, reader.getHostName());
//            } else {
//                // send fail signal to flutter
////                plugin.notifyReaderConnectionStatus(false, reader.getHostName());
//            }
        }
    }

    private void log(String msg){
        Log.d(TAG, msg);
    }

    private synchronized boolean connectToReader() {
        if (reader != null) {
            Log.d(TAG, "1");
            Log.d(TAG, "MIXSON");
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
                disconnect();
            }
        }
    }
}
