import 'dart:async';
import 'dart:math';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/network/apis/asset_return/asset_return_api.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/models/equipment_data/equipment_data.dart';
import 'package:echo_me_mobile/pages/asset_return/assset_return_scan_detail_page.dart';
import 'package:echo_me_mobile/stores/asset_return/asset_return_scan_store.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:echo_me_mobile/pages/asset_return/asset_return_scan_page_arguments.dart';
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



class AssetReturnScanPage extends StatefulWidget {
  const AssetReturnScanPage({Key? key}) : super(key: key);

  @override
  State<AssetReturnScanPage> createState() => _AssetReturnScanPageState();
}

class _AssetReturnScanPageState extends State<AssetReturnScanPage> {
  final AssetReturnScanStore _assetReturnScanStore =
  getIt<AssetReturnScanStore>();
  List<dynamic> disposer = [];
  final AssetReturnApi api = getIt<AssetReturnApi>();
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
    return _assetReturnScanStore.chosenEquipmentData.isNotEmpty
        ? (_assetReturnScanStore
        .chosenEquipmentData[0].containerCode ??
        "")
        : "";
  }

  String _getcontainerAssetCode(){
    return _assetReturnScanStore.chosenEquipmentData.isNotEmpty
        ? (_assetReturnScanStore
        .chosenEquipmentData[0].containerAssetCode ??
        "")
        : "";
  }

  Future<void> _changeEquipment(AssetReturnScanPageArguments? args) async {
    print("change equ");
    try {
      if (args?.rtnNum == null) {
        throw "Reg Number Not Found";
      }

      if (_getcontainerAssetCode().isEmpty) {
        throw "Container Code not found";
      }

      if (_assetReturnScanStore.itemRfidDataSet.isEmpty) {
        throw "Assets List is empty";
      }

      if (_assetReturnScanStore.chosenEquipmentData.isEmpty) {
        throw "No equipment detected";
      }

      var targetcontainerAssetCode = _getcontainerAssetCode();

      List<String> rfidList = [];
      for (var element in _assetReturnScanStore.equipmentData) {
        if (element.containerAssetCode == targetcontainerAssetCode) {
          if (element.rfid != null) {
            rfidList.add(element.rfid!);
          }
        }
      }

      try {
        await _assetReturnScanStore.registerContainer(
            rfid: rfidList, rtnNum: args?.rtnNum ?? "", throwError: true);
      } catch (e) {
        if (!e.toString().contains("Error 2109")) {
          rethrow;
        }
      }

      List<String> itemRfid = _assetReturnScanStore.itemRfidDataSet
          .map((e) => AscToText.getString(e))
          .toList();
      // TODO: wait for update containerAssetCode accept multi value
      await _assetReturnScanStore.registerItem(
          rtnNum: args?.rtnNum ?? "",
          itemRfid: itemRfid,
          containerAssetCode: targetcontainerAssetCode,
          throwError: true);
      _assetReturnScanStore.reset();
    } catch (e) {
      _assetReturnScanStore.errorStore.setErrorMessage(e.toString());
    }
  }

  void _rescan() {
    _assetReturnScanStore.reset();
  }

  void _rescanContainer(){
    _assetReturnScanStore.resetContainer();
  }

  Future<void> _complete(AssetReturnScanPageArguments? args) async {
    _assetReturnScanStore.complete(rtnNum: args?.rtnNum ?? "");
  }

  Future<void> _onBottomBarItemTapped(AssetReturnScanPageArguments? args, int index) async {
    if (index == 0) {
      bool? flag = await DialogHelper.showTwoOptionsDialog(context,
          title: "Confirm to Change Equipment(s)?", trueOptionText: "Change", falseOptionText: "Cancel");
      if (flag == true) {
        _changeEquipment(args);
        _showSnackBar("Change Successfully");
        // _assetReturnScanStore.reset();
      }
    } else if (index == 1) {
      bool? flag = await DialogHelper.showTwoOptionsDialog(context,
          title: "Confirm to Rescan?", trueOptionText: "Rescan", falseOptionText: "Cancel");
      if (flag == true) {
        _rescan();
        _showSnackBar("Data Cleaned");
      }
    } else if (index == 2){
      bool? flag = await DialogHelper.showTwoOptionsDialog(context,
          title: "Confirm to Complete?", trueOptionText: "Complete", falseOptionText: "Cancel");
      if (flag == true) {
        _complete(args);
        _showSnackBar("Complete Successfully");
        // _assetReturnScanStore.reset();
      }

    } else if (index == 3){ // debug version
      DialogHelper.showCustomDialog(context, widgetList: [
        Text("More than one container code detected, please rescan")
      ], actionList: [
        TextButton(
          child: const Text('test1'),
          onPressed: () {
            _addTest1();
            Navigator.of(context).pop();
          },
        )
        ,
        TextButton(
          child: const Text('test2'),
          onPressed: () {
            _addTest2();
            Navigator.of(context).pop();
          },
        )
      ]);
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
          if (element.substring(0, 2) == "63" ||
              element.substring(0, 2) == "43") {
            equ.add(element);
          } else if (element.substring(0, 2) == "53" ||
              element.substring(0, 2) == "73") {
            item.add(element);
          }
        }
        _assetReturnScanStore.updateDataSet(equList: equ, itemList: item);
        print("");
      }
    });
    var disposerReaction = reaction(
            (_) => _assetReturnScanStore.errorStore.errorMessage, (_) {
      if (_assetReturnScanStore.errorStore.errorMessage.isNotEmpty) {
        _showSnackBar(_assetReturnScanStore.errorStore.errorMessage);
      }
    });
    var disposerReaction1 =
    reaction((_) => _assetReturnScanStore.equipmentData, (_) {
      Set<String?> containerAssetCodeSet = Set<String?>();
      // print("disposer1 called");
      _assetReturnScanStore.chosenEquipmentData.forEach((element) => containerAssetCodeSet.add(element.containerAssetCode));
      if (containerAssetCodeSet.length > 1 &&
          !isDialogShown) {
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
          )
          ,
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
    });
    disposer.add(() => eventSubscription.cancel());
    disposer.add(disposerReaction);
    disposer.add(disposerReaction1);
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
    final AssetReturnScanPageArguments? args =
    ModalRoute.of(context)!.settings.arguments as AssetReturnScanPageArguments?;
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
          children: [Text(args != null ? args.rtnNum : "EchoMe")],
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (args != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AssetReturnScanDetailPage(
                            arg: args,
                          )));
                }
              },
              icon: const Icon(MdiIcons.clipboardList)),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.eleven_mp),
            label: 'Debug',
          ),
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
                            _assetReturnScanStore.isFetchingEquData
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
                            _assetReturnScanStore
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

  Widget _getBody(BuildContext ctx, AssetReturnScanPageArguments? args) {
    return Expanded(
      child: Observer(builder: (context) {
        return ListView.builder(
            itemCount: 3 + _assetReturnScanStore.itemRfidDataSet.length,
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
                                    child: Text(_assetReturnScanStore
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
                if (_assetReturnScanStore.itemRfidDataSet.isEmpty) {
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
              var rfid = _assetReturnScanStore.itemRfidDataSet
                  .elementAt(index - 3);
              var isLast = index - 3 ==
                  _assetReturnScanStore.itemRfidDataSet.length - 1
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
                    _assetReturnScanStore.itemRfidDataSet.remove(rfid);
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

  Widget _getTitle(BuildContext ctx, AssetReturnScanPageArguments? args) {
    return BodyTitle(
      title: args?.rtnNum ?? "No RegNum",
      clipTitle: "Hong Kong-DC",
    );
  }

  void _addMockAssetId() {
    _assetReturnScanStore.updateDataSet(
        itemList: [AscToText.getAscIIString(Random().nextInt(50).toString())]);
  }

  void _addMockEquipmentId() {
    // var init = _assetReturnScanStore.equipmentRfidDataSet.length;
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
    _assetReturnScanStore.updateDataSet(equList: list);
  }


  void _addTest1(){
    List<String> list = [];
    list.add(AscToText.getAscIIString("CATL010000001360")); // box 1
    list.add(AscToText.getAscIIString("SATL010000006871")); // item 1
    _assetReturnScanStore.updateDataSet(equList: list);
  }

  void _addTest2(){
    List<String> list = [];
    list.add(AscToText.getAscIIString("CATL010000001371")); // box 2
    list.add(AscToText.getAscIIString("SATL010000006882")); // item 2
    _assetReturnScanStore.updateDataSet(equList: list);
  }
}
