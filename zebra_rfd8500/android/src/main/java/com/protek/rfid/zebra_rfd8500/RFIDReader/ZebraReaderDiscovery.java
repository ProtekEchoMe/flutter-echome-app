package com.protek.rfid.zebra_rfd8500.RFIDReader;

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

public class ZebraReaderDiscovery implements Readers.RFIDReaderEventHandler{
    private String TAG = "ZebraReaderDiscovery";
    private Context context;

    private static RFIDReader reader;
    private static Readers readers;
    private static ArrayList<ReaderDevice> availableRFIDReaderList;
    private static ReaderDevice readerDevice;
    private static String lastConnectedReaderName;

    public ZebraReaderDiscovery(Context context) {
        this.context = context;
        readers = new Readers(context, ENUM_TRANSPORT.BLUETOOTH);
        Log.d(TAG, "Attach set");
    }

    public ArrayList<String> getAvailableRFIDReaderList() throws InvalidUsageException {


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


//    private synchronized ArrayList<ReaderDevice> getAvailableReader() throws InvalidUsageException {
//        Log.d(TAG, "GetAvailableReader");
//        return readers.GetAvailableRFIDReaderList();
//    }

    public synchronized RFIDReader getZebraReader(String scannerName) throws InvalidUsageException {
        Log.d(TAG, "GetAvailableReader");
        if (readers != null) {
            readers.attach(this);
            if (readers.GetAvailableRFIDReaderList() != null) {
                availableRFIDReaderList = readers.GetAvailableRFIDReaderList();

                for (ReaderDevice device : availableRFIDReaderList) {
                    if (device.getName().equals(scannerName)) {
                        readerDevice = device;
                        return reader;
//                        reader = readerDevice.getRFIDReader();
//                        return reader;
                    }
                }
            }
        }
        return null;
    }



    @Override
    public void RFIDReaderAppeared(ReaderDevice readerDevice) {
        Log.d(TAG, "RFIDReaderAppeared " + readerDevice.getName());
    }

    @Override
    public void RFIDReaderDisappeared(ReaderDevice readerDevice) {
        Log.d(TAG, "RFIDReaderDisappeared " + readerDevice.getName());
    }


}
