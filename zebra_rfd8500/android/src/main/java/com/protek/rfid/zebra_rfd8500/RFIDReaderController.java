package com.protek.rfid.zebra_rfd8500;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.exception.ConfigurationException;
import com.rscja.deviceapi.interfaces.IUHFLocationCallback;
import com.zebra.rfid.api3.*;
import io.flutter.plugin.common.MethodChannel.Result;
import com.protek.rfid.zebra_rfd8500.RFIDReader.*;

import java.util.ArrayList;
import java.util.HashMap;



class RFIDReaderController implements RFIDControllerInterface{


    private ZebraReaderDiscovery zebraReaderDiscovery;
    private ZebraReader zebraReader;
    private AIReader aiReader;
    private RFIDReader rfidReader;

    final static String TAG = "RFIDReaderController_AI";
    // RFID Reader
    public static rfidReader reader;
    // Context
    private Context context;
    // general
    private ZebraRfd8500Plugin plugin;

    private RFIDHandlerHelper rfidHandlerHelper;


    private boolean isAIReaderConnected = false;
    private boolean isZebraReaderConnected = false;



    private int MAX_POWER = 270;
    // In case of RFD8500 change reader name with intended device below from list of
    // paired RFD8500

    RFIDReaderController(Context context, ZebraRfd8500Plugin plugin) {
        this.context = context;
        zebraReaderDiscovery = new ZebraReaderDiscovery(context);
//        RFIDHandleHelper = new RFIDHandleHelper(context, plugin);
        this.plugin = plugin;
//        rfidHandleTagData = new RFIDHandleTagData(this);
        Log.d(TAG, "Attach set");
    }

    public ArrayList<String> getAvailableRFIDReaderList() {

//        if (reader != null && reader.isConnected()) {
//            disconnect(true);
//        }
//
//        ArrayList<String> result = new ArrayList<String>();
//        ;
//        if (readers == null) {
//            Log.d(TAG, "Reader is null");
//        }
//        ArrayList<ReaderDevice> list = readers.GetAvailableRFIDReaderList();
//        Log.d(TAG, "GET LIST SUCCESS");
//        for (int i = 0; i < list.size(); i++) {
//            String hostName = list.get(i).getRFIDReader().getHostName();
//            result.add(hostName);
//        }
        try {
            return zebraReaderDiscovery.getAvailableRFIDReaderList();
        }catch (Exception ex){
            ex.printStackTrace();
        }
        return new ArrayList<String>();

    }

    public boolean connectToAIReader() {
        try {
            aiReader = new AIReader(RFIDWithUHFUART.getInstance(), plugin);
            aiReader.connect();
            reader = aiReader;
            return true;
        }catch (ConfigurationException ex){
            ex.printStackTrace();
            return false;
        }
    }

    boolean connectToZebraReader(String scannerName) {
        try {

            zebraReader = new ZebraReader(zebraReaderDiscovery.getZebraReader(scannerName));
            zebraReader.connect();
            reader = zebraReader;
            return true;
        }catch (ConfigurationException | InvalidUsageException ex){
            ex.printStackTrace();
            return false;
        }catch (Exception ex){
            ex.printStackTrace();
            return false;
        }
    }

    boolean disConnectToAIReader() {
        try {
            aiReader.disconnect();
            return true;
        }catch (Exception ex){
            ex.printStackTrace();
            return false;
        }
    }

    public boolean startInventory() {
        reader.startInventory();
        return true;
    }

    public boolean stopInventory() {
        reader.stopInventroy();
        return true;
    }


    @Override
    public String performTagLocating(String rfid){
        Log.d(TAG, "ai performTagLocating is called");
        IUHFLocationCallback locationCallback = new IUHFLocationCallback() {
            @Override
            public void getLocationValue(int i) {
                Log.d("locationValue", String.valueOf(i));
                ArrayList<String> relativeDistanceList = new ArrayList<String>();
                relativeDistanceList.add(String.valueOf(i));

                Log.d(TAG, "Tag relative distance " + i);
                plugin.notifyRfidLocatingData(relativeDistanceList);
            }
        };

        aiReader.setLocationCallback(locationCallback);
        reader.performTagLocating(rfid);
//        rfidHandleTagData.performTagLocating(rfid);
//        rfidHandleTagData.performTagLocating("4341544C303130303030303637343330");
//        readers.Actions.TagLocationing.Perform("123", null, null);
        return "Success";
    }

    public String stopTagLocating(){
        Log.d(TAG, "String stopTagLocating is called");
        reader.stopTagLocating();
//        rfidHandleTagData.stopTagLocating();
//        readers.Actions.TagLocationing.Perform("123", null, null);
        return "Success";
    }


    public boolean isReaderConnected() {
//        if (reader != null && reader.isConnected())
//            return true;
//        else {
//            Log.d(TAG, "reader is not connected");
//            return false;
//        }
        return true;
    }

    public void setAntennaPower (Integer power) {
//        Log.d(TAG, "setAntennaPower Java is called");
//        RFIDReader reader = this.reader;
//        Log.d(TAG, "setAntennaPower Java is called");
////        Log.d(TAG, power);
//
//        Antennas.AntennaRfConfig antennaRfConfig = reader.Config.Antennas.getAntennaRfConfig(1);
//        antennaRfConfig.setTransmitPowerIndex(power);
//        reader.Config.Antennas.setAntennaRfConfig(1,antennaRfConfig);
//    }
//    ArrayList<String> getAntennaPower(){
//        int[] powerLevels;
//        Log.d(TAG, "getAntennaPower Java is called");
//
//        powerLevels = reader.ReaderCapabilities.getTransmitPowerLevelValues();
//
//        ArrayList<String> result = new ArrayList<String>();
//        ;
//        if (readers == null) {
//            Log.d(TAG, "Reader is null");
//        }
//
//        Log.d(TAG, "GET Power LIST SUCCESS");
////        Log.d(TAG, powerLevels);
//        for (int i = 0; i < powerLevels.length; i++) {
//            String power = Integer.toString(powerLevels[i]);
//            result.add(power);
//        }
//        return result;
        try {
            reader.setPower(power);
        }catch (Exception ex){
            ex.printStackTrace();
        }
    }

    //    void getConnectedScannerInfo (Result result) throws InvalidUsageException, OperationFailureException {
    public void getConnectedScannerInfo (Result result){
//        Log.d(TAG, "getConnectedScannerInfo");
//        if(reader.isConnected() == false){
//            result.error("error", "No connected Device", "");
//            return;
//        }
//        RFIDReader reader = this.reader;
//        ScannerData scannerData = new ScannerData(reader);
//        result.success(scannerData.toHashMap());
    }

    //
    // Activity life cycle behavior
    //
    @Override
    public int getAntennaPower() {
        return reader.getPower();
    }

    @Override
    public HashMap<String, String> getConnectedScannerInfo() {
        return null;
    }

    @Override
    public boolean connectToScanner() {
        return connectToAIReader();
    }

    boolean onResume() {
//        return connect();
        return true;
    }

    void onPause() {
//        disconnect(true);
    }

    void onDestroy() {
        dispose();
    }

    //
    // RFID SDK
    //

    public boolean connectToScanner(String scannerName) {
        Log.d(TAG, "connectToScanner");
        return true;
    }

    public boolean disconnectToScanner(){
        return disConnectToAIReader();

    };




    public void connectRFIDReader() {

    }



    private synchronized void dispose() {
//        try {
//            if (readers != null) {
//                reader = null;
//                readers.Dispose();
//                readers = null;
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }


    interface ResponseHandlerInterface {
        void handleTagData(TagData[] tagData);

        void handleTriggerPress(boolean pressed);
        // void handleStatusEvents(Events.StatusEventData eventData);
    }


}
