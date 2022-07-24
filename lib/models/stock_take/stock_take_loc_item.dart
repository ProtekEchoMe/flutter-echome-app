// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class StockTakeLocItem {

  String? stNum;
  String? locCode;
  String? status;

  StockTakeLocItem({
    this.stNum,
    this.locCode,
    this.status,
  });

  StockTakeLocItem.fromJson(Map<String, dynamic> json) {
    stNum = json['stNum'];
    locCode = json['loc'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stNum'] = this.stNum;
    data['loc'] = this.locCode;
    data['status'] = this.status;
    return data;
  }
}
