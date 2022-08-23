import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';
import 'package:mobx/mobx.dart';

// import 'package:flutter_checkbox_dialog/flutter_checkbox_dialog.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class StockTakeScanDetailPage extends StatefulWidget {
  StockTakeScanPageArguments arg;

  StockTakeScanDetailPage({Key? key, required this.arg}) : super(key: key);

  @override
  State<StockTakeScanDetailPage> createState() =>
      _StockTakeScanDetailPageState();
}

class _StockTakeScanDetailPageState extends State<StockTakeScanDetailPage> {
  final inputFormat = DateFormat('dd/MM/yyyy');
  List<String> statusList = [
    "OUTSTANDING",
    "SCANNED",
    "IN_RANGE_EXCEPTIONAL",
    "OUT_RANGE_EXCEPTIONAL",
    "CANCEL"
  ];
  List<dynamic> disposer = [];

  // Map<String, int> statusMap = {"OUTSTANDING": 0, "SCANNED": 0, "IN_RANGE_EXCEPTIONAL": 0, "OUT_RANGE_EXCEPTIONAL": 0, "CANCEL": 0};
  ObservableMap<String, dynamic> statusMap = ObservableMap<String, dynamic>();
  List<Widget> widgetList = [];

  // statusList.forEach((element) {statusMap[element] = {"count": 0, "checkBoxController": true}});
  List<Widget> statusTextList = [];
  String totalProduct = "";
  String totalQuantity = "";
  String totalTracker = "";

  bool _switchSelected = true; //维护单选开关状态
  bool? _checkboxSelected = true; //维护复选框状态

  final StockTakeStore _stockTakeStore = getIt<StockTakeStore>();

  bool isFetching = false;

  // DioClient repository = getIt<DioClient>();
  final Repository repository = getIt<Repository>();

  // List<StockTakeLineItem> dataList = [];

  Future<void> fetchData() async {
    String stNum = widget.arg.stNum;
    // String? locCode = widget.arg.stockTakeLineItem.locCode;
    String locCode = widget.arg.stockTakeLineItem?.locCode ?? "";
    // var result = await repository.getStockTakeLine(
    //     page: 0, limit: 0, stNum: stNum);

    await _stockTakeStore.fetchLineData(stNum: stNum, locCode: locCode).then((value) {
      _stockTakeStore.updateStatusList();
      setState(() {
        statusMap = _stockTakeStore.statusMap;
      });
    });

    // updateStatusList();

    // var tempList = [];
    // statusTextList.add(const SizedBox(height: 5));
    // statusMap.forEach((key, value) {
    //   statusTextList.add(Text("Total $key : $value"));
    //   statusTextList.add(const SizedBox(height: 5));
    // }
    // );
  }

  @override
  void initState() {
    super.initState();
    var disposerReaction = reaction(
            (_) => _stockTakeStore.errorStore.errorMessage, (_) {
      if (_stockTakeStore.errorStore.errorMessage.isNotEmpty) {
        _showSnackBar(_stockTakeStore.errorStore.errorMessage);
      }
    });
    disposer.add(disposerReaction);
    fetchData();


    // statusList.forEach((element) {statusMap[element] = {"count": 0, "checkBoxController": true, "stockTakeLineList": []};});
  }

  void _showSnackBar(String? str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str ?? ""),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < disposer.length; i++) {
      disposer[i]();
    }
  }

  void updateStatusList() {
    List<StockTakeLineItem> lineList = _stockTakeStore.filtereditemLineList;
    // Map<String, int> countMap = new Map<String, int>();
    lineList.forEach((element) {
      String status = element.status ?? "";
      if (statusMap.containsKey(status)) {
        if (statusMap[status] != null) {
          statusMap[status]["count"] += 1;
          statusMap[status]["stockTakeLineList"].add(element);
        }
      } else {
        statusMap[status] = {
          "count": 1,
          "checkBoxController": true,
          "stockTakeLineList": [element]
        };
      }
    });
  }

  void _onChanged(bool value) {
    setState(() {
      var checkboxValue = false;
      checkboxValue = value;
      print("_onChanged");
    });
  }

  List<Widget> getTextCheckBoxWigetList() {
    List<Widget> tempList = [];
    statusMap.forEach((status, statusDict) {
      tempList.add(Row(
        children: [
          Text("$status"),
          Checkbox(
            value: statusDict["checkBoxController"],
            activeColor: Colors.red, //选中时的颜色
            onChanged: (value) async {
              // await FlutterCheckboxDialog().showCheckboxDialog(
              //   context,
              //   statusDict["checkBoxController"],
              //   const Text('item1'),
              //   _onChanged,
              //   title: const Text('Main Title'),
              //   // content: const Text('Sub Title'),
              //   actions: [
              //     TextButton(
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //       child: const Text('OK'),
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //       child: const Text('cancel'),
              //     ),
              //   ],
              // );
              //

              // statusDict["checkBoxController"] = value;
              // print("controller status: ");
              // print(statusDict["checkBoxController"]);
              // Navigator.of(context).pop();
              // DialogHelper.showTwoOptionsFilterDialog(
              //     context, _onTrueFunction,
              //     widgetList: widgetList,
              //     trueOptionText: "filter",
              //     falseOptionText: "cancel");
              // setState(() {
              //
              //   statusDict["checkBoxController"] = value;
              //   print("controller status: ");
              //   print(statusDict["checkBoxController"]);
              //   Navigator.of(context).pop();
              //   DialogHelper.showTwoOptionsFilterDialog(
              //       context, _onTrueFunction,
              //       widgetList: widgetList,
              //       trueOptionText: "filter",
              //       falseOptionText: "cancel");
              // });
            },
          )
        ],
      ));

      // tempList.add(Text("$status"));
      // tempList.add(Checkbox(
      //   value: statusDict["checkBoxController"],
      //   activeColor: Colors.red, //选中时的颜色
      //   onChanged:(value){
      //     setState(() {
      //       statusDict["checkBoxController"]=value;
      //       print(statusDict);
      //     });
      //   } ,
      // ));
    });

    return tempList;
  }

  List<Widget> getCountTextWigetList() {
    List<Widget> tempWidgetList = [];
    tempWidgetList.add(SizedBox(height: 5));
    if (statusMap != null) {
      statusMap.forEach((key, value) {
        tempWidgetList.add(Text("Total $key : ${value["count"]}"));
        tempWidgetList.add(SizedBox(height: 5));
      });
    }
    return tempWidgetList;
  }

  dynamic getStatusNameDictList() {
    var tempDictList = [];
    // tempWidgetList.add(SizedBox(height: 5));
    if (statusMap != null) {
      statusMap.forEach((key, value) {
        tempDictList.add({"status": key, "value": key});
      });
    }
    return tempDictList;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.arg.item!.createdDate);
    return Scaffold(
      appBar: EchoMeAppBar(titleText: "stockTake".tr(gender: "detail_page_title")),
      body: SizedBox.expand(
        child: Column(children: [
          _getDocumentInfo(context),
          // getMultForm(),
          _getFilterBar(context),
          _getListBox(context)
        ]),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedFontSize: 12,
      //   selectedItemColor: Colors.black54,
      //   unselectedItemColor: Colors.black54,
      //   selectedIconTheme:
      //   const IconThemeData(color: Colors.black54, size: 25, opacity: .8),
      //   unselectedIconTheme:
      //   const IconThemeData(color: Colors.black54, size: 25, opacity: .8),
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.change_circle),
      //       label: 'Change Equipment',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.signal_cellular_alt),
      //       label: 'Re-Scan',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.book),
      //       label: 'Complete',
      //     ),
      //     // BottomNavigationBarItem(
      //     //   icon: Icon(Icons.eleven_mp),
      //     //   label: 'Debug',
      //     // ),
      //   ],
      //   // onTap: (int index) => _onBottomBarItemTapped(args, index),
      // )
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
                final listItemJson =
                _stockTakeStore.filtereditemLineList[index].toJson();
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
              })),
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
    int dataInt = widget.arg.item?.createdDate ?? 0;
    String dataString = "";
    String locCode = widget.arg.stockTakeLineItem?.locCode ?? "";
    if (dataInt != 0) {
      dataString = dataInt.toString();
    }
    ;
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
            Text("stockTake".tr(gender: "detail_page_reg_num") +": " + widget.arg.stNum),
            SizedBox(height: 5),
            // ignore: unnecessary_String_comparison
            Text(
                "stockTake".tr(gender: "detail_page_document_date") + " : ${(dataString as String).isNotEmpty ? inputFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataString))) : ""}"),
            const SizedBox(height: 5),
            Text(
                "stockTake".tr(gender: "detail_page_location") + ": ${(locCode as String).isNotEmpty ? locCode : ""}"),
            const SizedBox(height: 5),
            // Text("ShipperCode: ${widget.arg.item?.shipperCode.toString()}"),
            // const SizedBox(height: 5),
            // Text("Total Product : $totalProduct"),
            // const SizedBox(height: 5),
            // Text("Total Quantity : $totalQuantity"),
            // const SizedBox(height: 5),
            // Text("Total Tracker : $totalTracker"),
            ...getCountTextWigetList()
          ],
        ),
      ),
    );
  }

  void _onTrueFunction() {
    print("hello World");
    updateFilteredList();
  }

  void updateFilteredList() {
    setState(() {
      _stockTakeStore.updateFilteredList();
      // widgetList = getTextCheckBoxWigetList();
    });

  }

  List? _myActivities;

  Widget getMultForm(){
    return MultiSelectFormField(
      autovalidate: AutovalidateMode.disabled,
      chipBackGroundColor: Colors.blue,
      chipLabelStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white),
      dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
      checkBoxActiveColor: Colors.blue,
      checkBoxCheckColor: Colors.white,
      dialogShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Text(
        "Filter:",
        style: TextStyle(fontSize: 16),
      ),
      validator: (value) {
        if (value == null || value.length == 0) {
          return 'Please select one or more options';
        }
        return null;
      },
      // dataSource: [
      //   {
      //     "status": "Running",
      //     "value": "Running",
      //     "value2": "Running",
      //   },
      //   {
      //     "status": "Climbing",
      //     "value": "Climbing",
      //     "value2": "Running",
      //   },
      //   {
      //     "status": "Walking",
      //     "value": "Walking",
      //     "value2": "Running",
      //   },
      //   {
      //     "status": "Swimming",
      //     "value": "Swimming",
      //     "value2": "Running",
      //   },
      //   {
      //     "status": "Soccer Practice",
      //     "value": "Soccer Practice",
      //     "value2": "Running",
      //   },
      //   {
      //     "status": "Baseball Practice",
      //     "value": "Baseball Practice",
      //     "value2": "Running",
      //   },
      //   {
      //     "status": "Football Practice",
      //     "value": "Football Practice",
      //     "value2": "Running",
      //   },
      // ],
      dataSource: getStatusNameDictList(),
      textField: 'status',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      hintWidget: Text('Please choose one or more'),
      initialValue: statusMap.keys.toList(),
      onSaved: (value) {
        if (value == null || value.isEmpty) {
          setState(() {
            statusMap.forEach((key, value) {value["checkBoxController"] = true;});
          });
          return;
        }
        setState(() {
          // _myActivities = value;
          statusMap.forEach((key, value) {value["checkBoxController"] = false;});
          (value as List).forEach((element) {
            String statusStr = element;
            statusMap[statusStr]["checkBoxController"] = true;
          });
          _stockTakeStore.updateFilteredList();
        });
      },
    );
  }



  Widget _getFilterBar(BuildContext ctx) {
    // widgetList = getTextCheckBoxWigetList();
    // widgetList = [getMultForm()];
    return AppContentBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row(children: [widgetList[0], widgetList[1], widgetList[2], widgetList[3]],),
            // Row(children: [widgetList[4], widgetList[5], widgetList[6], widgetList[7]],),
            // IconButton(
            //     onPressed: () {
            //       print("Hello");
            //       DialogHelper.showTwoOptionsFilterDialog(
            //           context, _onTrueFunction,
            //           widgetList: widgetList,
            //           trueOptionText: "filter",
            //           falseOptionText: "cancel");
            //     },
            //     icon: Icon(Icons.more_vert))
            getMultForm()
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
