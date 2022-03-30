import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_scan_page_arguments.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class AssetScanDetails extends StatefulWidget {
  AssetScanPageArguments arg;
  AssetScanDetails({Key? key, required this.arg}) : super(key: key);

  @override
  State<AssetScanDetails> createState() => _AssetScanDetailsState();
}

class _AssetScanDetailsState extends State<AssetScanDetails> {
  final inputFormat = DateFormat('dd/MM/yyyy');
  String totalProduct = "";
  String totalQuantity = "";
  String totalTracker = "";

  bool isFetching = false;
  DioClient repository = getIt<DioClient>();
  List<ListDocumentLineItem> dataList = [];

  Future<void> fetchData() async {
    var result = await repository.get(
        'http://qa-echome.ddns.net/echoMe/doc/listDocumentLine?docNum=${widget.arg.docNum}');
    var newTotalProduct = (result as List).length.toString();
    int newTotalQuantity = 0;
    int totalRegQuantity = 0;
    var newDataList = (result as List).map((e) {
      try{
        newTotalQuantity += e["quantity"] as int ;
        totalRegQuantity += e["regQty"] as int;
      }catch(e){
        print(e);
      }
      return ListDocumentLineItem.fromJson(e);
    }).toList();

    setState(() {
      dataList = newDataList;
      totalProduct = newTotalProduct;
      totalQuantity = newTotalQuantity.toString();
      totalTracker = "$totalRegQuantity/$newTotalQuantity";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.arg.item!.createdDate);
    return Scaffold(
      appBar: EchoMeAppBar(titleText: "Document Details"),
      body: SizedBox.expand(
        child:
            Column(children: [_getDocumentInfo(context), _getListBox(context)]),
      ),
    );
  }

  Widget _getListBox(BuildContext ctx) {
    print(isFetching);
    return Expanded(
      child: Builder(builder: (context) {
        return isFetching
            ? Center(
                child: SpinKitChasingDots(
                color: Colors.grey,
                size: 50.0,
              ))
            : _getListBoxList(context);
      }),
    );
  }

  Widget _getListBoxList(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.horizontal_padding),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Builder(
              builder: (context) => ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: ((context, index) {
                    final item = dataList[index];
                    return Builder(builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                              Text("Product Code : ${item.itemCode}"),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Description : ${item.description}"),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Quantity : ${item.quantity}"),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Registered Quantity : ${item.regQty}")
                          ],
                        ),
                            )),
                      );
                    });
                  }))),
        ),
      ),
    );
  }

  void updateTotalProduct(int num) {
    setState(() {
      totalProduct = num.toString();
    });
  }

  void updateTotalQuantity(int num) {
    setState(() {
      totalQuantity = num.toString();
    });
  }

  void updateTotalTracker(int num) {
    setState(() {
      totalTracker = "$num/$totalQuantity";
    });
  }

  Widget _getDocumentInfo(BuildContext ctx) {
    String dataString = widget.arg.item?.createdDate != null
        ? widget.arg.item!.createdDate!.toString()
        : "";
    return Padding(
      padding: const EdgeInsets.all(Dimens.horizontal_padding),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Document number : " + widget.arg.docNum),
              SizedBox(height: 5),
              // ignore: unnecessary_null_comparison
              Text(
                  "Document Date : ${dataString.isNotEmpty ? inputFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataString))) : ""}"),
              const SizedBox(height: 5),
              Text("ShipperCode: ${widget.arg.item?.shipperCode.toString()}"),
              const SizedBox(height: 5),
              Text("Total Product : $totalProduct"),
              const SizedBox(height: 5),
              Text("Total Quantity : $totalQuantity"),
              const SizedBox(height: 5),
              Text("Total Tracker : $totalTracker")
            ],
          ),
        ),
      ),
    );
  }
}
class ListDocumentLineItem {
  int? lineId;
  String? docNum;
  String? docType;
  String? docDate;
  String? vendorCode;
  String? skuCode;
  String? itemCode;
  String? assetCode;
  String? description;
  String? style;
  String? color;
  String? size;
  String? serial;
  String? eanupc;
  int? quantity;
  int? regQty;
  int? status;

  ListDocumentLineItem(
      {this.lineId,
      this.docNum,
      this.docType,
      this.docDate,
      this.vendorCode,
      this.skuCode,
      this.itemCode,
      this.assetCode,
      this.description,
      this.style,
      this.color,
      this.size,
      this.serial,
      this.eanupc,
      this.quantity,
      this.regQty,
      this.status});

  ListDocumentLineItem.fromJson(Map<String, dynamic> json) {
    lineId = json['lineId'];
    docNum = json['docNum'];
    docType = json['docType'];
    docDate = json['docDate'];
    vendorCode = json['vendorCode'];
    skuCode = json['skuCode'];
    itemCode = json['itemCode'];
    assetCode = json['assetCode'];
    description = json['description'];
    style = json['style'];
    color = json['color'];
    size = json['size'];
    serial = json['serial'];
    eanupc = json['eanupc'];
    quantity = json['quantity'];
    regQty = json['regQty'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lineId'] = this.lineId;
    data['docNum'] = this.docNum;
    data['docType'] = this.docType;
    data['docDate'] = this.docDate;
    data['vendorCode'] = this.vendorCode;
    data['skuCode'] = this.skuCode;
    data['itemCode'] = this.itemCode;
    data['assetCode'] = this.assetCode;
    data['description'] = this.description;
    data['style'] = this.style;
    data['color'] = this.color;
    data['size'] = this.size;
    data['serial'] = this.serial;
    data['eanupc'] = this.eanupc;
    data['quantity'] = this.quantity;
    data['regQty'] = this.regQty;
    data['status'] = this.status;
    return data;
  }
}