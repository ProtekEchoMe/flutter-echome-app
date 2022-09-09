package com.protek.rfid.zebra_rfd8500.RFIDReader;

import android.util.Log;
import com.rscja.deviceapi.RFIDWithUHFUART;
import com.zebra.rfid.api3.Readers;

import java.util.ArrayList;
import java.util.HashMap;

public class rfidReader implements rfidReaderInterface{

    String TAG = "rfidReader";
    rfidReader(RFIDWithUHFUART reader){
        aiReader = reader;
    }

    rfidReader(Readers reader){
        zebraReader = reader;
    }

    rfidReader(rfidReaderInterface reader){

    }

    private RFIDWithUHFUART aiReader = null;
    private Readers zebraReader = null;

    public rfidReader() {

    }


    @Override
    public boolean connect() {
        return false;
    }

    @Override
    public boolean disconnect() {
        return false;
    }

    @Override
    public boolean startInventory() {
        return false;
    }

    @Override
    public boolean stopInventroy() {
        return false;
    }

    @Override
    public String readSingleTag() {
        return null;
    }

    @Override
    public boolean setPower(int power) {
        return false;
    }

    @Override
    public int getPower() {
        return 0;
    }

    @Override
    public boolean performTagLocating() {
        return false;
    }

    @Override
    public boolean stopTagLocating() {
        return false;
    }

    public void toastMessage(String msg) {
        Log.d(TAG, msg);;
    }

    public ArrayList<HashMap<String, String>> getTagList(){
        ArrayList<HashMap<String, String>> a = new ArrayList<HashMap<String, String>>();
        HashMap<String, String> b = new HashMap<String, String>();
        b.put("1", "2");
        a.add(b);
        return a;
    }
}
