package com.protek.rfid.zebra_rfd8500.data;

import com.zebra.rfid.api3.InvalidUsageException;
import com.zebra.rfid.api3.OperationFailureException;
import com.zebra.rfid.api3.RFIDReader;

import java.util.HashMap;

public class ScannerData {
    private static String TAG = "SCANNERDATA";

    private String readerId;
    private String modelName;
    private String communicationStandard;
    private String countryCode;
    private String rssiFilter;
    private String isTagEvenReportingSupported;
    private String isTagLocationingSupported;
    private String isNXPCommandSupported;
    private String numAntennaSupported;
    private String antennaPower;
    private RFIDReader reader;

    public ScannerData(String readerId, String modelName, String communicationStandard, String countryCode, String rssiFilter, String isTagEvenReportingSupported, String isTagLocationingSupported, String isNXPCommandSupported, String numAntennaSupported, String antennaPower, RFIDReader reader) {
        this.readerId = readerId;
        this.modelName = modelName;
        this.communicationStandard = communicationStandard;
        this.countryCode = countryCode;
        this.rssiFilter = rssiFilter;
        this.isTagEvenReportingSupported = isTagEvenReportingSupported;
        this.isTagLocationingSupported = isTagLocationingSupported;
        this.isNXPCommandSupported = isNXPCommandSupported;
        this.numAntennaSupported = numAntennaSupported;
        this.antennaPower = antennaPower;
        this.reader = reader;
    }

    public ScannerData(RFIDReader reader){
        this.reader = reader;
        this.readerId = String.valueOf(reader.ReaderCapabilities.ReaderID.getID());
        this.communicationStandard = String.valueOf(reader.ReaderCapabilities.getModelName());
        this.communicationStandard = String.valueOf(reader.ReaderCapabilities.getCommunicationStandard());
        this.countryCode = String.valueOf(reader.ReaderCapabilities.getCountryCode());
        this.rssiFilter = String.valueOf(reader.ReaderCapabilities.isRSSIFilterSupported());
        this.isTagEvenReportingSupported = String.valueOf(reader.ReaderCapabilities.isTagEventReportingSupported());
        this.isTagLocationingSupported = String.valueOf(reader.ReaderCapabilities.isTagLocationingSupported());
        this.isTagEvenReportingSupported = String.valueOf(reader.ReaderCapabilities.isNXPCommandSupported());
        this.numAntennaSupported = String.valueOf(reader.ReaderCapabilities.getNumAntennaSupported());
        try{
            this.antennaPower = String.valueOf(reader.Config.Antennas.getAntennaConfig(1).getTransmitPowerIndex());
        } catch (InvalidUsageException e) {
            e.printStackTrace();
            this.antennaPower = "-1";
        } catch (OperationFailureException e) {
            e.printStackTrace();
            this.antennaPower = "-1";
        }
    }

    public ScannerData(){}

    public String getReaderId() {
        return readerId;
    }

    public void setReaderId(String readerId) {
        this.readerId = readerId;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getCommunicationStandard() {
        return communicationStandard;
    }

    public void setCommunicationStandard(String communicationStandard) {
        this.communicationStandard = communicationStandard;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getRssiFilter() {
        return rssiFilter;
    }

    public void setRssiFilter(String rssiFilter) {
        this.rssiFilter = rssiFilter;
    }

    public String getIsTagEvenReportingSupported() {
        return isTagEvenReportingSupported;
    }

    public void setIsTagEvenReportingSupported(String isTagEvenReportingSupported) {
        this.isTagEvenReportingSupported = isTagEvenReportingSupported;
    }

    public String getIsTagLocationingSupported() {
        return isTagLocationingSupported;
    }

    public void setIsTagLocationingSupported(String isTagLocationingSupported) {
        this.isTagLocationingSupported = isTagLocationingSupported;
    }

    public String getIsNXPCommandSupported() {
        return isNXPCommandSupported;
    }

    public void setIsNXPCommandSupported(String isNXPCommandSupported) {
        this.isNXPCommandSupported = isNXPCommandSupported;
    }

    public String getNumAntennaSupported() {
        return numAntennaSupported;
    }

    public void setNumAntennaSupported(String numAntennaSupported) {
        this.numAntennaSupported = numAntennaSupported;
    }

    public String getAntennaPower() {
        return antennaPower;
    }

    public void setAntennaPower(String antennaPower) {
        this.antennaPower = antennaPower;
    }

    public RFIDReader getReader() {
        return reader;
    }

    public void setReader(RFIDReader reader) {
        this.reader = reader;
    }

    @Override
    public String toString() {
        return "ScannerData{" +
                "readerId='" + readerId + '\'' +
                ", modelName='" + modelName + '\'' +
                ", communicationStandard='" + communicationStandard + '\'' +
                ", countryCode='" + countryCode + '\'' +
                ", rssiFilter='" + rssiFilter + '\'' +
                ", isTagEvenReportingSupported='" + isTagEvenReportingSupported + '\'' +
                ", isTagLocationingSupported='" + isTagLocationingSupported + '\'' +
                ", isNXPCommandSupported='" + isNXPCommandSupported + '\'' +
                ", numAntennaSupported='" + numAntennaSupported + '\'' +
                ", antennaPower='" + antennaPower + '\'' +
                ", reader=" + reader +
                '}';
    }

    public HashMap<String, String> toHashMap(){
        HashMap<String, String>  map = new HashMap<String, String>();
        map.put("readerId", String.valueOf(readerId));
        map.put("modelName", String.valueOf(modelName));
        map.put("communicationStandard", String.valueOf(communicationStandard));
        map.put("countryCode", String.valueOf(countryCode));
        map.put("rssiFilter",  String.valueOf(rssiFilter));
        map.put("isTagEvenReportingSupported",  String.valueOf(isTagEvenReportingSupported));
        map.put("isTagLocationingSupported",  String.valueOf(isTagLocationingSupported));
        map.put("isNXPCommandSupported",  String.valueOf(isNXPCommandSupported));
        map.put("numAntennaSupported", String.valueOf(numAntennaSupported));
        map.put("antennaPower", String.valueOf(antennaPower));
        return map;
    }

    // map.put("readerId", String.valueOf(reader.ReaderCapabilities.ReaderID.getID()));
    //        map.put("modelName", String.valueOf(reader.ReaderCapabilities.getModelName()));
    //        map.put("communicationStandard", String.valueOf(reader.ReaderCapabilities.getCommunicationStandard()));
    //        map.put("countryCode", String.valueOf(reader.ReaderCapabilities.getCountryCode()));
    //        map.put("rssiFilter",  String.valueOf(reader.ReaderCapabilities.isRSSIFilterSupported()));
    //        map.put("isTagEvenReportingSupported",  String.valueOf(reader.ReaderCapabilities.isTagEventReportingSupported()));
    //        map.put("isTagLocationingSupported",  String.valueOf(reader.ReaderCapabilities.isTagLocationingSupported()));
    //        map.put("isNXPCommandSupported",  String.valueOf(reader.ReaderCapabilities.isNXPCommandSupported()));
    //        map.put("numAntennaSupported", String.valueOf(reader.ReaderCapabilities.getNumAntennaSupported()));
    //        map.put("antennaPower", String.valueOf(reader.Config.Antennas.getAntennaConfig(1).getTransmitPowerIndex()));
    //        Log.d(TAG, "getConnectedScannerInfo");
}
