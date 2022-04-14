// ignore_for_file: unnecessary_new, prefer_collection_literals

class TransferOutHeaderItem {
  int? id;
  int? site;
  String? toNum;
  String? shipToDivision;
  String? shipFromLocation;
  String? shipToLocation;
  String? shipType;
  String? deliveryOrderNum;
  String? status;
  String? maker;
  int? createdDate;
  int? modifiedDate;

  TransferOutHeaderItem(
      {this.id,
      this.site,
      this.toNum,
      this.shipToDivision,
      this.shipFromLocation,
      this.shipToLocation,
      this.shipType,
      this.deliveryOrderNum,
      this.status,
      this.maker,
      this.createdDate,
      this.modifiedDate});

  TransferOutHeaderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    toNum = json['toNum'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['site'] = site;
    data['toNum'] = toNum;
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