class TransferOutHeaderItem {
  int? id;
  int? site;
  String? toNum;
  String? containerCode;
  String? shipToDivision;
  String? shipToLocation;
  String? shipType;
  String? deliveryOrderNum;
  String? department;
  String? productCode;
  String? skuCode;
  String? description;
  String? style;
  String? color;
  String? coo;
  String? rsku;
  int? quantity;
  int? checkinQty;
  int? containerQty;
  String? status;
  String? maker;
  int? createdDate;
  int? modifiedDate;

  TransferOutHeaderItem(
      {this.id,
      this.site,
      this.toNum,
      this.containerCode,
      this.shipToDivision,
      this.shipToLocation,
      this.shipType,
      this.deliveryOrderNum,
      this.department,
      this.productCode,
      this.skuCode,
      this.description,
      this.style,
      this.color,
      this.coo,
      this.rsku,
      this.quantity,
      this.checkinQty,
      this.containerQty,
      this.status,
      this.maker,
      this.createdDate,
      this.modifiedDate});

  TransferOutHeaderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    toNum = json['toNum'];
    containerCode = json['containerCode'];
    shipToDivision = json['shipToDivision'];
    shipToLocation = json['shipToLocation'];
    shipType = json['shipType'];
    deliveryOrderNum = json['deliveryOrderNum'];
    department = json['department'];
    productCode = json['productCode'];
    skuCode = json['skuCode'];
    description = json['description'];
    style = json['style'];
    color = json['color'];
    coo = json['coo'];
    rsku = json['rsku'];
    quantity = json['quantity'];
    checkinQty = json['checkinQty'];
    containerQty = json['containerQty'];
    status = json['status'];
    maker = json['maker'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['site'] = site;
    data['toNum'] = toNum;
    data['containerCode'] = containerCode;
    data['shipToDivision'] = shipToDivision;
    data['shipToLocation'] = shipToLocation;
    data['shipType'] = shipType;
    data['deliveryOrderNum'] = deliveryOrderNum;
    data['department'] = department;
    data['productCode'] = productCode;
    data['skuCode'] = skuCode;
    data['description'] = description;
    data['style'] = style;
    data['color'] = color;
    data['coo'] = coo;
    data['rsku'] = rsku;
    data['quantity'] = quantity;
    data['checkinQty'] = checkinQty;
    data['containerQty'] = containerQty;
    data['status'] = status;
    data['maker'] = maker;
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    return data;
  }
}