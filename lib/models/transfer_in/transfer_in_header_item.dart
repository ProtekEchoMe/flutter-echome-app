class TransferInHeaderItem {
  int? id;
  int? site;
  String? tiNum;
  String? shipToDivision;
  String? shipFromLocation;
  String? shipToLocation;
  String? shipType;
  String? deliveryOrderNum;
  String? status;
  String? maker;
  int? createdDate;
  int? modifiedDate;

  TransferInHeaderItem(
      {this.id,
      this.site,
      this.tiNum,
      this.shipToDivision,
      this.shipFromLocation,
      this.shipToLocation,
      this.shipType,
      this.deliveryOrderNum,
      this.status,
      this.maker,
      this.createdDate,
      this.modifiedDate});

  TransferInHeaderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    tiNum = json['tiNum'];
    shipToDivision = json['shipToDivision'];
    shipFromLocation = json['shipFromLocation'];
    shipToLocation = json['shipToLocation'];
    shipType = json['shipType'];
    deliveryOrderNum = json['deliveryOrderNum'];
    status = json['status'];
    maker = json['maker'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['site'] = site;
    data['tiNum'] = tiNum;
    data['shipToDivision'] = shipToDivision;
    data['shipFromLocation'] = shipFromLocation;
    data['shipToLocation'] = shipToLocation;
    data['shipType'] = shipType;
    data['deliveryOrderNum'] = deliveryOrderNum;
    data['status'] = status;
    data['maker'] = maker;
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    return data;
  }
}