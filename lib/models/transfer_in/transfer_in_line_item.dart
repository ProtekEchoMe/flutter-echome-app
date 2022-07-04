class ListTransferInLineItem {
  int? id;
  int? site;
  String? tiNum;
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

  ListTransferInLineItem(
      {this.id,
      this.site,
      this.tiNum,
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

  ListTransferInLineItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    tiNum = json['tiNum'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site'] = this.site;
    data['tiNum'] = this.tiNum;
    data['containerCode'] = this.containerCode;
    data['shipToDivision'] = this.shipToDivision;
    data['shipToLocation'] = this.shipToLocation;
    data['shipType'] = this.shipType;
    data['deliveryOrderNum'] = this.deliveryOrderNum;
    data['department'] = this.department;
    data['productCode'] = this.productCode;
    data['skuCode'] = this.skuCode;
    data['description'] = this.description;
    data['style'] = this.style;
    data['color'] = this.color;
    data['coo'] = this.coo;
    data['rsku'] = this.rsku;
    data['quantity'] = this.quantity;
    data['checkinQty'] = this.checkinQty;
    data['containerQty'] = this.containerQty;
    data['status'] = this.status;
    data['maker'] = this.maker;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    return data;
  }
}