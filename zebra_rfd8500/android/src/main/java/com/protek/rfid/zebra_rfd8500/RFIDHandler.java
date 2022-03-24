package com.protek.rfid.zebra_rfd8500;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;

import com.zebra.rfid.api3.*;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.Reader;
import java.lang.reflect.Array;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

public class RFIDHandler implements Readers.RFIDReaderEventHandler  {
    public String TAG = "RFIDHandler";
    public ReaderDevice mConnectedReaderDevice;
    private static RFIDReader reader;
    public static Readers readers;
    public RFIDReader mRFIDReader;
    private EventChannel.EventSink sink = null;
    private EventHandler eventHandler;
    private Context context;

    RFIDHandler(Readers readers, Context context){
        this.readers = readers;
        this.context = context;
    }

    public void setEventSink(EventChannel.EventSink _sink){
        sink = _sink;
    }

    ArrayList<String> getAvailableRFIDReaderList(){
        ArrayList<String> result = new ArrayList<String>();
        ArrayList<ReaderDevice> list = readers.GetAvailableRFIDReaderList();
        for (int i = 0; i < list.size(); i++) {
            String hostName = list.get(i).getRFIDReader().getHostName();
            result.add(hostName);
        }
        return result;
    }

    void connectRFIDReader (String hostName, Result result){
        Log.d(TAG, "connectRFIDReader");
        new ConnectionTask(result, hostName).execute();
    }

    void setAntennaPower (Integer power) throws InvalidUsageException, OperationFailureException {
        RFIDReader reader = this.reader;
        Antennas.AntennaRfConfig antennaRfConfig = reader.Config.Antennas.getAntennaRfConfig(1);
        antennaRfConfig.setTransmitPowerIndex(power);
        reader.Config.Antennas.setAntennaRfConfig(1,antennaRfConfig);
    }

    void getConnectedScannerInfo (Result result) throws InvalidUsageException, OperationFailureException {
//        Log.d(TAG, "getConnectedScannerInfo");
        if(mConnectedReaderDevice == null || reader.isConnected() == false){
            result.error("error", "No connected Device", "");
            return;
        }
        RFIDReader reader = this.reader;
        HashMap<String, String> map = new HashMap<String, String>();
        map.put("readerId", String.valueOf(reader.ReaderCapabilities.ReaderID.getID()));
        map.put("modelName", String.valueOf(reader.ReaderCapabilities.getModelName()));
        map.put("communicationStandard", String.valueOf(reader.ReaderCapabilities.getCommunicationStandard()));
        map.put("countryCode", String.valueOf(reader.ReaderCapabilities.getCountryCode()));
        map.put("rssiFilter",  String.valueOf(reader.ReaderCapabilities.isRSSIFilterSupported()));
        map.put("isTagEvenReportingSupported",  String.valueOf(reader.ReaderCapabilities.isTagEventReportingSupported()));
        map.put("isTagLocationingSupported",  String.valueOf(reader.ReaderCapabilities.isTagLocationingSupported()));
        map.put("isNXPCommandSupported",  String.valueOf(reader.ReaderCapabilities.isNXPCommandSupported()));
        map.put("numAntennaSupported", String.valueOf(reader.ReaderCapabilities.getNumAntennaSupported()));
        map.put("antennaPower", String.valueOf(reader.Config.Antennas.getAntennaConfig(1).getTransmitPowerIndex()));
        Log.d(TAG, "getConnectedScannerInfo");
        result.success(map);
//
////
////        System.out.println("\nBlockEraseSupport: " + reader.ReaderCapabilities.isBlockEraseSupported());
////        System.out.println("\nBlockWriteSupport: " + reader.ReaderCapabilities.isBlockWriteSupported());
////        System.out.println("\nBlockPermalockSupport: " + reader.ReaderCapabilities.isBlockPermalockSupported());
////        System.out.println("\nRecommisionSupport: " + reader.ReaderCapabilities.isRecommisionSupported());
////        System.out.println("\nWriteWMISupport: " + reader.ReaderCapabilities.isWriteUMISupported());
////        System.out.println("\nRadioPowerControlSupport: " + reader.ReaderCapabilities.isRadioPowerControlSupported());System.out.println("\nHoppingEn abled: " + reader.ReaderCapabilities.isHoppingEnabled());
////        System.out.println("\nStateAwareSingulationCapable: " + reader.ReaderCapabilities.isTagInventoryStateAwareSingulationSupported());
////        System.out.println("\nUTCClockCapable: " + reader.ReaderCapabilities.isUTCClockSupported());System.out.println("\nNumOperationsInAcc essSequence: " + reader.ReaderCapabilities.getMaxNumOperationsInAccessSequence());
////        System.out.println("\nNumPreFilters: " + reader.ReaderCapabilities.getMaxNumPreFilters());
////        System.out.println("\nNumAntennaSupported: " + reader.ReaderCapabilities.getNumAntennaSupported());
//
//        result.success("ok");
//        Log.d(TAG, "sent");
//        return;
    }

    private class ConnectionTask extends AsyncTask<Void, Void, String> {
        MethodChannel.Result result;
        String hostName;
        ConnectionTask(MethodChannel.Result result, String hostName){
            this.result = result;
            this.hostName = hostName;
        }

        ConnectionTask(MethodChannel.Result result){
            this.result = result;
            this.hostName = null;
        }


        String TAG = "ASYNC CONNECTION TASK";

        private synchronized String connect() {
            if (reader != null) {
                android.util.Log.d(TAG, "connect " + reader.getHostName());
                try {
                    if (!reader.isConnected()) {
                        // Establish connection to the RFID Reader
                        reader.connect();
                        ConfigureReader();
                        return "Connected";
                    }
                } catch (InvalidUsageException e) {
                    e.printStackTrace();
                } catch (OperationFailureException e) {
                    e.printStackTrace();
                    android.util.Log.d(TAG, "OperationFailureException " + e.getVendorMessage());
                    String des = e.getResults().toString();
                    return "Connection failed" + e.getVendorMessage() + " " + des;
                }
            }
            return "";
        }


        @Override
        protected String doInBackground(Void... voids) {
            Log.d(TAG,"doInBackground");
            ArrayList<ReaderDevice> list = readers.GetAvailableRFIDReaderList();
                if(this.hostName == null){
                    ReaderDevice readerDevice = list.get(0);
                    mConnectedReaderDevice = readerDevice;
                    reader = readerDevice.getRFIDReader();
                    connect();
                    Log.d(TAG,"1");
                    return "done";
                }

                for (int i = 0; i < list.size(); i++) {
                    ReaderDevice readerDevice = list.get(i);
                    String hostName = readerDevice.getRFIDReader().getHostName();
                    if(hostName.equals(this.hostName)){
                        Log.d(TAG,"2");
                        mConnectedReaderDevice = readerDevice;
                        reader = readerDevice.getRFIDReader();
                        connect();
                        return "done";
                    }
                }
            return "error";
        }

        @Override
        protected void onPostExecute(String result){
            Log.d(TAG, result);
            super.onPostExecute(result);
            if(result == "done"){
                this.result.success(reader.getHostName());
            }else {
                this.result.error("error", "can't connect reader", "");
            }
        }


    }



    @Override
    public void RFIDReaderAppeared(ReaderDevice readerDevice) {

    }

    @Override
    public void RFIDReaderDisappeared(ReaderDevice readerDevice) {

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
                // tag event with tag data
                reader.Events.setTagReadEvent(true);
                reader.Events.setAttachTagDataWithReadEvent(false);
                // set trigger mode as rfid so scanner beam will not come
                Log.d(TAG, "ConfigureReader " + "444");
                reader.Config.setTriggerMode(ENUM_TRIGGER_MODE.RFID_MODE, true);
                Log.d(TAG, "ConfigureReader " + "666");
                // set start and stop triggers
                reader.Config.setStartTrigger(triggerInfo.StartTrigger);
                reader.Config.setStopTrigger(triggerInfo.StopTrigger);
                
                // set antenna configurations
                Antennas.AntennaRfConfig config = reader.Config.Antennas.getAntennaRfConfig(1);
//                config.setrfModeTableIndex(0);
//                config.setTari(0);
//                reader.Config.Antennas.setAntennaRfConfig(1, config);
                // Set the singulation control
//                Antennas.SingulationControl s1_singulationControl = reader.Config.Antennas.getSingulationControl(1);
//                s1_singulationControl.setSession(SESSION.SESSION_S0);
//                s1_singulationControl.Action.setInventoryState(INVENTORY_STATE.INVENTORY_STATE_A);
//                s1_singulationControl.Action.setSLFlag(SL_FLAG.SL_ALL);
//                reader.Config.Antennas.setSingulationControl(1, s1_singulationControl);
                // delete any prefilters
               reader.Actions.PreFilters.deleteAll();
            } catch (InvalidUsageException | OperationFailureException e) {
                e.printStackTrace();
            }
        }
    }

    private synchronized void disconnect() {
        Log.d(TAG, "disconnect " + reader);
        try {
            if (mConnectedReaderDevice!= null) {
                reader.Events.removeEventsListener(eventHandler);
                reader.disconnect();
            }
        } catch (InvalidUsageException e) {
            e.printStackTrace();
        } catch (OperationFailureException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void handleTriggerPress(boolean pressed){
        if(pressed){
            Log.d(TAG, "PERFORMINVENTROY");
            performInventory();
        }else {
            Log.d(TAG, "STOPINVENTROY");
            stopInventory();
        }
    }

    private boolean isReaderConnected() {
        if (mConnectedReaderDevice != null && reader.isConnected())
            return true;
        else {
            Log.d(TAG, "reader is not connected");
            return false;
        }
    }


    synchronized void performInventory(){
        if(!isReaderConnected()){
            return;
        }
        try {
            Log.d(TAG, "111");
            reader.Actions.Inventory.perform();
        }catch (InvalidUsageException e){
            e.printStackTrace();
        }catch (OperationFailureException e){
            e.printStackTrace();
        }
    }

    synchronized void stopInventory(){
        if(!isReaderConnected()){
            return;
        }
        try {
            Log.d(TAG, "222");
            reader.Actions.Inventory.stop();
        }catch (InvalidUsageException e){
            e.printStackTrace();
        }catch (OperationFailureException e){
            e.printStackTrace();
        }
    }


    public class EventHandler implements RfidEventsListener {
        public String TAG = "EventHandler";
        // Read Event Notification
        @Override
        public void eventReadNotify(RfidReadEvents e) {
            Log.d(TAG, "eventReadNotify ");
            // Recommended to use new method getReadTagsEx for better performance in case of large tag population
            TagData[] myTags = reader.Actions.getReadTags(100);
            if(myTags != null){
                ArrayList<String> data = new ArrayList<String>();
                for(int index = 0; index < myTags.length; index++){
                    String tagId = myTags[index].getTagID();
                    data.add(tagId);
                }
                if(sink != null){
             new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            sink.success(data);
                        }
                    });

                }
            }
//            if (myTags != null) {
//                for (int index = 0; index < myTags.length; index++) {
//                    Log.d(TAG, "Tag ID " + myTags[index].getTagID());
//                    if (myTags[index].getOpCode() == ACCESS_OPERATION_CODE.ACCESS_OPERATION_READ &&
//                            myTags[index].getOpStatus() == ACCESS_OPERATION_STATUS.ACCESS_SUCCESS) {
//                        if (myTags[index].getMemoryBankData().length() > 0) {
//                            Log.d(TAG, " Mem Bank Data " + myTags[index].getMemoryBankData());
//                        }
//                    }
//                    if (myTags[index].isContainsLocationInfo()) {
//                        short dist = myTags[index].LocationInfo.getRelativeDistance();
//                        Log.d(TAG, "Tag relative distance " + dist);
//                    }
//                }
//                // possibly if operation was invoked from async task and still busy
//                // handle tag data responses on parallel thread thus THREAD_POOL_EXECUTOR
//                for (int index = 0; index < myTags.length; index++) {
//                    Log.d(TAG,"TAG getted "+ myTags[index].getTagID());
//                }
//            }
        }

        // Status Event Notification
        @Override
        public void eventStatusNotify(RfidStatusEvents rfidStatusEvents) {
            Log.d(TAG, "Status Notification: " + rfidStatusEvents.StatusEventData.getStatusEventType());
            if (rfidStatusEvents.StatusEventData.getStatusEventType() == STATUS_EVENT_TYPE.HANDHELD_TRIGGER_EVENT) {
                if (rfidStatusEvents.StatusEventData.HandheldTriggerEventData.getHandheldEvent() == HANDHELD_TRIGGER_EVENT_TYPE.HANDHELD_TRIGGER_PRESSED) {
                    new AsyncTask<Void, Void, Void>() {
                        @Override
                        protected Void doInBackground(Void... voids) {
                            handleTriggerPress(true);
                            return null;
                        }
                    }.execute();
                }
                if (rfidStatusEvents.StatusEventData.HandheldTriggerEventData.getHandheldEvent() == HANDHELD_TRIGGER_EVENT_TYPE.HANDHELD_TRIGGER_RELEASED) {
                    new AsyncTask<Void, Void, Void>() {
                        @Override
                        protected Void doInBackground(Void... voids) {
                            handleTriggerPress(false);
                            return null;
                        }
                    }.execute();
                }
            }
        }
    }

}
