class ScannerData {
  String readerId = "";
  String modelName= "";
  String communicationStandard = "";
  String countryCode = "";
  String rssiFilter = "";
  String isTagEvenReportingSupported = "";
  String isTagLocationingSupported = "";
  String isNXPCommandSupported = "";
  String numAntennaSupported = "";
  String antennaPower = "";

  ScannerData(
      {this.readerId = "",
      this.modelName = "",
      this.communicationStandard = "",
      this.countryCode = "",
      this.rssiFilter = "",
      this.isTagEvenReportingSupported = "",
      this.isNXPCommandSupported = "",
      this.numAntennaSupported = "",
      this.antennaPower = ""});

  
}
