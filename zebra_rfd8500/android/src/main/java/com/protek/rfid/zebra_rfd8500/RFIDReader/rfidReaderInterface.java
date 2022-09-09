package com.protek.rfid.zebra_rfd8500.RFIDReader;

import java.util.ArrayList;
import java.util.List;

public interface rfidReaderInterface {
    public boolean connect();

    public boolean disconnect();

    public boolean startInventory();
    public boolean stopInventroy();

    public String readSingleTag();

    public boolean setPower(int power);
    public int getPower();
    public String performTagLocating(String rfid);
    public boolean stopTagLocating();




}
