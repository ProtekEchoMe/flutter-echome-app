import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_scan_page_arguments.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
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
    return AppContentBox(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Builder(
            builder: (context) => ListView.builder(
                itemCount: dataList.length,
                itemBuilder: ((context, index) {
                  final listItem = dataList[index];
                  return Builder(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            Text("Product Code : ${listItem.itemCode}"),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Description : ${listItem.description}"),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Quantity : ${listItem.quantity}"),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Registered Quantity : ${listItem.regQty}")
                        ],
                      ),
                          )),
                    );
                  });
                }))),
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
    return AppContentBox(
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
    );
  }
}
class ListDocumentLineItem {
  int? id;
  String? docNum;
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
  int? skuQty;
  int? containerQty;
  String? status;
  String? maker;
  int? createdDate;
  int? modifiedDate;

  ListDocumentLineItem(
      {this.id,
      this.docNum,
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
      this.skuQty,
      this.containerQty,
      this.status,
      this.maker,
      this.createdDate,
      this.modifiedDate});

  ListDocumentLineItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    docNum = json['docNum'];
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
    skuQty = json['skuQty'];
    containerQty = json['containerQty'];
    status = json['status'];
    maker = json['maker'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['docNum'] = this.docNum;
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
    data['skuQty'] = this.skuQty;
    data['containerQty'] = this.containerQty;
    data['status'] = this.status;
    data['maker'] = this.maker;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    return data;
  }
}