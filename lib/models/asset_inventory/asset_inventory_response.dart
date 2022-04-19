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

// ignore_for_file: unnecessary_new, prefer_collection_literals


class RowData {
  int? skuCode;
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
      {this.skuCode,
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
    skuCode = json['skuCode'];
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
    data['skuCode'] = skuCode;
    data['itemDescription'] = itemDescription;
    data['styleNumber'] = styleNumber;
    data['color'] = color;
    data['size'] = size;
    data['sn'] = sn;
    data['upcEan'] = upcEan;
    data['brand'] = brand;
    data['coo'] = coo;
    data['expDate'] = expDate;
    data['assetId'] = assetId;
    data['eqmId'] = eqmId;
    data['eqmCode'] = eqmCode;
    data['inboundDate'] = inboundDate;
    data['orderNum'] = orderNum;
    data['itemStatus'] = itemStatus;
    data['location'] = location;
    data['checkPoint'] = checkPoint;
    data['lastLocation'] = lastLocation;
    data['lastCheckpoint'] = lastCheckpoint;
    data['resOperation'] = resOperation;
    return data;
  }
}