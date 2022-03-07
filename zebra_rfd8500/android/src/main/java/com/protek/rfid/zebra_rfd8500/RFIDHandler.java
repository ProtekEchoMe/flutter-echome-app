package com.protek.rfid.zebra_rfd8500;

import com.zebra.rfid.api3.RFIDReader;
import com.zebra.rfid.api3.ReaderDevice;
import com.zebra.rfid.api3.Readers;

import java.io.Reader;
import java.lang.reflect.Array;
import java.util.ArrayList;

public class RFIDHandler {

    public Readers readers;
    public boolean isReaderConnected = false;
    public RFIDReader mRFIDReader;

    RFIDHandler(Readers readers){
        this.readers = readers;
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

    void connect(){
        
    }
}
