import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/stock_take/stock_take_scan_page_arguments.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class StockTakeScanDetailPage extends StatefulWidget {
  StockTakeScanPageArguments arg;
  StockTakeScanDetailPage({Key? key, required this.arg}) : super(key: key);

  @override
  State<StockTakeScanDetailPage> createState() => _StockTakeScanDetailPageState();
}

class _StockTakeScanDetailPageState extends State<StockTakeScanDetailPage> {
  final inputFormat = DateFormat('dd/MM/yyyy');
  String totalProduct = "";
  String totalQuantity = "";
  String totalTracker = "";

  bool isFetching = false;
  DioClient repository = getIt<DioClient>();
  List<ListDocumentLineItem> dataList = [];

  Future<void> fetchData() async {
    var result = await repository.get(
        'http://qa-echome.ddns.net/echoMe/reg/listRegisterLine?regNum=${widget.arg.regNum}');
    var newTotalProduct = (result as List).length.toString();
    int newTotalQuantity = 0;
    int totalRegQuantity = 0;
    var newDataList = (result as List).map((e) {
      try{
        newTotalQuantity += e["quantity"] as int ;
        totalRegQuantity += e["checkinQty"] as int;
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
                            Text("Product Code : ${listItem.skuCode}"),
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
                            Text("Check In Quantity : ${listItem.checkinQty}")
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
    String dataString = widget.arg.item?.createdDate != String
        ? widget.arg.item!.createdDate!.toString()
        : "";
        print(widget.arg.item);
    return AppContentBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Reg number : " + widget.arg.regNum),
            SizedBox(height: 5),
            // ignore: unnecessary_String_comparison
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
  int? site;
  String? regNum;
  String? regDate;
  String? vendorCode;
  String? productCode;
  String? skuCode;
  String? description;
  String? style;
  String? color;
  String? size;
  String? serial;
  String? eanupc;
  int? quantity;
  int? checkinQty;
  int? containerQty;
  String? status;
  String? maker;
  int? createdDate;
  int? modifiedDate;

  ListDocumentLineItem(
      {this.id,
      this.site,
      this.regNum,
      this.regDate,
      this.vendorCode,
      this.productCode,
      this.skuCode,
      this.description,
      this.style,
      this.color,
      this.size,
      this.serial,
      this.eanupc,
      this.quantity,
      this.checkinQty,
      this.containerQty,
      this.status,
      this.maker,
      this.createdDate,
      this.modifiedDate});

  ListDocumentLineItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    regNum = json['regNum'];
    regDate = json['regDate'];
    vendorCode = json['vendorCode'];
    productCode = json['productCode'];
    skuCode = json['skuCode'];
    description = json['description'];
    style = json['style'];
    color = json['color'];
    size = json['size'];
    serial = json['serial'];
    eanupc = json['eanupc'];
    quantity = json['quantity'];
    checkinQty = json['checkinQty'];
    containerQty = json['containerQty'];
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
    data['vendorCode'] = this.vendorCode;
    data['productCode'] = this.productCode;
    data['skuCode'] = this.skuCode;
    data['description'] = this.description;
    data['style'] = this.style;
    data['color'] = this.color;
    data['size'] = this.size;
    data['serial'] = this.serial;
    data['eanupc'] = this.eanupc;
    data['quantity'] = this.quantity;
    data['checkinQty'] = this.checkinQty;
    data['containerQty'] = this.containerQty;
    data['status'] = this.status;
    data['maker'] = this.maker;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    return data;
  }
}