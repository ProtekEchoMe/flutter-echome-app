class AssetInventoryItem {
  int? id;
  int? site;
  String? productCode;
  String? assetCode;
  String? skuCode;
  String? description;
  String? style;
  String? color;
  String? size;
  String? serial;
  String? eanupc;
  String? coo;
  int? quantity;
  String? locCode;
  String? lastLocCode;
  String? checkpointCode;
  String? lastCheckpointCode;
  String? status;
  String? regNum;
  String? toNum;
  String? tiNum;
  int? inboundDate;
  int? expiryDate;
  int? createdDate;
  int? modifiedDate;
  int? reason;

  AssetInventoryItem(
      {this.id,
      this.site,
      this.productCode,
      this.assetCode,
      this.skuCode,
      this.description,
      this.style,
      this.color,
      this.size,
      this.serial,
      this.eanupc,
      this.coo,
      this.quantity,
      this.locCode,
      this.lastLocCode,
      this.checkpointCode,
      this.lastCheckpointCode,
      this.status,
      this.regNum,
      this.toNum,
      this.tiNum,
      this.inboundDate,
      this.expiryDate,
      this.createdDate,
      this.modifiedDate,
      this.reason});

  AssetInventoryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    productCode = json['productCode'];
    assetCode = json['assetCode'];
    skuCode = json['skuCode'];
    description = json['description'];
    style = json['style'];
    color = json['color'];
    size = json['size'];
    serial = json['serial'];
    eanupc = json['eanupc'];
    coo = json['coo'];
    quantity = json['quantity'];
    locCode = json['locCode'];
    lastLocCode = json['lastLocCode'];
    checkpointCode = json['checkpointCode'];
    lastCheckpointCode = json['lastCheckpointCode'];
    status = json['status'];
    regNum = json['regNum'];
    toNum = json['toNum'];
    tiNum = json['tiNum'];
    inboundDate = json['inboundDate'];
    expiryDate = json['expiryDate'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['site'] = site;
    data['productCode'] = productCode;
    data['assetCode'] = assetCode;
    data['skuCode'] = skuCode;
    data['description'] = description;
    data['style'] = style;
    data['color'] = color;
    data['size'] = size;
    data['serial'] = serial;
    data['eanupc'] = eanupc;
    data['coo'] = coo;
    data['quantity'] = quantity;
    data['locCode'] = locCode;
    data['lastLocCode'] = lastLocCode;
    data['checkpointCode'] = checkpointCode;
    data['lastCheckpointCode'] = lastCheckpointCode;
    data['status'] = status;
    data['regNum'] = regNum;
    data['toNum'] = toNum;
    data['tiNum'] = tiNum;
    data['inboundDate'] = inboundDate;
    data['expiryDate'] = expiryDate;
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['reason'] = reason;
    return data;
  }
}