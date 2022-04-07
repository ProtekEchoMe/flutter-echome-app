class AssetInventoryItem {
  int? id;
  String? skuCode;
  String? assetCode;
  String? itemCode;
  String? description;
  String? style;
  String? color;
  String? size;
  String? serial;
  String? eanupc;
  int? quantity;
  String? locCode;
  String? lastLocCode;
  String? checkpointCode;
  String? lastCheckpointCode;
  int? status;
  int? docId;
  String? docNum;
  int? inboundDate;
  int? expiryDate;
  int? createdDate;
  int? modifiedDate;
  String? reason;

  AssetInventoryItem(
      {this.id,
      this.skuCode,
      this.assetCode,
      this.itemCode,
      this.description,
      this.style,
      this.color,
      this.size,
      this.serial,
      this.eanupc,
      this.quantity,
      this.locCode,
      this.lastLocCode,
      this.checkpointCode,
      this.lastCheckpointCode,
      this.status,
      this.docId,
      this.docNum,
      this.inboundDate,
      this.expiryDate,
      this.createdDate,
      this.modifiedDate,
      this.reason});

  AssetInventoryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    skuCode = json['skuCode'];
    assetCode = json['assetCode'];
    itemCode = json['itemCode'];
    description = json['description'];
    style = json['style'];
    color = json['color'];
    size = json['size'];
    serial = json['serial'];
    eanupc = json['eanupc'];
    quantity = json['quantity'];
    locCode = json['locCode'];
    lastLocCode = json['lastLocCode'];
    checkpointCode = json['checkpointCode'];
    lastCheckpointCode = json['lastCheckpointCode'];
    status = json['status'];
    docId = json['docId'];
    docNum = json['docNum'];
    inboundDate = json['inboundDate'];
    expiryDate = json['expiryDate'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['skuCode'] = this.skuCode;
    data['assetCode'] = this.assetCode;
    data['itemCode'] = this.itemCode;
    data['description'] = this.description;
    data['style'] = this.style;
    data['color'] = this.color;
    data['size'] = this.size;
    data['serial'] = this.serial;
    data['eanupc'] = this.eanupc;
    data['quantity'] = this.quantity;
    data['locCode'] = this.locCode;
    data['lastLocCode'] = this.lastLocCode;
    data['checkpointCode'] = this.checkpointCode;
    data['lastCheckpointCode'] = this.lastCheckpointCode;
    data['status'] = this.status;
    data['docId'] = this.docId;
    data['docNum'] = this.docNum;
    data['inboundDate'] = this.inboundDate;
    data['expiryDate'] = this.expiryDate;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['reason'] = this.reason;
    return data;
  }
}