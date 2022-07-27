import 'dart:async';
import 'dart:math';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/network/apis/stock_take/stock_take_api.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/models/equipment_data/equipment_data.dart';
import 'package:echo_me_mobile/pages/asset_registration/assset_scan_detail_page.dart';
import 'package:echo_me_mobile/pages/stock_take/stock_take_scan_detail_page.dart';
import 'package:echo_me_mobile/stores/stock_take/stock_take_scan_store.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_line_item.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';
import 'stock_take_scan_page_arguments.dart';


class StockTakeScanPage extends StatefulWidget {
  const StockTakeScanPage({Key? key}) : super(key: key);

  @override
  State<StockTakeScanPage> createState() => _StockTakeScanPageState();
}

class _StockTakeScanPageState extends State<StockTakeScanPage> {
  final StockTakeScanStore _stockTakeScanStore =
      getIt<StockTakeScanStore>();
  List<dynamic> disposer = [];
  final StockTakeApi api = getIt<StockTakeApi>();
  final Repository repository = getIt<Repository>();

  bool isDialogShown = false;

  final AccessControlStore accessControlStore = getIt<AccessControlStore>();

  void _showSnackBar(String? str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str ?? ""),
      ),
    );
  }

  String _getContainerCode() {
    return _stockTakeScanStore.chosenEquipmentData.isNotEmpty
        ? (_stockTakeScanStore.chosenEquipmentData[0].containerCode ??
            "")
        : "";
  }

  String _getcontainerAssetCode() {
    return _stockTakeScanStore.chosenEquipmentData.isNotEmpty
        ? (_stockTakeScanStore
                .chosenEquipmentData[0].containerAssetCode ??
            "")
        : "";
  }

  Future<bool> _changeEquipment(StockTakeScanPageArguments? args) async {
    print("change equ");
    try {
      if (args?.stNum == null) {
        throw "Reg Number Not Found";
      }

      // if (_getcontainerAssetCode().isEmpty) {
      //   throw "Container Code not found";
      // }

      if (_stockTakeScanStore.itemRfidDataSet.isEmpty) {
        throw "Assets List is empty";
      }

      // if (_stockTakeScanStore.chosenEquipmentData.isEmpty) {
      //   throw "No equipment detected";
      // }

      var targetcontainerAssetCode = _getcontainerAssetCode();

      List<String> rfidList = [];
      for (var element in _stockTakeScanStore.equipmentData) {
        if (element.containerAssetCode == targetcontainerAssetCode) {
          if (element.rfid != null) {
            rfidList.add(element.rfid!);
          }
        }
      }

      // try {
      //   await _stockTakeScanStore.registerContainer(
      //       rfid: rfidList, regNum: args?.regNum ?? "", throwError: true);
      // } catch (e) {
      //   if (!e.toString().contains("Error 2109")) {
      //     // _assetRegistrationScanStore.errorStore.setErrorMessage(e.toString());
      //     // rethrow;
      //     print(e.toString());
      //   }
      //   // rethrow;
      // }

      List<String> itemRfid = _stockTakeScanStore.itemRfidDataSet
          .map((e) => AscToText.getString(e))
          .toList();
      // await _stockTakeScanStore.registerItem(
      //     regNum: args?.regNum ?? "",
      //     itemRfid: itemRfid,
      //     containerAssetCode: targetcontainerAssetCode,
      //     throwError: true);

      await _stockTakeScanStore.registerStockTakeItem(
          stNum: args?.stNum ?? "",
          itemRfid: itemRfid,
          locCode: args?.stockTakeLineItem?.locCode ?? "",
          throwError: true);


      _stockTakeScanStore.reset();
      return true;
    } catch (e) {
      _stockTakeScanStore.errorStore.setErrorMessage(e.toString());
      return false;
    }
  }

  void _rescan() {
    _stockTakeScanStore.reset();
  }

  Future<bool> _reCount(StockTakeScanPageArguments? args) async{
    try {
      _stockTakeScanStore.stocktakeRecountByLoc(stNum: args?.stNum ?? "", locCode: args?.stockTakeLineItem?.locCode ?? "No Loc");
      _rescan();
      return true;
    }catch(e){
      return false;
    }
  }

  void _rescanContainer() {
    _stockTakeScanStore.resetContainer();
  }

  Future<bool> _completeStockTakeLine(StockTakeScanPageArguments? args) async {
    try {
      _stockTakeScanStore.completeStockTakeLine(stNum: args?.stNum ?? "", locCode: args?.stockTakeLineItem?.locCode ?? "No Loc");
      return true;
    }catch(e){
      return false;
    }
  }

  Future<String> fetchData(StockTakeScanPageArguments? args) async {
    String stNum = args?.stNum ?? "";
    String locCode = args?.stockTakeLineItem?.locCode ?? "";
    var result = await repository.getStockTakeLine(
        page: 0, limit: 0, stNum: stNum, locCode: locCode);
    // var result = await repository.fetchStLineData2(args);
    // var newTotalProduct = (result as List).length.toString();
    // int newTotalQuantity = 0;
    // int totalRegQuantity = 0;
    // (result as List).forEach((e) {
    //   try{
    //     newTotalQuantity += e["quantity"] as int ;
    //     totalRegQuantity += e["checkinQty"] as int;
    //   }catch(e){
    //     print(e);
    //   };
    // });
    //
    // return "Total: $totalRegQuantity / $newTotalQuantity";
    var totalQty = result.rowNumber;
    List<StockTakeLineItem> lineList = result.itemList;
    Map<String, int> countMap = new Map<String, int>();
    lineList.forEach((element) {
      String status = element.status ?? "";
      if (countMap.containsKey(status)){
        if (countMap[status] != null) {
          countMap[status] = countMap[status]! + 1;
        }
      }else{
        countMap[status] = 0;
      }
    });
    return countMap.toString();
  }

  Future<void> _onBottomBarItemTapped(
      StockTakeScanPageArguments? args, int index) async {
    try{
      if (index == 0) {
        if (!accessControlStore.hasARChangeRight) throw "No Change Right";
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "Confirm to Change Equipment(s)?",
            trueOptionText: "Change",
            falseOptionText: "Cancel");
        if (flag == true) {
          await _changeEquipment(args) ?_showSnackBar("Change Successfully") : "";

          // _assetRegistrationScanStore.reset();
        }
      } else if (index == 1) {
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "Confirm to ReCount?",
            trueOptionText: "ReCounrt",
            falseOptionText: "Cancel");
        if (flag == true) {
          await _reCount(args) ? _showSnackBar("Complete Successfully") : "";
          _showSnackBar("Data Cleaned");
        }
      } else if (index == 2) {
        if (!accessControlStore.hasARCompleteRight) throw "No Complete Right";
        String regLineStr = await fetchData(args);
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "Confirm to Complete?\n\nChecked-In Items:\n" + regLineStr,
            trueOptionText: "Complete",
            falseOptionText: "Cancel");
        if (flag == true) {
          await _completeStockTakeLine(args) ? _showSnackBar("Complete Successfully") : "";
          // _assetRegistrationScanStore.reset();
        }
      } else if (index == 3) {
        // debug version
        DialogHelper.showCustomDialog(context, widgetList: [
          Text("More than one container code detected, please rescan")
        ], actionList: [
          TextButton(
            child: const Text('DContainesrs'),
            onPressed: () {
              _addMockEquipmentIdCaseOne();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('mockScan1'),
            onPressed: () {
              _mockscan1();
              Navigator.of(context).pop();
            },
          )
        ]);
      }
    }catch (e){
      _stockTakeScanStore.errorStore.setErrorMessage(e.toString());
    }

  }

  @override
  void initState() {
    super.initState();
    var eventSubscription = ZebraRfd8500.eventStream.listen((event) {
      print(event);
      print(event.type);
      if (event.type == ScannerEventType.readEvent) {
        List<String> item = [];
        List<String> equ = [];
        for (var element in (event.data as List<String>)) {
          // if (element.substring(0, 2) == "63" ||
          //     element.substring(0, 2) == "43") {
          //   equ.add(element);
          // } else if (element.substring(0, 2) == "53" ||
          //     element.substring(0, 2) == "73") {
          //   item.add(element);
          // }
          item.add(element);
        }
        _stockTakeScanStore.updateDataSet(equList: equ, itemList: item);
        print("");
      }
    });
    var disposerReaction = reaction(
        (_) => _stockTakeScanStore.errorStore.errorMessage, (_) {
      if (_stockTakeScanStore.errorStore.errorMessage.isNotEmpty) {
        _showSnackBar(_stockTakeScanStore.errorStore.errorMessage);
      }
    });
    var scanDisposeReaction =
        reaction((_) => _stockTakeScanStore.equipmentData, (_) {
          try{
            if (!accessControlStore.hasARScanRight) throw "No Scan Right";
            Set<String?> containerAssetCodeSet = Set<String?>();
            // print("disposer1 called");
            _stockTakeScanStore.chosenEquipmentData.forEach(
                    (element) => containerAssetCodeSet.add(element.containerAssetCode));
            if (containerAssetCodeSet.length > 1 && !isDialogShown) {
              isDialogShown = true;
              DialogHelper.showCustomDialog(context, widgetList: [
                Text("More than one container code detected, please rescan")
              ], actionList: [
                TextButton(
                  child: const Text('Rescan Container'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _rescanContainer();
                    isDialogShown = false;
                  },
                ),
                TextButton(
                  child: const Text('Rescan'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _rescan();
                    isDialogShown = false;
                  },
                )
              ]);
            }
          }catch (e){
            _stockTakeScanStore.errorStore.setErrorMessage(e.toString());
          }

    });
    disposer.add(() => eventSubscription.cancel());
    disposer.add(disposerReaction);
    disposer.add(scanDisposeReaction);
  }

  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < disposer.length; i++) {
      disposer[i]();
    }
  }

  @override
  Widget build(BuildContext context) {
    final StockTakeScanPageArguments? args =
        ModalRoute.of(context)!.settings.arguments as StockTakeScanPageArguments?;
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 10),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: <Widget>[
      //       FloatingActionButton(
      //           heroTag: null,
      //           child: const Icon(Icons.add_box),
      //           onPressed: _addMockEquipmentId),
      //       const SizedBox(
      //         width: 20,
      //       ),
      //       FloatingActionButton(
      //         heroTag: null,
      //         onPressed: _addMockAssetId,
      //         child: const Icon(MdiIcons.cart),
      //       )
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        title: Row(
          children: [Text(args != null ? args.stNum : "EchoMe")],
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (args != null) {
                  print("startStockTake");
                  _stockTakeScanStore.startStockTake(stNum: args.stNum);
                }
              },
              icon: const Icon(MdiIcons.clockStart)),
          IconButton(
              onPressed: () {
                if (args != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => StockTakeScanDetailPage(
                            arg: args,
                          )));
                }
              },
              icon: const Icon(MdiIcons.clipboardList))
        ],
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
            label: 'Check-In RFIDs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.signal_cellular_alt),
            label: 'Re-Count',
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
        onTap: (int index) => _onBottomBarItemTapped(args, index),
      ),
      body: SizedBox.expand(
        child: Column(
          children: [_getTitle(context, args), _getBody(context, args)],
        ),
      ),
    );
  }

  Widget _getEquipmentDisplay() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 0, maxHeight: 350),
      child: AppContentBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Observer(
                      builder: (context) {
                        return Row(
                          children: [
                            Text(
                              "Equipment",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            _stockTakeScanStore.isFetchingEquData
                                ? const SpinKitDualRing(
                                    color: Colors.blue,
                                    size: 15,
                                    lineWidth: 2,
                                  )
                                : const SizedBox()
                          ],
                        );
                      },
                    ),
                    Observer(
                      builder: (context) => Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            _stockTakeScanStore
                                .equipmentRfidDataSet.length
                                .toString(),
                          ),
                        ),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Container Code :",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 40,
                      width: 40,
                    ),
                    Expanded(
                      child: Observer(
                        builder: ((context) => Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.blueAccent)),
                              child: Center(
                                child: Text(_getContainerCode()),
                              ),
                            )),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody(BuildContext ctx, StockTakeScanPageArguments? args) {
    return Expanded(
      child: Observer(builder: (context) {
        return ListView.builder(
            itemCount: 3 + _stockTakeScanStore.itemRfidDataSet.length,
            itemBuilder: (ctx, index) {
              if (index == 0) {
                return _getEquipmentDisplay();
              }
              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.horizontal_padding),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border(
                              left: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 6),
                              right: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 6),
                              bottom: BorderSide(color: Colors.grey.shade400))),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Asset List",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Container(
                                width: 40,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: Text(_stockTakeScanStore
                                        .itemRfidDataSet.length
                                        .toString())),
                              )
                            ]),
                      ),
                    ),
                  ),
                );
              }
              if (index == 2) {
                if (_stockTakeScanStore.itemRfidDataSet.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.horizontal_padding),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.symmetric(
                              vertical: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 6),
                            )),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(Dimens.horizontal_padding),
                          child: Center(
                              child: Text("No Data",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(fontSize: 30))),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }
              var rfid = _stockTakeScanStore.itemRfidDataSet
                  .elementAt(index - 3);
              var isLast = index - 3 ==
                      _stockTakeScanStore.itemRfidDataSet.length - 1
                  ? true
                  : false;
              return _getAssetListItem(rfid, isLast);
            });
      }),
    );
  }

  Widget _assetListContainer(bool isLast, Widget? child) {
    if (isLast) {
      return ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: child);
    }
    return SizedBox(child: child);
  }

  Widget _getAssetListItem(rfid, isLast) {
    var child = Container(
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.symmetric(
            vertical:
                BorderSide(color: Theme.of(context).primaryColor, width: 6),
          )),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text(
            AscToText.getString(rfid),
            style: Theme.of(context).textTheme.bodyMedium,
          )),
          Material(
            borderRadius: BorderRadius.circular(50),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    _stockTakeScanStore.itemRfidDataSet.remove(rfid);
                  });
                },
                icon: const Icon(Icons.close)),
          )
        ]),
      ),
    );

    return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimens.horizontal_padding),
        child: _assetListContainer(isLast, child));
  }

  Widget _getTitle(BuildContext ctx, StockTakeScanPageArguments? args) {
    return BodyTitle(
      title: (args?.stNum ?? "No RegNum") + "\n" + "[" + (args?.stockTakeLineItem?.locCode ?? "No Loc") + "]" + "" +" (ST)",
      clipTitle: "Hong Kong-DC",
    );
  }

  void _addMockAssetId() {
    _stockTakeScanStore.updateDataSet(
        itemList: [AscToText.getAscIIString(Random().nextInt(50).toString())]);
  }

  void _addMockEquipmentId() {
    // var init = _assetRegistrationScanStore.equipmentRfidDataSet.length;
    var init = 0;
    List<String> list = [];
    if (init == 0) {
      list.add(AscToText.getAscIIString("CATL010000000820"));
    } else if (init == 1) {
      list.add(AscToText.getAscIIString("CATL010000000831"));
    } else if (init == 2) {
      list.add(AscToText.getAscIIString("CATL010000000077"));
    } else if (init == 3) {
      list.add(AscToText.getAscIIString("CATL010000000088"));
    } else {
      list.add(AscToText.getAscIIString(new Random().nextInt(50).toString()));
    }
    _stockTakeScanStore.updateDataSet(equList: list);
  }

  void _addMockEquipmentIdCaseOne() {
    List<String> list = [];
    list.add(AscToText.getAscIIString("CATL010000001382"));
    list.add(AscToText.getAscIIString("CATL010000000842"));
    _stockTakeScanStore.updateDataSet(equList: list);
  }

  void _addMockEquipmentIdCaseTwo() {
    List<String> list = [];
    list.add(AscToText.getAscIIString("CATL010000000808"));
    list.add(AscToText.getAscIIString("CATL010000000819"));
    _stockTakeScanStore.updateDataSet(equList: list);
  }

  void _mockscan1() {
    List<String> list1 = [];
    // list1.add(AscToText.getAscIIString("CATL010000000808"));
    // list1.add(AscToText.getAscIIString("CATL010000000819"));
    List<String> list2 = [];
    // list2.add(AscToText.getAscIIString("SATL010000000808"));
    // list2.add(AscToText.getAscIIString("SATL010000000819"));
    // list2.add(AscToText.getAscIIString("CATL010000000808"));
    list2.add(AscToText.getAscIIString("SATL010000032555"));
    _stockTakeScanStore.updateDataSet(equList: list1, itemList: list2);
  }
}
