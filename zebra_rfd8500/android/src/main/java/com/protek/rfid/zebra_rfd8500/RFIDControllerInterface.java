package com.protek.rfid.zebra_rfd8500;
import java.util.ArrayList;
//import io.flutter.plugin.common.MethodChannel.Result;
import java.util.HashMap;

interface RFIDControllerInterface{
    public ArrayList<String> getAvailableRFIDReaderList();
    public String performTagLocating(String rfid);
    public String stopTagLocating();
    public boolean isReaderConnected();
    public void setAntennaPower (Integer power);
    public int getAntennaPower();
    public HashMap<String, String> getConnectedScannerInfo();
    public boolean connectToScanner();
    public boolean connectToScanner(String scannerName);
    public boolean disconnectToScanner();
    public boolean startInventory();
    public boolean stopInventory();


}