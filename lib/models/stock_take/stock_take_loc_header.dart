// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class StockTakeLocHeader {

  String? stNum;
  String? locCode;
  String? status;
  int? version;

  StockTakeLocHeader({
    this.stNum,
    this.locCode,
    this.status,
    this.version
  });

  StockTakeLocHeader.fromJson(Map<String, dynamic> json) {
    stNum = json['stNum'];
    locCode = json['locCode'];
    status = json['status'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stNum'] = this.stNum;
    data['loc'] = this.locCode;
    data['status'] = this.status;
    data['version'] = this.version;
    return data;
  }
}
