import 'dart:async';
import 'dart:math';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/assset_scan_detail_page.dart';
import 'package:echo_me_mobile/pages/transfer_in/transfer_in_detail_page.dart';
import 'package:echo_me_mobile/pages/transfer_in/transfer_in_scan_page_arguments.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_scan_store.dart';
import 'package:echo_me_mobile/stores/transfer_in/transfer_in_scan_store.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';

import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/utils/soundPoolUtil.dart';

class TransferInScanPage extends StatefulWidget {
  const TransferInScanPage({Key? key}) : super(key: key);

  @override
  State<TransferInScanPage> createState() => _AssetScanPageState();
}

class _AssetScanPageState extends State<TransferInScanPage> {
  final TransferInScanStore _transferInScanStore = getIt<TransferInScanStore>();
  List<dynamic> disposer = [];
  final AssetRegistrationApi api = getIt<AssetRegistrationApi>();
  final Repository repository = getIt<Repository>();
  final dioClient = getIt<DioClient>();

  bool isDialogShown = false;

  final AccessControlStore accessControlStore = getIt<AccessControlStore>();
  final SoundPoolUtil soundPoolUtil = SoundPoolUtil();

  void _showSnackBar(String? str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str ?? ""),
      ),
    );
  }

  String _getContainerCode() {
    return _transferInScanStore.chosenEquipmentData.isNotEmpty
        ? (_transferInScanStore.chosenEquipmentData[0].containerCode ??
        "")
        : "";
  }

  String _getcontainerAssetCode() {
    return _transferInScanStore.chosenEquipmentData.isNotEmpty
        ? (_transferInScanStore.chosenEquipmentData[0].containerAssetCode ?? "")
        : "";
  }

  Future<void> _changeEquipment(TransferInScanPageArguments? args) async {
    print("change equ");
    try {
      if (args?.tiNum == null) {
        throw "Ti Number Not Found";
      }

      // if (_getcontainerAssetCode().isEmpty) {
      //   throw "Container Code not found";
      // }

      if (_transferInScanStore.itemRfidDataSet.isEmpty) {
        throw "Assets List is empty";
      }

      // if (_transferInScanStore.chosenEquipmentData.isEmpty) {
      //   throw "No equipment detected";
      // }

      var targetcontainerAssetCode = _getcontainerAssetCode();

      List<String> rfidList = [];
      for (var element in _transferInScanStore.equipmentData) {
        if (element.containerAssetCode == targetcontainerAssetCode) {
          if (element.rfid != null) {
            rfidList.add(element.rfid!);
          }
        }
      }

      try {
        await _transferInScanStore.checkInContainer(
            rfid: rfidList, tiNum: args?.tiNum ?? "", throwError: true);
      } catch (e) {
        if (!e.toString().contains("Error 2109")) {
          // _transferInScanStore.errorStore.setErrorMessage(e.toString());
          // rethrow;
          print(e.toString());
        }
        // rethrow;
      }

      List<String> itemRfid = _transferInScanStore.itemRfidDataSet
          .map((e) => AscToText.getString(e))
          .toList();

      bool directTI = false;
      if (args != null && args.tiNum.startsWith('TI'))
        directTI = true;

      await _transferInScanStore.checkInItem(
          tiNum: args?.tiNum ?? "",
          itemRfid: itemRfid,
          containerAssetCode: targetcontainerAssetCode,
          throwError: true,
          directTI: directTI);
      _transferInScanStore.reset();
    } catch (e) {
      _transferInScanStore.errorStore.setErrorMessage(e.toString());
    }
  }

  void _rescan() {
    _transferInScanStore.reset();
  }

  Future<void> _complete(TransferInScanPageArguments? args) async {
    _transferInScanStore.complete(tiNum: args?.tiNum ?? "");
  }

  Future<String> fetchData(TransferInScanPageArguments? args) async {

    // var result = await repository.fetchTiLineData(args);
    String tiNum = args?.tiNum ?? "";
    var result = await dioClient
        .get('${Endpoints.listTransferInLine}?tiNum=${tiNum}');
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

    return "Total: $totalRegQuantity / $newTotalQuantity";

  }


  Future<void> _onBottomBarItemTapped(TransferInScanPageArguments? args, int index) async {
    try {
      if (index == 0) {
        if (!accessControlStore.hasTIChangeRight) throw "transferIn".tr(gender: "scan_page_no_right_change");
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "transferIn".tr(gender: "scan_page_confirm_to_change"),
            trueOptionText: "transferIn".tr(gender: "scan_page_change_confirm_option"),
            falseOptionText: "transferIn".tr(gender: "scan_page_change_cancel_option"));
        if (flag == true) {
          _changeEquipment(args).then((value) =>
              DialogHelper.showSnackBar(context, str: "transferIn".tr(gender: "scan_page_change_success")));
          // _assetRegistrationScanStore.reset();
        }
      } else if (index == 1) {
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "transferIn".tr(gender: "scan_page_confirm_to_rescan"),
            trueOptionText: "transferIn".tr(gender: "scan_page_rescan_confirm_option"),
            falseOptionText: "transferIn".tr(gender: "scan_page_rescan_cancel_option"));
        if (flag == true) {
          _rescan();
          DialogHelper.showSnackBar(context, str: "transferIn".tr(gender: "scan_page_rescan_success"));
        }
      } else if (index == 2) {
        if (!accessControlStore.hasTICompleteRight) throw "transferIn".tr(gender: "scan_page_no_right_complete");
        // String regLineStr = await fetchData(args);
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "transferIn".tr(gender: "scan_page_confirm_to_complete"),
            trueOptionText: "transferIn".tr(gender: "scan_page_complete_confirm_option"),
            falseOptionText: "transferIn".tr(gender: "scan_page_complete_cancel_option"));
        // bool flag = true;
        if (flag == true) {
          _complete(args).then((value) =>
              _showSnackBar("transferIn".tr(gender: "scan_page_complete_success")));
          // _assetRegistrationScanStore.reset();
        }
      } else if (index == 3) { // debug version
        DialogHelper.showCustomDialog(context, widgetList: [
          Text("More than one container code detected, please rescan")
        ], actionList: [
          TextButton(
            child: const Text('DContainesrs'),
            onPressed: () {
              // _addMockEquipmentIdCaseOne();
              Navigator.of(context).pop();
            },
          )
          ,
          TextButton(
            child: const Text('SContainer'),
            onPressed: () {
              // _addMockEquipmentIdCaseTwo();
              _mockscan1();
              Navigator.of(context).pop();
            },
          )
        ]);
      }
    }catch (e) {
      _transferInScanStore.errorStore.setErrorMessage(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    soundPoolUtil.initState();
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
          soundPoolUtil.playCheering();
        }

        _transferInScanStore.updateDataSet(equList: equ, itemList: item);
      }
    });
    var disposerReaction =
        reaction((_) => _transferInScanStore.errorStore.errorMessage, (_) {
      if (_transferInScanStore.errorStore.errorMessage.isNotEmpty) {
        DialogHelper.showErrorDialogBox(context, errorMsg: _transferInScanStore.errorStore.errorMessage);
        _showSnackBar(_transferInScanStore.errorStore.errorMessage);
      }
    });
     var disposerReaction1 =
        reaction((_) => _transferInScanStore.equipmentData, (_) {
          if (!accessControlStore.hasTIScanRight) throw "transferIn".tr(gender: "scan_page_complete_cancel_option");
          print("TRIGGER");
          if (_transferInScanStore.chosenEquipmentData.length > 1 &&
              !isDialogShown) {
            isDialogShown = true;
            DialogHelper.showCustomDialog(context, widgetList: [
              Text("transferIn".tr(gender: "scan_page_more_than_one_container"))
            ], actionList: [
              TextButton(
                child: Text("transferIn".tr(gender: "scan_page_rescan_confirm_option")),
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
    final TransferInScanPageArguments? args =
    ModalRoute.of(context)!.settings.arguments as TransferInScanPageArguments?;


    Widget scaffold = Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text(args != null ? args.tiNum : "EchoMe")],
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (args != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TransferInDetailPage(
                            arg: args.item!,
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
            label: "transferIn".tr(gender: "scan_page_checkIn"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.signal_cellular_alt),
            label: "transferIn.scan_page_rescan".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "transferIn".tr(gender: "scan_page_complete"),
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

    Widget keyboardListenerScaffoldWidget = RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (key) {
        // print(key);
        // // print(key.toString());
        // print(key.repeat);
        // // print(key.data);
        // print(key is RawKeyUpEvent);

        if (key is RawKeyUpEvent && !key.repeat) {
          print("keyup");
          ZebraRfd8500.stopInventory();
        }

        if (key is RawKeyDownEvent && !key.repeat) {
          print("keydown");
          ZebraRfd8500.startInventory();
        }
      },
      child: scaffold,
    );

    return keyboardListenerScaffoldWidget;
  }

  // @override
  // Widget build(BuildContext context) {
  //   final TransferInScanPageArguments? args = ModalRoute.of(context)!
  //       .settings
  //       .arguments as TransferInScanPageArguments?;
  //   return Scaffold(
  //     // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  //     // floatingActionButton: Padding(
  //     //   padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 10),
  //     //   child: Row(
  //     //     mainAxisAlignment: MainAxisAlignment.end,
  //     //     children: <Widget>[
  //     //       FloatingActionButton(
  //     //           heroTag: null,
  //     //           child: const Icon(Icons.add_box),
  //     //           onPressed: _addMockEquipmentId),
  //     //       const SizedBox(
  //     //         width: 20,
  //     //       ),
  //     //       FloatingActionButton(
  //     //         heroTag: null,
  //     //         onPressed: _addMockAssetId,
  //     //         child: const Icon(MdiIcons.cart),
  //     //       )
  //     //     ],
  //     //   ),
  //     // ),
  //     appBar: AppBar(
  //       title: Row(
  //         children: [Text(args != null ? args.tiNum : "EchoMe")],
  //       ),
  //       actions: [
  //         IconButton(
  //             onPressed: () {
  //               if (args != null) {
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (_) => TransferInDetailPage(
  //                               arg: args.item!,
  //                             )));
  //               }
  //             },
  //             icon: const Icon(MdiIcons.clipboardList)),
  //       ],
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       selectedFontSize: 12,
  //       selectedItemColor: Colors.black54,
  //       unselectedItemColor: Colors.black54,
  //       selectedIconTheme:
  //           const IconThemeData(color: Colors.black54, size: 25, opacity: .8),
  //       unselectedIconTheme:
  //           const IconThemeData(color: Colors.black54, size: 25, opacity: .8),
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.change_circle),
  //           label: 'Change Equipment',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.signal_cellular_alt),
  //           label: 'Re-Scan',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.book),
  //           label: 'Complete',
  //         ),
  //         // BottomNavigationBarItem(
  //         //   icon: Icon(Icons.eleven_mp),
  //         //   label: 'Debug',
  //         // ),
  //       ],
  //       onTap: (int index) => _onBottomBarItemTapped(args, index),
  //     ),
  //     body: SizedBox.expand(
  //       child: Column(
  //         children: [_getTitle(context, args), _getBody(context, args)],
  //       ),
  //     ),
  //   );
  // }

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
                              "transferIn".tr(gender: "scan_page_equipmnet_title"),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            _transferInScanStore.isFetchingEquData
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
                            _transferInScanStore.equipmentRfidDataSet.length
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
                      "transferIn".tr(gender: "scan_page_equipment_container_code_text") + ":",
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

  Widget _getBody(BuildContext ctx, TransferInScanPageArguments? args) {
    return Expanded(
      child: Observer(builder: (context) {
        return ListView.builder(
            itemCount: 3 + _transferInScanStore.itemRfidDataSet.length,
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
                                "transferIn".tr(gender: "scan_page_asset_title"),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Container(
                                width: 40,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: Text(_transferInScanStore
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
                if (_transferInScanStore.itemRfidDataSet.isEmpty) {
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
                              child: Text("transferIn".tr(gender: "scan_page_no_data"),
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
              var rfid =
                  _transferInScanStore.itemRfidDataSet.elementAt(index - 3);
              var isLast =
                  index - 3 == _transferInScanStore.itemRfidDataSet.length - 1
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
                    _transferInScanStore.itemRfidDataSet.remove(rfid);
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

  Widget _getTitle(BuildContext ctx, TransferInScanPageArguments? args) {
    return BodyTitle(
      title: (args?.tiNum ?? "No tiNum") + " [TI]" ,
      clipTitle: "Hong Kong-DC",
    );
  }

  void _addMockAssetId() {
    _transferInScanStore.updateDataSet(
        itemList: [AscToText.getAscIIString(Random().nextInt(50).toString())]);
  }

  void _addMockEquipmentId() {
    var init = _transferInScanStore.equipmentRfidDataSet.length;
    List<String> list = [];
    if (init == 0) {
      list.add(AscToText.getAscIIString("CATL010000000055"));
    } else if (init == 1) {
      list.add(AscToText.getAscIIString("CATL010000000066"));
    } else if (init == 2) {
      list.add(AscToText.getAscIIString("CATL010000000077"));
    } else if (init == 3) {
      list.add(AscToText.getAscIIString("CATL010000000088"));
    } else {
      list.add(AscToText.getAscIIString(new Random().nextInt(50).toString()));
    }
    _transferInScanStore.updateDataSet(equList: list);
  }

  void _mockscan1() {
    List<String> list1 = [];
    // list1.add(AscToText.getAscIIString("CATL010000000808"));
    // list1.add(AscToText.getAscIIString("CATL010000000819"));
    List<String> list2 = [];
    // list2.add(AscToText.getAscIIString("SATL010000000808"));
    // list2.add(AscToText.getAscIIString("SATL010000000819"));
    // list2.add(AscToText.getAscIIString("CATL010000000808"));
    list2.add(AscToText.getAscIIString("SATL"));
    _transferInScanStore.updateDataSet(equList: list1, itemList: list2);
  }
}
