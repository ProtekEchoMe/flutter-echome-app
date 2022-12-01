class RfidTagItem {
  int? id;
  int? regLineId;
  String? regNum;
  Null? toNum;
  Null? tiNum;
  String? itemAssetCode;
  String? skuCode;
  String? rfid;
  String? status;
  int? version;
  int? createdDate;

  RfidTagItem(
      {this.id,
        this.regLineId,
        this.regNum,
        this.toNum,
        this.tiNum,
        this.itemAssetCode,
        this.skuCode,
        this.rfid,
        this.status,
        this.version,
        this.createdDate});

  RfidTagItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regLineId = json['regLineId'];
    regNum = json['regNum'];
    toNum = json['toNum'];
    tiNum = json['tiNum'];
    itemAssetCode = json['itemAssetCode'];
    skuCode = json['skuCode'];
    rfid = json['rfid'];
    status = json['status'];
    version = json['version'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['regLineId'] = regLineId;
    data['regNum'] = regNum;
    data['toNum'] = toNum;
    data['tiNum'] = tiNum;
    data['itemAssetCode'] = itemAssetCode;
    data['skuCode'] = skuCode;
    data['rfid'] = rfid;
    data['status'] = status;
    data['version'] = version;
    data['createdDate'] = createdDate;
    return data;
  }
}