// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class StockTakeItem {
  int? id;
  int? site;
  String? stNum;
  String? ranges;
  int? totalAssetQty;
  int? totalStocktakeQty;
  int? totalExceptionQty;
  String? maker;
  String? taker;
  String? status;
  int? startDate;
  int? endDate;
  int? createdDate;
  int? modifiedDate;

  StockTakeItem({
    this.id,
    this.site,
    this.stNum,
    this.ranges,
    this.totalAssetQty,
    this.totalStocktakeQty,
    this.totalExceptionQty,
    this.maker,
    this.taker,
    this.status,
    this.startDate,
    this.endDate,
    this.createdDate,
    this.modifiedDate,
  });

  StockTakeItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    stNum = json['stNum'];
    ranges = json['ranges'];
    totalAssetQty = json['totalAssetQty'];
    totalStocktakeQty = json['totalStocktakeQty'];
    totalExceptionQty = json['totalExceptionQty'];
    maker = json['maker'];
    taker = json['taker'];
    status = json['status'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createdDate = json['endDate'];
    modifiedDate = json['modifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site'] = this.site;
    data['stNum'] = this.stNum;
    data['ranges'] = this.ranges;
    data['totalAssetQty'] = this.totalAssetQty;
    data['totalStocktakeQty'] = this.totalStocktakeQty;
    data['totalExceptionQty'] = this.totalExceptionQty;
    data['taker'] = this.taker;
    data['status'] = this.status;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    return data;
  }
}
