// class AssetInventoryResponse {
//   int? totalRow;
//   List<RowData>? rowData;

//   AssetInventoryResponse({this.totalRow, this.rowData});

//   AssetInventoryResponse.fromJson(Map<String, dynamic> json) {
//     totalRow = json['totalRow'];
//     if (json['rowData'] != null) {
//       rowData = <RowData>[];
//       json['rowData'].forEach((v) {
//         rowData!.add(new RowData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['totalRow'] = this.totalRow;
//     if (this.rowData != null) {
//       data['rowData'] = this.rowData!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class RowData {
  int? itemCode;
  String? itemDescription;
  int? styleNumber;
  String? color;
  int? size;
  int? sn;
  int? upcEan;
  String? brand;
  String? coo;
  String? expDate;
  int? assetId;
  int? eqmId;
  int? eqmCode;
  String? inboundDate;
  int? orderNum;
  int? itemStatus;
  String? location;
  String? checkPoint;
  String? lastLocation;
  String? lastCheckpoint;
  String? resOperation;

  RowData(
      {this.itemCode,
      this.itemDescription,
      this.styleNumber,
      this.color,
      this.size,
      this.sn,
      this.upcEan,
      this.brand,
      this.coo,
      this.expDate,
      this.assetId,
      this.eqmId,
      this.eqmCode,
      this.inboundDate,
      this.orderNum,
      this.itemStatus,
      this.location,
      this.checkPoint,
      this.lastLocation,
      this.lastCheckpoint,
      this.resOperation});

  RowData.fromJson(Map<String, dynamic> json) {
    itemCode = json['itemCode'];
    itemDescription = json['itemDescription'];
    styleNumber = json['styleNumber'];
    color = json['color'];
    size = json['size'];
    sn = json['sn'];
    upcEan = json['upcEan'];
    brand = json['brand'];
    coo = json['coo'];
    expDate = json['expDate'];
    assetId = json['assetId'];
    eqmId = json['eqmId'];
    eqmCode = json['eqmCode'];
    inboundDate = json['inboundDate'];
    orderNum = json['orderNum'];
    itemStatus = json['itemStatus'];
    location = json['location'];
    checkPoint = json['checkPoint'];
    lastLocation = json['lastLocation'];
    lastCheckpoint = json['lastCheckpoint'];
    resOperation = json['resOperation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemCode'] = this.itemCode;
    data['itemDescription'] = this.itemDescription;
    data['styleNumber'] = this.styleNumber;
    data['color'] = this.color;
    data['size'] = this.size;
    data['sn'] = this.sn;
    data['upcEan'] = this.upcEan;
    data['brand'] = this.brand;
    data['coo'] = this.coo;
    data['expDate'] = this.expDate;
    data['assetId'] = this.assetId;
    data['eqmId'] = this.eqmId;
    data['eqmCode'] = this.eqmCode;
    data['inboundDate'] = this.inboundDate;
    data['orderNum'] = this.orderNum;
    data['itemStatus'] = this.itemStatus;
    data['location'] = this.location;
    data['checkPoint'] = this.checkPoint;
    data['lastLocation'] = this.lastLocation;
    data['lastCheckpoint'] = this.lastCheckpoint;
    data['resOperation'] = this.resOperation;
    return data;
  }
}