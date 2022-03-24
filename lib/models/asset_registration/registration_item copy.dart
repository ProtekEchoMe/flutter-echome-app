// class RegistrationItem {
//   int? orderId;
//   int? supplierCode;
//   String? supplierName;
//   int? orderDate;
//   String? orderStatus;
//   String? createdAt;
//   String? createdBy;
//   String? modifiedAt;
//   String? modifiedBy;
//   int? totalQuantity;
//   int? totalScanned;
//   int? totalOrderSKU;
//   int? totalScannedContainer;

//   RegistrationItem(
//       {this.orderId,
//       this.supplierCode,
//       this.supplierName,
//       this.orderDate,
//       this.orderStatus,
//       this.createdAt,
//       this.createdBy,
//       this.modifiedAt,
//       this.modifiedBy,
//       this.totalQuantity,
//       this.totalScanned,
//       this.totalOrderSKU,
//       this.totalScannedContainer});

//   RegistrationItem.fromJson(Map<String, dynamic> json) {
//     orderId = json['orderId'];
//     supplierCode = json['supplierCode'];
//     supplierName = json['supplierName'];
//     orderDate = json['orderDate'];
//     orderStatus = json['orderStatus'];
//     createdAt = json['createdAt'];
//     createdBy = json['createdBy'];
//     modifiedAt = json['modifiedAt'];
//     modifiedBy = json['modifiedBy'];
//     totalQuantity = json['totalQuantity'];
//     totalScanned = json['totalScanned'];
//     totalOrderSKU = json['totalOrderSKU'];
//     totalScannedContainer = json['totalScannedContainer'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['orderId'] = this.orderId;
//     data['supplierCode'] = this.supplierCode;
//     data['supplierName'] = this.supplierName;
//     data['orderDate'] = this.orderDate;
//     data['orderStatus'] = this.orderStatus;
//     data['createdAt'] = this.createdAt;
//     data['createdBy'] = this.createdBy;
//     data['modifiedAt'] = this.modifiedAt;
//     data['modifiedBy'] = this.modifiedBy;
//     data['totalQuantity'] = this.totalQuantity;
//     data['totalScanned'] = this.totalScanned;
//     data['totalOrderSKU'] = this.totalOrderSKU;
//     data['totalScannedContainer'] = this.totalScannedContainer;
//     return data;
//   }
// }