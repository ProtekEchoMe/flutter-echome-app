// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class ReturnItem {
  int? id;
  int? site;
  String? rtnNum;
  int? rtnDate;
  String? shipperCode;
  String? status;
  String? maker;
  int? createdDate;
  int? modifiedDate;

  ReturnItem(
      {this.id,
      this.site,
      this.rtnNum,
      this.rtnDate,
      this.shipperCode,
      this.status,
      this.maker,
      this.createdDate,
      this.modifiedDate});

  ReturnItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    rtnNum = json['rtnNum'];
    rtnDate = json['rtnDate'];
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
    data['rtnNum'] = this.rtnNum;
    data['rtnDate'] = this.rtnDate;
    data['shipperCode'] = this.shipperCode;
    data['status'] = this.status;
    data['maker'] = this.maker;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    return data;
  }
}

// class ReturnItem {
//   int? id;
//   int? site;
//   String? regNum;
//   String? regDate;
//   String? shipperCode;
//   String? status;
//   String? maker;
//   int? createdDate;
//   int? modifiedDate;
//
//   ReturnItem(
//       {this.id,
//         this.site,
//         this.regNum,
//         this.regDate,
//         this.shipperCode,
//         this.status,
//         this.maker,
//         this.createdDate,
//         this.modifiedDate});
//
//   ReturnItem.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     site = json['site'];
//     regNum = json['regNum'];
//     regDate = json['regDate'];
//     shipperCode = json['shipperCode'];
//     status = json['status'];
//     maker = json['maker'];
//     createdDate = json['createdDate'];
//     modifiedDate = json['modifiedDate'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['site'] = this.site;
//     data['regNum'] = this.regNum;
//     data['regDate'] = this.regDate;
//     data['shipperCode'] = this.shipperCode;
//     data['status'] = this.status;
//     data['maker'] = this.maker;
//     data['createdDate'] = this.createdDate;
//     data['modifiedDate'] = this.modifiedDate;
//     return data;
//   }
// }