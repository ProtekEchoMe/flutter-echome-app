// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class StockTakeLineItem {
  int? id;
  int? site;
  String? stNum;
  int? invId;
  int? containerId;
  String? itemAssetCode;
  String? containerAssetCode;
  String? skuCode;
  String? containerCode;
  String? locCode;
  String? stocktakeLocCode;
  String? status;
  String? invStatus;
  String? reason;
  int? stocktakeDate;
  int? createdDate;
  int? modifiedDate;
  int? version;

  StockTakeLineItem(
      {this.id,
        this.site,
        this.stNum,
        this.invId,
        this.containerId,
        this.itemAssetCode,
        this.containerAssetCode,
        this.skuCode,
        this.containerCode,
        this.locCode,
        this.stocktakeLocCode,
        this.status,
        this.invStatus,
        this.reason,
        this.stocktakeDate,
        this.createdDate,
        this.modifiedDate,
        this.version});

  StockTakeLineItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    stNum = json['stNum'];
    invId = json['invId'];
    containerId = json['containerId'];
    itemAssetCode = json['itemAssetCode'];
    containerAssetCode = json['containerAssetCode'];
    skuCode = json['skuCode'];
    containerCode = json['containerCode'];
    locCode = json['locCode'];
    stocktakeLocCode = json['stocktakeLocCode'];
    status = json['status'];
    invStatus = json['invStatus'];
    reason = json['reason'];
    stocktakeDate = json['stocktakeDate'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site'] = this.site;
    data['stNum'] = this.stNum;
    data['invId'] = this.invId;
    data['containerId'] = this.containerId;
    data['itemAssetCode'] = this.itemAssetCode;
    data['containerAssetCode'] = this.containerAssetCode;
    data['skuCode'] = this.skuCode;
    data['containerCode'] = this.containerCode;
    data['locCode'] = this.locCode;
    data['stocktakeLocCode'] = this.stocktakeLocCode;
    data['status'] = this.status;
    data['invStatus'] = this.invStatus;
    data['reason'] = this.reason;
    data['stocktakeDate'] = this.stocktakeDate;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['version'] = this.version;
    return data;
  }
}


