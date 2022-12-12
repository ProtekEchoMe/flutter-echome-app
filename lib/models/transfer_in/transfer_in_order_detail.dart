class TransferInOrderDetail {
  String? orderNum;
  String? containerCode;
  int? modifiedDate;
  String? status;
  String? rfid;
  List<OrderLineItems>? orderLineItems;
  Map orderLineItemsMap = {};

  TransferInOrderDetail(
      {this.orderNum,
        this.containerCode,
        this.modifiedDate,
        this.status,
        this.rfid,
        this.orderLineItems});

  TransferInOrderDetail.fromJson(Map<String, dynamic> json) {
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
  List<String>? checkedRFID;
  String? status;
  List<String>? rfid;

  OrderLineItems(
      {this.productName,
        this.productCode,
        this.itemCode,
        this.totalQty,
        this.checkedinQty,
        this.modifiedDate,
        this.checkedRFID,
        this.status,
        this.rfid});


  OrderLineItems.clone(OrderLineItems orderLineItems): this(productName: orderLineItems.productName,
      productCode: orderLineItems.productCode,
      itemCode :orderLineItems.itemCode,
      totalQty: orderLineItems.totalQty,
      checkedinQty: orderLineItems.checkedinQty,
      modifiedDate: orderLineItems.modifiedDate,
      rfid: orderLineItems.rfid,
      status: orderLineItems.status,
      checkedRFID: orderLineItems.checkedRFID);

  OrderLineItems.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    productCode = json['productCode'];
    itemCode = json['itemCode'];
    totalQty = json['totalQty'];
    checkedinQty = json['checkedinQty'];
    modifiedDate = json['modifiedDate'];
    checkedRFID = json['checkedRFID'].cast<String>();
    status = json['status'];
    rfid = json['rfid'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['productCode'] = this.productCode;
    data['itemCode'] = this.itemCode;
    data['totalQty'] = this.totalQty;
    data['checkedinQty'] = this.checkedinQty;
    data['modifiedDate'] = this.modifiedDate;
    data['checkedRFID'] = this.checkedRFID;
    data['status'] = this.status;
    data['rfid'] = this.rfid;
    return data;
  }
}


