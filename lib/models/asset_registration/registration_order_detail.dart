class RegistrationOrderDetail {
  String? orderNum;
  String? containerCode;
  int? modifiedDate;
  String? status;
  String? rfid;
  List<OrderLineItems>? orderLineItems;
  Map orderLineItemsMap = {};

  RegistrationOrderDetail(
      {this.orderNum,
        this.containerCode,
        this.modifiedDate,
        this.status,
        this.rfid,
        this.orderLineItems});

  RegistrationOrderDetail.fromJson(Map<String, dynamic> json) {
    orderNum = json['orderNum'];
    containerCode = json['containerCode'];
    modifiedDate = json['modifiedDate'];
    status = json['status'];
    rfid = json['rfid'];
    if (json['orderLineItems'] != null) {
      orderLineItems = <OrderLineItems>[];
      json['orderLineItems'].forEach((v) {
        orderLineItems!.add(new OrderLineItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderNum'] = this.orderNum;
    data['containerCode'] = this.containerCode;
    data['modifiedDate'] = this.modifiedDate;
    data['status'] = this.status;
    data['rfid'] = this.rfid;
    if (this.orderLineItems != null) {
      data['orderLineItems'] =
          this.orderLineItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void addOrderLineItemsMapItem(String itemCode, OrderLineItems orderLineItems){
    this.orderLineItemsMap[itemCode] = orderLineItems;
  }

  Object? getVariablebyName(String key) {
    switch(key) {
      case 'status': return status;
      case 'modifiedDate': return modifiedDate;
    }

  }
}

class OrderLineItems {
  String? productName;
  String? productCode;
  String? itemCode;
  int? totalQty;
  int? checkedinQty;
  int? modifiedDate;
  List<String>? rfid;
  String? status;

  OrderLineItems(
      {this.productName,
        this.productCode,
        this.itemCode,
        this.totalQty,
        this.checkedinQty,
        this.modifiedDate,
        this.rfid,
        this.status});

  OrderLineItems.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    productCode = json['productCode'];
    itemCode = json['itemCode'];
    totalQty = json['totalQty'];
    checkedinQty = json['checkedinQty'];
    modifiedDate = json['modifiedDate'];
    rfid = json['rfid'].cast<String>();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['productCode'] = this.productCode;
    data['itemCode'] = this.itemCode;
    data['totalQty'] = this.totalQty;
    data['checkedinQty'] = this.checkedinQty;
    data['modifiedDate'] = this.modifiedDate;
    data['rfid'] = this.rfid;
    data['status'] = this.status;
    return data;
  }
}