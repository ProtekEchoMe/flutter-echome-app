import 'dart:async';
import 'dart:math';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_detail_page.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_scan_store.dart';
import 'package:echo_me_mobile/stores/transfer_out/transfer_out_scan_store.dart';
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
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_scan_page_arguments.dart';

class TransferOutScanPage extends StatefulWidget {
  const TransferOutScanPage({Key? key}) : super(key: key);

  @override
  State<TransferOutScanPage> createState() => _TransferOutPageState();
}

class _TransferOutPageState extends State<TransferOutScanPage> {
  final TransferOutScanStore _transferOutScanStore =
      getIt<TransferOutScanStore>();
  List<dynamic> disposer = [];
  final AssetRegistrationApi api = getIt<AssetRegistrationApi>();
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
    return _transferOutScanStore.chosenEquipmentData.isNotEmpty
        ? (_transferOutScanStore.chosenEquipmentData[0].containerCode ??
            "")
        : "";
  }

  String _getcontainerAssetCode() {
    return _transferOutScanStore.chosenEquipmentData.isNotEmpty
        ? (_transferOutScanStore
                .chosenEquipmentData[0].containerAssetCode ??
            "")
        : "";
  }

  Future<bool> _changeEquipment(TransferOutScanPageArguments? args) async {
    print("change equ");
    try {
      if (args?.toNum == null) {
        throw "TO Number Not Found";
      }

      // if (_getcontainerAssetCode().isEmpty) {
      //   throw "Container Code not found";
      // }

      if (_transferOutScanStore.itemRfidDataSet.isEmpty) {
        throw "Assets List is empty";
      }

      // if (_transferOutScanStore.chosenEquipmentData.isEmpty) {
      //   throw "No equipment detected";
      // }

      var targetcontainerAssetCode = _getcontainerAssetCode();

      List<String> rfidList = [];
      for (var element in _transferOutScanStore.equipmentData) {
        if (element.containerAssetCode == targetcontainerAssetCode) {
          if (element.rfid != null) {
            rfidList.add(element.rfid!);
          }
        }
      }

      if (_getcontainerAssetCode().isNotEmpty) {
        try {
          await _transferOutScanStore.checkInTOContainer(
              rfid: rfidList, toNum: args?.toNum ?? "", throwError: true);
        } catch (e) {
          if (!e.toString().contains("Error 2109")) {
            // _assetRegistrationScanStore.errorStore.setErrorMessage(e.toString());
            // rethrow;
            print(e.toString());
          }
          // rethrow;
        }
      }

      List<String> itemRfid = _transferOutScanStore.itemRfidDataSet
          .map((e) => AscToText.getString(e))
          .toList();

      bool directTO = false;
      if (args != null && args.toNum.startsWith('TO'))
        directTO = true;

      await _transferOutScanStore.checkInTOItem(
          toNum: args?.toNum ?? "",
          itemRfid: itemRfid,
          containerAssetCode: targetcontainerAssetCode,
          throwError: true,
      directTO: directTO);
      _transferOutScanStore.reset();
      return true;
    } catch (e) {
      _transferOutScanStore.errorStore.setErrorMessage(e.toString());
      return false;
    }
  }

  void _rescan() {
    _transferOutScanStore.reset();
  }

  void _rescanContainer() {
    _transferOutScanStore.resetContainer();
  }

  Future<bool> _complete(TransferOutScanPageArguments? args) async {
    try{
      _transferOutScanStore.complete(toNum: args?.toNum ?? "");
      return true;
    }catch(e) {
      return false;
    }
  }

  Future<String> fetchData(TransferOutScanPageArguments? args) async {

    var result = await repository.fetchToLineData(args);
    var newTotalProduct = (result as List).length.toString();
    int newTotalQuantity = 0;
    int totalRegQuantity = 0;
    (result).forEach((e) {
      try{
        newTotalQuantity += e["quantity"] as int ;
        totalRegQuantity += e["checkinQty"] as int;
      }catch(e){
        print(e);
      };
    });

    return "transferOut".tr(gender: "bottom_bar_total") + ": $totalRegQuantity / $newTotalQuantity";

  }

  Future<void> _onBottomBarItemTapped(
      TransferOutScanPageArguments? args, int index) async {
    try{
      if (index == 0) {
        if (!accessControlStore.hasARChangeRight) throw "transferOut".tr(gender: "scan_page_no_right_change");
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "transferOut".tr(gender: "scan_page_confirm_to_change"),
            trueOptionText: "transferOut".tr(gender: "scan_page_change_confirm_option"),
            falseOptionText: "transferOut".tr(gender: "scan_page_change_cancel_option"));
        if (flag == true) {
          await _changeEquipment(args)? _showSnackBar("transferOut".tr(gender: "scan_page_change_success")) : "";

          // _assetRegistrationScanStore.reset();
        }
      } else if (index == 1) {
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "transferOut".tr(gender: "scan_page_confirm_to_rescan"),
            trueOptionText: "transferOut".tr(gender: "scan_page_rescan_confirm_option"),
            falseOptionText: "transferOut".tr(gender: "scan_page_rescan_cancel_option"));
        if (flag == true) {
          _rescan();
          _showSnackBar("transferOut".tr(gender: "scan_page_rescan_success"));
        }
      } else if (index == 2) {
        if (!accessControlStore.hasARCompleteRight) throw "transferOut".tr(gender: "scan_page_no_right_complete");
        String regLineStr = await fetchData(args);
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "transferOut".tr(gender: "scan_page_confirm_to_complete") + "\n\n" + regLineStr,
            trueOptionText: "transferOut".tr(gender: "scan_page_complete_confirm_option"),
            falseOptionText: "transferOut".tr(gender: "scan_page_complete_cancel_option"));
        if (flag == true) {
          await _complete(args) ? _showSnackBar("transferOut".tr(gender: "scan_page_complete_success")) : "";

          // _assetRegistrationScanStore.reset();
        }
        // _mockscan1();
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
            child: const Text('ITEMS'),
            onPressed: () {
              _addMockEquipmentIdCaseThree();
              Navigator.of(context).pop();
            },
          )
        ]);
      }
    }catch (e){
      _transferOutScanStore.errorStore.setErrorMessage(e.toString());
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
        _transferOutScanStore.updateDataSet(equList: equ, itemList: item);
        print("");
      }
    });
    var disposerReaction = reaction(
        (_) => _transferOutScanStore.errorStore.errorMessage, (_) {
      if (_transferOutScanStore.errorStore.errorMessage.isNotEmpty) {
        DialogHelper.showErrorDialogBox(context, errorMsg: _transferOutScanStore.errorStore.errorMessage);
        _showSnackBar(_transferOutScanStore.errorStore.errorMessage);
      }
    });
    var disposerReaction1 =
        reaction((_) => _transferOutScanStore.equipmentData, (_) {
          try{
            if (!accessControlStore.hasARScanRight) throw "transferOut".tr(gender: "scan_page_no_right_scan");
            Set<String?> containerAssetCodeSet = Set<String?>();
            // print("disposer1 called");
            _transferOutScanStore.chosenEquipmentData.forEach(
                    (element) => containerAssetCodeSet.add(element.containerAssetCode));
            if (containerAssetCodeSet.length > 1 && !isDialogShown) {
              isDialogShown = true;
              DialogHelper.showCustomDialog(context, widgetList: [
                Text("transferOut".tr(gender: "scan_page_more_than_one_container"))], actionList: [
                TextButton(
                  child:  Text("transferOut".tr(gender: "scan_page_rescan_container_option")),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _rescanContainer();
                    isDialogShown = false;
                  },
                ),
                TextButton(
                  child:  Text("transferOut".tr(gender: "scan_page_rescan_confirm_option")),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _rescan();
                    isDialogShown = false;
                  },
                )
              ]);
            }
          }catch (e){
            _transferOutScanStore.errorStore.setErrorMessage(e.toString());
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
    final TransferOutScanPageArguments? args =
        ModalRoute.of(context)!.settings.arguments as TransferOutScanPageArguments?;
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
          children: [Text(args != null ? args.toNum : "EchoMe")],
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (args != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TransferOutDetailPage(
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.change_circle),
            label: "transferOut".tr(gender: "scan_page_checkIn"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.signal_cellular_alt),
            label: "transferOut".tr(gender: "scan_page_rescan"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "transferOut".tr(gender: "scan_page_complete"),
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
                              "transferOut".tr(gender: "scan_page_equipmnet_title"),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            _transferOutScanStore.isFetchingEquData
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
                            _transferOutScanStore
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
                      "transferOut".tr(gender: "scan_page_equipment_container_code_text") + ":",
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

  Widget _getBody(BuildContext ctx, TransferOutScanPageArguments? args) {
    return Expanded(
      child: Observer(builder: (context) {
        return ListView.builder(
            itemCount: 3 + _transferOutScanStore.itemRfidDataSet.length,
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
                                "transferOut".tr(gender: "scan_page_asset_title"),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Container(
                                width: 40,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: Text(_transferOutScanStore
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
                if (_transferOutScanStore.itemRfidDataSet.isEmpty) {
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
                              child: Text("transferOut".tr(gender: "scan_page_no_data"),
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
              var rfid = _transferOutScanStore.itemRfidDataSet
                  .elementAt(index - 3);
              var isLast = index - 3 ==
                      _transferOutScanStore.itemRfidDataSet.length - 1
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
                    _transferOutScanStore.itemRfidDataSet.remove(rfid);
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

  Widget _getTitle(BuildContext ctx, TransferOutScanPageArguments? args) {
    return BodyTitle(
      title: (args?.toNum ?? "No TO Num") + " [TO]" + "\n(${args!.item?.shipToLocation!})",
      clipTitle: "Hong Kong-DC",
    );
  }

  void _addMockAssetId() {
    _transferOutScanStore.updateDataSet(
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
    _transferOutScanStore.updateDataSet(equList: list);
  }

  void _addMockEquipmentIdCaseOne() {
    List<String> list = [];
    list.add(AscToText.getAscIIString("CATL010000000808"));
    list.add(AscToText.getAscIIString("CATL010000000842"));
    _transferOutScanStore.updateDataSet(equList: list);
  }

  void _addMockEquipmentIdCaseTwo() {
    List<String> list = [];
    list.add(AscToText.getAscIIString("CATL010000000808"));
    list.add(AscToText.getAscIIString("CATL010000000819"));
    _transferOutScanStore.updateDataSet(equList: list);
  }
  void _addMockEquipmentIdCaseThree() {
    List<String> list = [];
    // list.add(AscToText.getAscIIString("CATL010000000808"));
    // list.add(AscToText.getAscIIString("CATL010000000819"));
    List<String> itemList = [];
    itemList.add(AscToText.getAscIIString("SATL010000348207"));
    itemList.add(AscToText.getAscIIString("SATL010000348195"));
    _transferOutScanStore.updateDataSet(equList: list, itemList: itemList);
  }

  void _mockscan1() {
    List<String> list1 = [];
    list1.add(AscToText.getAscIIString("CATL010000071468"));
    // list1.add(AscToText.getAscIIString("CATL010000000819"));
    List<String> list2 = [];
    list2.add(AscToText.getAscIIString("SATL010000049373"));
    list2.add(AscToText.getAscIIString("SATL010000049362"));
    list2.add(AscToText.getAscIIString("SATL010000049384"));
    list2.add(AscToText.getAscIIString("SATL010000049395"));
    _transferOutScanStore.updateDataSet(equList: list1, itemList: list2);
  }

}
