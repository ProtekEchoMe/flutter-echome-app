class EquipmentData {
  int? id;
  String? regNum;
  String? toNum;
  String? tiNum;
  String? containerCode;
  String? containerAssetCode;
  String? rfid;
  String? status;
  int? version;
  int? createdDate;

  EquipmentData(
      {this.id,
      this.regNum,
      this.toNum,
      this.tiNum,
        this.containerCode,
      this.containerAssetCode,
      this.rfid,
      this.status,
      this.version,
      this.createdDate});

  EquipmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regNum = json['regNum'];
    toNum = json['toNum'];
    tiNum = json['tiNum'];
    containerCode = json['containerCode'];
    containerAssetCode = json['containerAssetCode'];
    rfid = json['rfid'];
    status = json['status'];
    version = json['version'];
    createdDate = json['createdDate'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['regNum'] = regNum;
    data['toNum'] = toNum;
    data['tiNum'] = tiNum;
    data['containerCode'] = containerCode;
    data['containerAssetCode'] = containerAssetCode;
    data['rfid'] = rfid;
    data['status'] = status;
    data['version'] = version;
    data['createdDate'] = createdDate;
    return data;
  }
}