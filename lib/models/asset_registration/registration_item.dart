class RegistrationItem {
  int? docId;
  String? docNum;
  String? docType;
  String? docDate;
  String? shipperCode;
  String? status;
  String? creator;
  int? createdDate;
  int? modifiedDate;

  RegistrationItem(
      {this.docId,
      this.docNum,
      this.docType,
      this.docDate,
      this.shipperCode,
      this.status,
      this.creator,
      this.createdDate,
      this.modifiedDate});

  RegistrationItem.fromJson(Map<String, dynamic> json) {
    docId = json['docId'];
    docNum = json['docNum'];
    docType = json['docType'];
    docDate = json['docDate'];
    shipperCode = json['shipperCode'];
    status = json['status'];
    creator = json['creator'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docId'] = this.docId;
    data['docNum'] = this.docNum;
    data['docType'] = this.docType;
    data['docDate'] = this.docDate;
    data['shipperCode'] = this.shipperCode;
    data['status'] = this.status;
    data['creator'] = this.creator;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    return data;
  }
}