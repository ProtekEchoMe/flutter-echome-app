// ignore_for_file: unnecessary_new, prefer_collection_literals

class AssetInventoryItem {
  int? id;
  int? site;
  String? skuCode;
  String? assetCode;
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
  String? status;
  String? regNum;
  String? toNum;
  String? tiNum;
  int? inboundDate;
  String? expiryDate;
  int? createdDate;
  int? modifiedDate;
  String? reason;

  AssetInventoryItem(
      {this.id,
      this.site,
      this.skuCode,
      this.assetCode,
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
    skuCode = json['skuCode'];
    assetCode = json['assetCode'];
    skuCode = json['skuCode'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['site'] = site;
    data['skuCode'] = skuCode;
    data['assetCode'] = assetCode;
    data['skuCode'] = skuCode;
    data['description'] = description;
    data['style'] = style;
    data['color'] = color;
    data['size'] = size;
    data['serial'] = serial;
    data['eanupc'] = eanupc;
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