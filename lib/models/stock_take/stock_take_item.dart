// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class StakeTakeItem {
  int? id;
  int? site;
  String? regNum;
  int? regDate;
  String? shipperCode;
  String? status;
  String? maker;
  int? createdDate;
  int? modifiedDate;

  StakeTakeItem(
      {this.id,
      this.site,
      this.regNum,
      this.regDate,
      this.shipperCode,
      this.status,
      this.maker,
      this.createdDate,
      this.modifiedDate});

  StakeTakeItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    regNum = json['regNum'];
    regDate = json['regDate'];
    shipperCode = json['shipperCode'];
    status = json['status'];
    maker = json['maker'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site'] = this.site;
    data['regNum'] = this.regNum;
    data['regDate'] = this.regDate;
    data['shipperCode'] = this.shipperCode;
    data['status'] = this.status;
    data['maker'] = this.maker;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    return data;
  }
}