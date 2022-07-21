import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/stock_take/stock_take_scan_page_arguments.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_line_item.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'package:echo_me_mobile/stores/stock_take/stock_take_store.dart';

class StockTakeScanDetailPage extends StatefulWidget {
  StockTakeScanPageArguments arg;
  StockTakeScanDetailPage({Key? key, required this.arg}) : super(key: key);

  @override
  State<StockTakeScanDetailPage> createState() => _StockTakeScanDetailPageState();
}

class _StockTakeScanDetailPageState extends State<StockTakeScanDetailPage> {
  final inputFormat = DateFormat('dd/MM/yyyy');
  List<String> statusList = ["OUTSTANDING", "SCANNED", "IN_RANGE_EXCEPTIONAL", "OUT_RANGE_EXCEPTIONAL", "CANCEL"];
  Map<String, int> statusMap = {"OUTSTANDING": 0, "SCANNED": 0, "IN_RANGE_EXCEPTIONAL": 0, "OUT_RANGE_EXCEPTIONAL": 0, "CANCEL": 0};
  List<Widget> statusTextList = [];
  String totalProduct = "";
  String totalQuantity = "";
  String totalTracker = "";

  final StockTakeStore _stockTakeStore = getIt<StockTakeStore>();

  bool isFetching = false;
  // DioClient repository = getIt<DioClient>();
  final Repository repository = getIt<Repository>();
  // List<StockTakeLineItem> dataList = [];

  Future<void> fetchData() async {
    String stNum = widget.arg.stNum;
    var result = await repository.getStockTakeLine(
        page: 0, limit: 0, stNum: stNum);

    await _stockTakeStore.fetchLineData(stNum: stNum);
    // var result = await repository.get(
    //     'http://qa-echome.ddns.net/echoMe/reg/listRegisterLine?regNum=${widget.arg.stNum}');
    // var newTotalProduct = (result as List).length.toString();
    // int newTotalQuantity = 0;
    // int totalRegQuantity = 0;
    // var newDataList = (result as List).map((e) {
    //   try{
    //     newTotalQuantity += e["quantity"] as int ;
    //     totalRegQuantity += e["checkinQty"] as int;
    //   }catch(e){
    //     print(e);
    //   }
    //   return ListDocumentLineItem.fromJson(e);
    // }).toList();

    List<StockTakeLineItem> lineList = _stockTakeStore.filtereditemLineList;
    // Map<String, int> countMap = new Map<String, int>();
    lineList.forEach((element) {
      String status = element.status ?? "";
      if (statusMap.containsKey(status)){
        if (statusMap[status] != null) {
          statusMap[status] = statusMap[status]! + 1;
        }
      }else{
        statusMap[status] = 0;
      }
    });

    // var tempList = [];
    statusTextList.add(const SizedBox(height: 5));
    statusMap.forEach((key, value) {
      statusTextList.add(Text("Total $key : $value"));
      statusTextList.add(const SizedBox(height: 5));
    }
    );

    setState(() {
      // dataList = lineList;
      totalProduct = result.rowNumber.toString();
      totalQuantity = "0";
      totalTracker = "";
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
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 12,
          selectedItemColor: Colors.black54,
          unselectedItemColor: Colors.black54,
          selectedIconTheme:
          const IconThemeData(color: Colors.black54, size: 25, opacity: .8),
          unselectedIconTheme:
          const IconThemeData(color: Colors.black54, size: 25, opacity: .8),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.change_circle),
              label: 'Change Equipment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.signal_cellular_alt),
              label: 'Re-Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Complete',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.eleven_mp),
            //   label: 'Debug',
            // ),
          ],
          // onTap: (int index) => _onBottomBarItemTapped(args, index),
        )
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
                itemCount: _stockTakeStore.filtereditemLineList.length,
                itemBuilder: ((context, index) {
                  final listItemJson = _stockTakeStore.filtereditemLineList[index].toJson();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: listItemJson.keys.map((e) {
                              var data = listItemJson[e];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${e}: ${data}"),
                                  const SizedBox(
                                    width: double.maxFinite,
                                    height: 5,
                                  )
                                ],
                              );
                            }).toList(),
                          ),
                        )),
                  );
                })),),
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
    int dataInt = widget.arg.item?.createdDate ?? 0;
    String dataString = "";
    if (dataInt != 0) {dataString = dataInt.toString();};
    // dataString = dataString.toString();
    // String dataString = widget.arg.item?.createdDate != String
    //     ? widget.arg.item!.createdDate!.toString()
    //     : "";
        print(widget.arg.item);
    return AppContentBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Reg number : " + widget.arg.stNum),
            SizedBox(height: 5),
            // ignore: unnecessary_String_comparison
            Text(
                "Document Date : ${(dataString as String).isNotEmpty ? inputFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataString))) : ""}"),
            const SizedBox(height: 5),
            // Text("ShipperCode: ${widget.arg.item?.shipperCode.toString()}"),
            // const SizedBox(height: 5),
            // Text("Total Product : $totalProduct"),
            // const SizedBox(height: 5),
            // Text("Total Quantity : $totalQuantity"),
            // const SizedBox(height: 5),
            // Text("Total Tracker : $totalTracker"),
            ...statusTextList
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