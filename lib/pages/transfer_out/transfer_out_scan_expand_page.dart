import 'dart:async';
import 'dart:math';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/models/equipment_data/equipment_data.dart';
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_detail_page.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_scan_store.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:echo_me_mobile/stores/reader_connection/reader_connection_store.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';
import 'transfer_out_scan_page_arguments.dart';

import 'package:echo_me_mobile/utils/soundPoolUtil.dart';

import 'package:dismissible_expanded_list/dismissible_expanded_list.dart';
import 'package:echo_me_mobile/models/asset_registration/registration_order_detail.dart';
import 'package:echo_me_mobile/stores/transfer_out/transfer_out_scan_expand_store.dart';
import 'dart:io';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';


class TOScanExpandPage extends StatefulWidget {
  const TOScanExpandPage({Key? key}) : super(key: key);

  @override
  State<TOScanExpandPage> createState() => _TOScanExpandPageState();
}

class _TOScanExpandPageState extends State<TOScanExpandPage> {
  final AssetRegistrationScanStore _assetRegistrationScanStore =
  getIt<AssetRegistrationScanStore>();
  final LoginFormStore loginFormStore = getIt<LoginFormStore>();


  List<dynamic> disposer = [];
  final AssetRegistrationApi api = getIt<AssetRegistrationApi>();
  final Repository repository = getIt<Repository>();

  final SoundPoolUtil soundPoolUtil = SoundPoolUtil();

  bool isDialogShown = false;

  String toNum = "";
  bool isFetchedData = false;
  String title = 'Not Yet Selected';
  String selectedId = '1';
  bool removeTileOnDismiss = true;
  bool dataControl = false;
  final TOScanExpandStore _TOScanExpandStore = getIt<TOScanExpandStore>();

  List<ExpandableListItem> list = [];

  late List<ExpandableListItem> orderLineWidget;

  final AccessControlStore accessControlStore = getIt<AccessControlStore>();
  final ReaderConnectionStore readerConnectionStore =
  getIt<ReaderConnectionStore>();

  void _showSnackBar(String? str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str ?? ""),
      ),
    );
  }

  String _getContainerCode() {
    return _TOScanExpandStore.chosenEquipmentData.isNotEmpty
        ? (_TOScanExpandStore.chosenEquipmentData[0].containerCode ?? "")
        : "";
  }

  String _getcontainerAssetCode() {

    return _TOScanExpandStore.equipmentData[_TOScanExpandStore.activeContainer] != null
        ? (_TOScanExpandStore.equipmentData[_TOScanExpandStore.activeContainer]?.containerAssetCode ?? "")
        : "";
    // return _TOScanExpandStore.chosenEquipmentData.isNotEmpty
    //     ? (_TOScanExpandStore.chosenEquipmentData[0].containerAssetCode ?? "")
    //     : "";
  }

  Future<bool> _changeEquipment(TransferOutScanPageArguments? args) async {
    print("change equ_expand");
    try {
      if (args?.toNum == null) {
        throw "Reg Number Not Found";
      }

      // if (_getcontainerAssetCode().isEmpty) {
      //   throw "Container Code not found";
      // }

      if (_TOScanExpandStore.itemRfidDataSet.isEmpty) {
        throw "Assets List is empty";
      }

      // if (_TOScanExpandStore.chosenEquipmentData.isEmpty) {
      //   throw "No equipment detected";
      // }

      var targetcontainerAssetCode = _getcontainerAssetCode();

      List<String> rfidList = [];
      // for (var element in _TOScanExpandStore.equipmentData) {
      //   if (element.containerAssetCode == targetcontainerAssetCode) {
      //     if (element.rfid != null) {
      //       rfidList.add(element.rfid!);
      //     }
      //   }
      // }

      rfidList.add(_TOScanExpandStore.equipmentData[_TOScanExpandStore.activeContainer]?.rfid ?? "");

      try {
        await _TOScanExpandStore.checkInTOContainer(
            rfid: rfidList, toNum: args?.toNum ?? "", throwError: true);
      } catch (e, s) {
        if (!e.toString().contains("Error 2109")) {
          // _TOScanExpandStore.errorStore.setErrorMessage(e.toString());
          // rethrow;
          print(e.toString());
        }
        print(s);
        // rethrow;
      }

      // List<String> itemRfid = _TOScanExpandStore.itemRfidDataSet
      //     .map((e) => AscToText.getString(e))
      //     .toList();
      // List<String> itemRfid = _TOScanExpandStore.itemRfidDataSet.toList();

      // if already checkedin item, it will not submit to backend
      List<String> itemRfid = <String>[];
      _TOScanExpandStore.itemRfidDataSet.forEach((rfid) {
        if(_TOScanExpandStore.itemRfidStatus.containsKey(rfid)){
          String rfidStatus = _TOScanExpandStore.itemRfidStatus[rfid];
          if(rfidStatus == "Scanned"){
            itemRfid.add(rfid);
          }
        }else{
          itemRfid.add(rfid);
        }
        // if (_TOScanExpandStore.rfidCodeMapper.containsKey(rfid)){
        //   itemRfid.add(rfid);
        // }

      });

      bool directTO = false;
      if (args != null && args.toNum.startsWith('TO'))
        directTO = true;

      await _TOScanExpandStore.checkInTOItem(
          toNum: args?.toNum ?? "",
          itemRfid: itemRfid,
          containerAssetCode: targetcontainerAssetCode,
          throwError: true,
          directTO: directTO);
      _TOScanExpandStore.reset();
      fetchOrderDetailData(args!.toNum, loginFormStore.siteId!); // refresh page
      return true;
    } catch (e, s) {
      _TOScanExpandStore.errorStore.setErrorMessage(e.toString());
      print(s);
      return false;
    }
  }

  void _rescan() {
    _TOScanExpandStore.reset();
  }

  void _rescanContainer() {
    _TOScanExpandStore.resetContainer();
  }

  Future<bool> _complete(TransferOutScanPageArguments? args) async {
    try {
      _TOScanExpandStore.complete(toNum: args?.toNum ?? "");
      return true;
    } catch (e, s) {
      print(s);
      return false;
    }
  }

  Future<String> fetchData(TransferOutScanPageArguments? args) async {
    // var result = await repository.fetchArLineData(args);
    // var newTotalProduct = (result as List).length.toString();
    // int newTotalQuantity = 0;
    // int totalRegQuantity = 0;
    // (result as List).forEach((e) {
    //   try {
    //     newTotalQuantity += e["quantity"] as int;
    //     totalRegQuantity += e["checkinQty"] as int;
    //   } catch (e, s) {
    //     print(s);
    //     print(e);
    //   }
    //   ;
    // });
    //
    // return "assetRegistration".tr(gender: "bottom_bar_total") +
    //     ": $totalRegQuantity / $newTotalQuantity";
    return "";
  }

  Future<void> _onBottomBarItemTapped(
      TransferOutScanPageArguments? args, int index) async {
    try {
      if (index == 0) {
        // if (!accessControlStore.hasARChangeRight)
        //   throw "assetRegistration".tr(gender: "scan_page_no_right_change");
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title:
            "assetRegistration".tr(gender: "scan_page_confirm_to_change"),
            trueOptionText: "assetRegistration"
                .tr(gender: "scan_page_change_confirm_option"),
            falseOptionText: "assetRegistration"
                .tr(gender: "scan_page_change_cancel_option"));
        if (flag == true) {
          await _changeEquipment(args)
              ? _showSnackBar(
              "assetRegistration".tr(gender: "scan_page_change_success"))
              : "";

          // _TOScanExpandStore.reset();
        }
      } else if (index == 1) {
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title:
            "assetRegistration".tr(gender: "scan_page_confirm_to_rescan"),
            trueOptionText: "assetRegistration"
                .tr(gender: "scan_page_rescan_confirm_option"),
            falseOptionText: "assetRegistration"
                .tr(gender: "scan_page_rescan_cancel_option"));
        if (flag == true) {
          _rescan();
          fetchOrderDetailData(toNum, loginFormStore.siteId!);
          _showSnackBar(
              "assetRegistration".tr(gender: "scan_page_rescan_success"));
        }
      } else if (index == 2) {
        if (!accessControlStore.hasARCompleteRight)
          throw "assetRegistration".tr(gender: "scan_page_no_right_complete");
        String regLineStr = await fetchData(args);
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "assetRegistration"
                .tr(gender: "scan_page_confirm_to_complete") +
                "\n\n" +
                regLineStr,
            trueOptionText: "assetRegistration"
                .tr(gender: "scan_page_complete_confirm_option"),
            falseOptionText: "assetRegistration"
                .tr(gender: "scan_page_complete_cancel_option"));
        if (flag == true) {
          await _complete(args)
              ? _showSnackBar(
              "assetRegistration".tr(gender: "scan_page_complete_success"))
              : "";
          // _TOScanExpandStore.reset();
        }
      } else if (index == 3) {
        // debug version
        DialogHelper.showCustomDialog(context, widgetList: [
          Text("More than one container code detected, please rescan")
        ], actionList: [
          TextButton(
            child: const Text('aiReaderConnect'),
            onPressed: () {
              // _addMockEquipmentIdCaseOne();
              readerConnectionStore.connectAIReader();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('start'),
            onPressed: () {
              startInventory();
              readerConnectionStore.startAIInventory();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('stop'),
            onPressed: () {
              readerConnectionStore.stopAIInventory();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('SContainer'),
            onPressed: () {
              readerConnectionStore..disconnectAIReader();
              _addMockEquipmentIdCaseTwo();
              Navigator.of(context).pop();
            },
          )
        ]);
      }
    } catch (e, s) {
      _TOScanExpandStore.errorStore.setErrorMessage(e.toString());
      print(s);
    }
  }

  @override
  void initState() {
    super.initState();
    soundPoolUtil.initState();
    // fetchOrderDetailData(toNum);
    // FlutterSmartDialog.init();
    var eventSubscription = ZebraRfd8500.eventStream.listen((event) {
      print(event);
      print(event.type);
      if (event.type == ScannerEventType.readEvent) {
        List<String> item = [];
        List<String> equ = [];
        for (var hexElement in (event.data as List<String>)) {
          if (hexElement.substring(0, 2) == "63" ||
              hexElement.substring(0, 2) == "43") {

            String ascillElement = AscToText.getString(hexElement);
            equ.add(ascillElement);
          } else if (hexElement.substring(0, 2) == "53" ||
              hexElement.substring(0, 2) == "73") {
            String ascillElement = AscToText.getString(hexElement);
            item.add(ascillElement);
          }
          soundPoolUtil.playCheering();
        }
        _TOScanExpandStore.updateDataSet(equList: equ, itemList: item);
        print(equ.toString());
        print(item.toString());
        // updateWidget();
        // print("widget updated");

        print("");
      }
    });
    var disposerReaction =
    reaction((_) => _TOScanExpandStore.errorStore.errorMessage, (_) {
      if (_TOScanExpandStore.errorStore.errorMessage.isNotEmpty) {
        DialogHelper.showErrorDialogBox(context,
            errorMsg: _TOScanExpandStore.errorStore.errorMessage);
        _showSnackBar(_TOScanExpandStore.errorStore.errorMessage);
        print("dispoerReaction");
      }
    });

    var disposerUpdateUIReaction =
    reaction((_) => _TOScanExpandStore.needUpdateUI, (_) {
      print("disposerUpdateUIReaction, udpateUI Successfully, needUpdateUI: ${_TOScanExpandStore.needUpdateUI}");
      if (_TOScanExpandStore.needUpdateUI) {
        updateWidget();
        // setState(() {
        //   list = list;
        // });
        _TOScanExpandStore.needUpdateUI = false;

      }
      print("disposerUpdateUIReaction, udpateUI Successfully, needUpdateUI: ${_TOScanExpandStore.needUpdateUI}");
    });

    var disposerUpdateItemReaction =
    reaction((_) => _TOScanExpandStore.needUpdateItem, (_) async {
      print("disposerUpdateItemReaction, udpateItem Successfully, needUpdateItem: ${_TOScanExpandStore.needUpdateItem}");
      if (_TOScanExpandStore.needUpdateItem) {

        void onClickFunction(containerCode) async {
          if (_TOScanExpandStore.containerCodeRfidMapper[containerCode].isNotEmpty){
            _TOScanExpandStore.activeContainer = _TOScanExpandStore.containerCodeRfidMapper[containerCode][0];
          }else{
            print("error");
          }

        }
        Map<String,String> containerCodeRfidMap = {};
        _TOScanExpandStore.equipmentData.values.forEach((equipmentData) {
          containerCodeRfidMap[equipmentData.containerCode!] = equipmentData.rfid!;
        });

        if (_TOScanExpandStore.equipmentData.length == 1){
          String? containerCode = containerCodeRfidMap.keys.toList().first;
          _TOScanExpandStore.activeContainer = _TOScanExpandStore.containerCodeRfidMapper[containerCode][0];
        }else if (containerCodeRfidMap.keys.isNotEmpty && _TOScanExpandStore.activeContainer == ""){
          await DialogHelper.listSelectionDialogWithAutoCompleteBar(context,
              containerCodeRfidMap.keys.toList(), onClickFunction, willPop: true, text: "Select Container");
        }

        _TOScanExpandStore.validateItemRfid();
        // setState(() {
        //   list = list;
        // });
        _TOScanExpandStore.needUpdateItem = false;

      }
      print("disposerUpdateUIReaction, udpateUI Successfully, needUpdateUI: ${_TOScanExpandStore.needUpdateUI}");
    });

    var scanDisposeReaction =
    reaction((_) => _TOScanExpandStore.equipmentData, (_) {
      try {
        if (!accessControlStore.hasARScanRight)
          throw "assetRegistration".tr(gender: "scan_page_no_right_scan");
        Set<String?> containerAssetCodeSet = Set<String?>();
        // print("disposer1 called");
        _TOScanExpandStore.chosenEquipmentData.forEach(
                (element) => containerAssetCodeSet.add(element.containerAssetCode));
        // if (containerAssetCodeSet.length > 1 && !isDialogShown) {
        //   isDialogShown = true;
        //   DialogHelper.showCustomDialog(context, widgetList: [
        //     Text("assetRegistration"
        //         .tr(gender: "scan_page_more_than_one_container"))
        //   ], actionList: [
        //     TextButton(
        //       child: Text("assetRegistration"
        //           .tr(gender: "scan_page_rescan_container_option")),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //         _rescanContainer();
        //         isDialogShown = false;
        //       },
        //     ),
        //     TextButton(
        //       child: Text("assetRegistration"
        //           .tr(gender: "scan_page_rescan_confirm_option")),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //         _rescan();
        //         isDialogShown = false;
        //       },
        //     )
        //   ]);
        // }
      } catch (e, s) {
        _TOScanExpandStore.errorStore.setErrorMessage(e.toString());
        print(s);
      }
    });
    disposer.add(() => eventSubscription.cancel());
    disposer.add(disposerReaction);
    // disposer.add(scanDisposeReaction);
    disposer.add(disposerUpdateUIReaction);
    disposer.add(disposerUpdateItemReaction);
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
    toNum = args!.toNum;
    if (!isFetchedData){
      fetchOrderDetailData(toNum, loginFormStore.siteId!);
      isFetchedData = true;
    }
    var scaffold = Scaffold(
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
            label: "assetRegistration".tr(gender: "scan_page_checkIn"),
            // label: "Change Equipement",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.signal_cellular_alt),
            label: "assetRegistration.scan_page_rescan".tr(),
            // label: "assetRegistration".tr(gender: "scan_page_rescan"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "assetRegistration".tr(gender: "scan_page_complete"),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.eleven_mp),
          //   label: 'Debug',
          // ),
        ],
        onTap: (int index) => _onBottomBarItemTapped(args, index),
      ),
      body: SizedBox.expand(
        child: Column(children: [
          // _getTitle(context, args),
          _getDocumentInfo(args),
          _buildRightSide(),
          // ..._getButtonTestList()
        ]),
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

  Widget _getDocumentInfo(TransferOutScanPageArguments? args) {
    // String dataString = widget.arg.item?.createdDate != String
    //     ? widget.arg.item!.createdDate!.toString()
    //     : "";
    // print(widget.arg.item);
    return AppContentBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Observer(
                builder: ((context) => Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blueAccent)),
                    child: Center(
                        child: RichText(
                          text: TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                  "Active Container" +
                                      " : "),
                              TextSpan(
                                  text: "${(_TOScanExpandStore.rfidCodeMapper[_TOScanExpandStore.activeContainer!]) ?? _TOScanExpandStore.activeContainer! ?? ""}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple[700])),
                            ],
                          ),
                        ))))),
            const SizedBox(height: 5),
            Observer(builder: ((context) {
              var text = RichText(
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "assetRegistration.detail_page_tracker".tr() +
                            " : "),
                    TextSpan(
                        text: "${_TOScanExpandStore.totalCheckedQty}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    TextSpan(
                        text: (_TOScanExpandStore.itemRfidDataSet.length != 0)
                            ? "(+${_TOScanExpandStore.addedQty})"
                            : "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    TextSpan(
                        text: "/${_TOScanExpandStore.totalQty}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    TextSpan(text: "  |  " + "SKU Tracker: "),
                    TextSpan(
                        text:
                        "${_TOScanExpandStore.totalCheckedSKU}/${_TOScanExpandStore.itemCodeRfidMapper.length}",
                        //_TOScanExpandStore.orderLineDTOMap["Not Yet Scan"].orderLineItemsMap.length
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent)),
                    TextSpan(
                        text: "", style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              );

              return text;
            })),
            const SizedBox(height: 5),
            Observer(builder: ((context) {
              var text = RichText(
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: "Container Qty".tr() + " : "),
                    TextSpan(
                        text: "${_TOScanExpandStore.totalContainer}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                    TextSpan(text: "  |  " + "Out of List Item(s): "),
                    TextSpan(
                        text: "${_TOScanExpandStore.outOfListQty}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              );

              return text;
            })),
            // Observer(
            //     builder: ((context) => Text("Container Qty".tr() +
            //         " : " +
            //         "${_TOScanExpandStore.totalContainer}" + "  |  " + "Out of List Item(s): " + "${_TOScanExpandStore.outOfListQty}"))),
            // Text( "  |  " + "Out of List Item(s): "),
            // Observer(
            //     builder: ((context) => Text(
            //         ))),
            const SizedBox(height: 5),
            Observer(builder: ((context) {
              int createdTimeStamp = args?.item?.createdDate?? 0;
              String datetimeStr = DateTime.fromMillisecondsSinceEpoch(createdTimeStamp).toString();
              datetimeStr = datetimeStr.substring(0, datetimeStr.length -4);
              var text = RichText(
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: "Order Status".tr() + " : "),
                    TextSpan(
                        text: "${args?.item?.status}",
                        style: TextStyle(
                            color: Colors.black)),
                    TextSpan(text: "\n" + "Order Date: "),
                    TextSpan(
                        text: "${datetimeStr}",
                        style: TextStyle(
                            color: Colors.black)),
                  ],
                ),
              );

              return text;
            })),
          ],
        ),
      ),
    );
  }

  Widget _getBaseOrderInfo() {
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
                              "assetRegistration"
                                  .tr(gender: "scan_page_equipmnet_title"),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            _TOScanExpandStore.isFetchingEquData
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
                            _TOScanExpandStore.equipmentRfidDataSet.length
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
                      "assetRegistration".tr(
                          gender:
                          "scan_page_equipment_container_code_text") +
                          ":",
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
                              "assetRegistration"
                                  .tr(gender: "scan_page_equipmnet_title"),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            _TOScanExpandStore.isFetchingEquData
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
                            _TOScanExpandStore.equipmentRfidDataSet.length
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
                      "assetRegistration".tr(
                          gender:
                          "scan_page_equipment_container_code_text") +
                          ":",
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
            itemCount: 3 + _TOScanExpandStore.itemRfidDataSet.length,
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
                                "assetRegistration"
                                    .tr(gender: "scan_page_asset_title"),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Container(
                                width: 40,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: Text(_TOScanExpandStore
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
                if (_TOScanExpandStore.itemRfidDataSet.isEmpty) {
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
                              child: Text(
                                  "assetRegistration"
                                      .tr(gender: "scan_page_no_data"),
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
              _TOScanExpandStore.itemRfidDataSet.elementAt(index - 3);
              var isLast =
              index - 3 == _TOScanExpandStore.itemRfidDataSet.length - 1
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
                    _TOScanExpandStore.itemRfidDataSet.remove(rfid);
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
      title: (args?.toNum ?? "No toNum") + " [Reg]",
      clipTitle: "Hong Kong-DC",
    );
  }

  void _addMockAssetId() {
    _TOScanExpandStore.updateDataSet(
        itemList: [AscToText.getAscIIString(Random().nextInt(50).toString())]);
  }

  void _addMockEquipmentId() {
    // var init = _TOScanExpandStore.equipmentRfidDataSet.length;
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
    _TOScanExpandStore.updateDataSet(equList: list);
  }

  void _addMockEquipmentIdCaseOne() {
    List<String> list = [];
    list.add(AscToText.getAscIIString("CATL010000001382"));
    list.add(AscToText.getAscIIString("CATL010000000842"));
    _TOScanExpandStore.updateDataSet(equList: list);
  }

  void _addMockEquipmentIdCaseTwo() {
    List<String> list = [];
    list.add(AscToText.getAscIIString("SATL010000000808"));
    list.add(AscToText.getAscIIString("CATL010000000819"));
    _TOScanExpandStore.updateDataSet(equList: list);
  }

  Future<void> _debug() async {
    List<String> list = [];
    List<String> resultList = await ZebraRfd8500.debug();
    resultList.forEach((element) {
      list.add(element);
    });
    // list.add(AscToText.getAscIIString("CATL010000000808"));
    // list.add(AscToText.getAscIIString("CATL010000000819"));
    _TOScanExpandStore.updateDataSet(equList: list);
  }

  Future<void> connectAIReader() async {
    List<String> resultList = await ZebraRfd8500.connectAIReader();
  }

  Future<void> startInventory() async {
    List<String> resultList = await ZebraRfd8500.startInventory();
  }

  Future<void> stopInventory() async {
    List<String> resultList = await ZebraRfd8500.stopInventory();
  }

  Future<void> disconnectAIReader() async {
    List<String> resultList = await ZebraRfd8500.disconnectAIReader();
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
    _TOScanExpandStore.updateDataSet(equList: list1, itemList: list2);
  }

  List<Widget> _getButtonTestList() {
    List<Widget> output = [
      TextButton(
          onPressed: () async {
            // var result = await repository.getAssetRegistrationOrderDetail(toNum: "GDC0980203", site: 2);
            var result2 =
            await _TOScanExpandStore.fetchOrderDetail("Mixson_AR3", loginFormStore.siteId!);
          },
          child: Text("Fetch Data")),
      // TextButton(
      //     onPressed: () async {
      //       _TOScanExpandStore.loadOrderLineJson();
      //       // orderLineWidget = await orderLine.turnOrderLineIntoWidget();
      //       // orderLineWidget = await turnOrderLineIntoWidget();
      //       print("mockData3");
      //       // addScannedRFID("W100001", ["SATL1000032", "SATL1000033", "SATL1000035"]);
      //     },
      //     child: Text("load Data")),
      TextButton(
          onPressed: () async {
            // orderLine.loadOrderLineJson();
            // orderLineWidget = await orderLine.turnOrderLineIntoWidget();
            // orderLineWidget = await orderLine.turnOrderLineMapIntoWidget();
            orderLineWidget =
            await _TOScanExpandStore.turnOrderLineDtoMapIntoWidget();

            setState(() {
              list = orderLineWidget;
            });
            // orderLineWidget = await turnOrderLineIntoWidget();
            print("update Widget");
            // orderLine.addScannedRFID("W100001", ["SATL1000032", "SATL1000033", "SATL1000035"]);
          },
          child: Text("updated widget")),
      // TextButton(
      //     onPressed: () async {
      //       // orderLine.loadOrderLineJson();
      //       // orderLineWidget = await orderLine.turnOrderLineIntoWidget();
      //       // orderLineWidget = await turnOrderLineIntoWidget();
      //       print("add number");
      //       _TOScanExpandStore.addScannedRFID("W000114", [
      //         "SATL010000048945",
      //         "SATL010000049160",
      //         "SATL010000049025",
      //         "ABC"
      //       ]);
      //     },
      //     child: Text("addScannedRFID")),
      // TextButton(
      //     onPressed: () async {
      //       // orderLine.loadOrderLineJson();
      //       // orderLineWidget = await orderLine.turnOrderLineIntoWidget();
      //       // orderLineWidget = await turnOrderLineIntoWidget();
      //       print("create Container");
      //       _TOScanExpandStore.createContainer(
      //           "QQQQ11111", "W100003", "CATL30000001");
      //     },
      //     child: Text("create Container")),
      TextButton(
          onPressed: () async {
            // orderLine.loadOrderLineJson();
            // orderLineWidget = await orderLine.turnOrderLineIntoWidget();
            // orderLineWidget = await turnOrderLineIntoWidget();
            print("add Item into Container");
            // List<String> equList = ["CATL010000069779"];
            // "CATL010000075080"
            List<String> equList = [ "CATL010000075091",  ];
            List<String> itemList = ["SATL010000068431", "SATL010000068464"];
            // itemList = ["SATL010000068363","SATL010000068374","SATL010000068408","SATL010000068419","SATL010000068442",
            //   "SATL010000068453","SATL010000068486","SATL010000068497","SATL010000068521","SATL010000068532",
            //   ];
            _TOScanExpandStore.updateDataSet(
                equList: equList, itemList: itemList);
          },
          child: Text("updateDataSet")),
      TextButton(
          onPressed: ()  {
            _TOScanExpandStore.errorStore.setErrorMessage("Test");

          },
          child: Text("set error")),
      TextButton(
          onPressed: ()  {
            showDialog(
              context: context,
              builder: (context) {
                String contentText = "Content of Dialog";
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text("Title of Dialog"),
                      content: Text(contentText),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              contentText = "Changed Content of Dialog";
                            });
                          },
                          child: Text("Change"),
                        ),
                      ],
                    );
                  },
                );
              },
            );

          },
          child: Text("show dialog"))
    ];
    return output;
  }

  Widget _buildRightSide() {
    /// Configuration example
    DismissibleListConfig config = DismissibleListConfig()
      ..badgeWidth = 100.0
      ..listElevation = 3.0
      ..infoBadgeElevation = 0.0
      ..infoIconSize = 15.0
      ..removeTileOnDismiss = true
      ..allowBatchSwipe = true
      ..allowChildSwipe = true
      ..allowParentSelection = true
      ..showBorder = false
      ..showInfoBadge = true
      ..titleStyle = titleStyle
      ..titleSelectedStyle = titleSelectedStyle
      ..subTitleStyle = subTitleStyle
      ..subTitleSelectedStyle = subTitleSelectedStyle
      ..trailingIcon = Icons.info_outline
      ..lineColor = Colors.grey[400]
      ..selectionColor = Color(0xFFcee9f0)
      ..rightSwipeColor = Colors.green
      ..leftSwipeColor = Colors.red
      ..iconColor = Colors.black87
      ..iconSelectedColor = Colors.green
      ..backgroundColor = Colors.white;

    return Expanded(
      flex: 1,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            DismissibleExpandableList(
              parentIndex: index,
              entry: list[index],
              config: config,
              onItemClick: (parentIndex, childIndex, ExpandableListItem item) {
                print('onItemClick called');
                onItemClick(parentIndex, childIndex);
              },
              onItemDismissed:
                  (parentIndex, childIndex, direction, removeTileOnDismiss, item) {
                if (direction == DismissDirection.endToStart) {
                  print("endToStart");
                  onItemDismissed(parentIndex, childIndex, removeTileOnDismiss);
                } else {
                  print("startToEnd");
                  onItemDismissed(parentIndex, childIndex, removeTileOnDismiss);
                }
              },
            ),
        itemCount: list.length,
      ),
    );
  }

  void onItemClick(int parentIndex, int childIndex) {
    setState(
          () {
        if (childIndex == -1) {
          title = list[parentIndex].title;
          selectedId = list[parentIndex].id;

          // setting entry to true
          list.forEach((item) => item.reset());
          list[parentIndex].selected = true;
        } else {
          selectedId = list[parentIndex].children[childIndex].id;
          title = list[parentIndex].children[childIndex].title;

          // setting entry to true
          list.forEach((item) => item.reset());
          list[parentIndex].selected = true;
          list[parentIndex].children[childIndex].selected = true;
          String containerCode = list[parentIndex].title;

          String itemCode = list[parentIndex].children[childIndex].id;
          String itemTitle = list[parentIndex].children[childIndex].title;
          String itemSubTitle = list[parentIndex].children[childIndex].subTitle;
          String containerCodeStr = list[parentIndex].title;
          // List<String>? rfidList = (_TOScanExpandStore.itemCodeRfidMapper[itemCode] as List).map((item) => item as String).toList();
          List<String> rfidList = <String>[];

          if(_TOScanExpandStore.containerCodeRfidMapper.containsKey(containerCode)){
            List<String> containerRFIDList =
            _TOScanExpandStore.containerCodeRfidMapper[containerCode];
            containerRFIDList.forEach((containerRFID) => rfidList.addAll(
                _TOScanExpandStore.orderLineDTOMap[containerRFID]
                    .orderLineItemsMap[itemCode].rfid));
            ;

          }else{
            // Out of List
            rfidList.add(itemCode);
          }

          List<String>? rfidListInput =
          (rfidList as List).map((item) => item as String).toList();

          _TOScanExpandStore.dialogDisplayRFIDList = ObservableList.of(rfidListInput);
          showStackDialog(
              containerCodeStr: containerCodeStr,
              rfidList: rfidListInput,
              justScannedRfidList: _TOScanExpandStore.itemRfidDataSet.toList(),
              // title: itemTitle,
              title: _TOScanExpandStore.toNum!,
              subtitle: itemSubTitle,
              height: 350,
              width: 400,
              alignment: Alignment.topCenter,
              itemCode: itemCode);
          // DialogHelper.showStackDialog(tag: "abc",
          //         rfidList: ["SATL1000032","SATL1000032","SATL1000032","SATL1000032","SATL1000032"],
          //         height: 400,
          //         alignment: Alignment.topCenter);

        }
      },
    );
  }

  void onItemDismissed(
      int parentIndex, int childIndex, bool removeTileOnDismiss) {
    setState(
          () {
        // check to see if user wants to remove swiped items from list
        // if yes then remove item from list
        // else show user a message about swiped item
        if (removeTileOnDismiss) {
          if (childIndex == -1) {
            // remove Container
            ExpandableListItem orderLineContainerMap = list[parentIndex];
            String? containerRfid = orderLineContainerMap.id;
            removeContainer(containerRfid);
            // list[parentIndex]
            list.removeAt(parentIndex);
          } else {
            // check to see if its the last child
            // if yes, then remove parent as well
            // else, only remove child

            // remove item
            if (list[parentIndex].children != null &&
                list[parentIndex].children.length > 1) {

              ExpandableListItem orderLineContainerMap = list[parentIndex];
              String? containerRfid = orderLineContainerMap.id;
              ExpandableListItem itemInfo = list[parentIndex].children[childIndex];
              String itemCode = itemInfo.id;
              removeContainerItem(containerRfid, itemCode);

              list[parentIndex].children.removeAt(childIndex);
            } else {
              ExpandableListItem orderLineContainerMap = list[parentIndex];
              String? containerRfid = orderLineContainerMap.id;
              ExpandableListItem itemInfo = list[parentIndex].children[childIndex];
              String itemCode = itemInfo.id;
              // removeContainerItem(containerRfid, itemCode);

              removeContainer(containerRfid);
              list.removeAt(parentIndex);
            }
          }
        } else {
          // show user a message that item has been swiped
          print("removeTileOnDismiss is false");
        }
      },
    );

  }

  Widget _getRFIDBoxList(List<String> rfidList, List<String> justScannedRfidList, String containerCodeStr, var setState) {
    String containerRfid = "";
    if (_TOScanExpandStore.containerCodeRfidMapper.containsKey(containerCodeStr)){
      if (_TOScanExpandStore.containerCodeRfidMapper[containerCodeStr].isNotEmpty){
        containerRfid = _TOScanExpandStore.containerCodeRfidMapper[containerCodeStr][0];
      }
    }
    return AppContentBox(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Builder(
            builder: (context) => ListView.builder(
                itemCount: _TOScanExpandStore.dialogDisplayRFIDList.length,
                itemBuilder: ((context, index) {
                  final rfid = _TOScanExpandStore.dialogDisplayRFIDList[index];
                  return Builder(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                            rfid,
                                            style: (justScannedRfidList.contains(rfid)) ?
                                            TextStyle(color: Colors.green[500]) : Theme.of(context).textTheme.bodyMedium ,
                                          )),
                                      SizedBox(
                                          height: 18.0,
                                          width: 18.0,
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0.0),
                                            icon: new Icon(Icons.clear, size: 18.0),
                                            onPressed: () {
                                              _TOScanExpandStore.removeContainerItemRfid(containerRfid, rfid).then((value) {
                                                setState(() {
                                                  print("remove ${_TOScanExpandStore.dialogDisplayRFIDList}");
                                                  _TOScanExpandStore.dialogDisplayRFIDList.removeWhere((element) => element == rfid);
                                                  _TOScanExpandStore.needUpdateUI = true;
                                                });

                                                print("remove rfid is clicked");
                                              } );
                                            },
                                          )
                                      ),

                                    ])
                              ],
                            ),
                          )),
                    );
                  });
                }))),
      ),
    );
  }

  Widget _getRFIDBoxList2(List<String> justScannedRfidList, String containerCodeStr, String itemCode) {
    String containerRfid = "";
    if (_TOScanExpandStore.containerCodeRfidMapper.containsKey(containerCodeStr)){
      if (_TOScanExpandStore.containerCodeRfidMapper[containerCodeStr].isNotEmpty){
        containerRfid = _TOScanExpandStore.containerCodeRfidMapper[containerCodeStr][0];
      }
    }
    String containerRFID = _TOScanExpandStore.containerCodeRfidMapper[containerCodeStr][0];
    // String containerRFID = containerCodeStr;

    return AppContentBox(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Builder(
            builder: (context) => ListView.builder(
                itemCount:  _TOScanExpandStore.orderLineDTOMap[containerRFID]
                    .orderLineItemsMap[itemCode].rfid.length,
                itemBuilder: ((context, index) {
                  final rfid = _TOScanExpandStore.orderLineDTOMap[containerRFID]
                      .orderLineItemsMap[itemCode].rfid[index];
                  return Builder(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                            rfid,
                                            style: (justScannedRfidList.contains(rfid)) ?
                                            TextStyle(color: Colors.green[500]) : Theme.of(context).textTheme.bodyMedium ,
                                          )),
                                      SizedBox(
                                          height: 18.0,
                                          width: 18.0,
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0.0),
                                            icon: new Icon(Icons.clear, size: 18.0),
                                            onPressed: () {
                                              setState(() {
                                                _TOScanExpandStore.removeContainerItemRfid(containerRfid, rfid).then((value) {
                                                  _TOScanExpandStore.needUpdateUI = true;
                                                  print("remove rfid is clicked");
                                                } );
                                                // _TOScanExpandStore.orderLineDTOMap =_TOScanExpandStore.orderLineDTOMap;
                                              });

                                            },
                                          )
                                      ),

                                    ])
                              ],
                            ),
                          )),
                    );
                  });
                }))),
      ),
    );
  }

  void showStackDialog(
      {required AlignmentGeometry alignment,
        required String containerCodeStr,
        required List<String> rfidList,
        List<String> justScannedRfidList = const [],
        double width = double.infinity,
        double height = double.infinity,
        String title = "",
        String subtitle = "",
        String itemCode = ""}) async {
    rfidList.sort();

    Widget addSetState(){

      return StatefulBuilder(
          builder: (context, setState) {
            var container = Container(
              width: width,
              height: height,
              color: Colors.white12,
              alignment: Alignment.center,
              child: _getRFIDBoxList(rfidList, justScannedRfidList, containerCodeStr, setState),
              // child: _getRFIDBoxList2(justScannedRfidList, containerCodeStr, itemCode),
            );

            var row = Column(
              children: [
                Text(""),
                _getBaseRFIDInfo(
                    containerCodeStr, title, subtitle, rfidList.length),
                container
              ],
            );
            return row;
          });
    }

    SmartDialog.show(
        tag: "",
        alignment: alignment,
        builder: (_) {
          return addSetState();
        });

    // SmartDialog.show(
    //     tag: "",
    //     alignment: alignment,
    //     builder: (_) {
    //       var container = Container(
    //         width: width,
    //         height: height,
    //         color: Colors.white12,
    //         alignment: Alignment.center,
    //         child: _getRFIDBoxList(rfidList, justScannedRfidList, containerCodeStr),
    //       );
    //
    //       var row = Column(
    //         children: [
    //           Text(""),
    //           Observer(builder: (context){
    //             return Text(_TOScanExpandStore.toNum!);
    //           }),
    //           TextButton(onPressed: (){
    //             setState(() {
    //               print(title);
    //               _TOScanExpandStore.toNum = "hiiii";
    //               print(_TOScanExpandStore.toNum);
    //             });
    //           }, child: Text(_TOScanExpandStore.toNum!)),
    //           _getBaseRFIDInfo(
    //               containerCodeStr, title, subtitle, rfidList.length),
    //           container
    //         ],
    //       );
    //
    //
    //       return Observer(
    //           builder: (context) {
    //             return row;
    //           });
    //       // return _getRFIDBoxList(rfidList);
    //     });
  }

  Widget _getBaseRFIDInfo(String containerCodeStr, String title,
      String subtitle, int rfidListLength) {
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
                              "Item Information",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const SizedBox()
                            // _TOScanExpandStore.isFetchingEquData
                            //     ? const SpinKitDualRing(
                            //         color: Colors.blue,
                            //         size: 15,
                            //         lineWidth: 2,
                            //       )
                            //     : const SizedBox()
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
                          child: Text(rfidListLength.toString()),
                        ),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "assetRegistration".tr(
                          gender:
                          "scan_page_equipment_container_code_text") +
                          ":",
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
                            child: Text(containerCodeStr),
                          ),
                        )),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name" + ":",
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
                            // child: Text(_TOScanExpandStore.toNum!),
                            child: Text(title),
                          ),
                        )),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Code" + ":",
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
                            child: Text(subtitle),
                          ),
                        )),
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateWidget() async {
    orderLineWidget = await _TOScanExpandStore.turnOrderLineDtoMapIntoWidget();

    setState(() {
      list = orderLineWidget;
    });
  }

  void fetchOrderDetailData(String toNum, int site) {
    _TOScanExpandStore
        .fetchOrderDetail(toNum, site)
        .then((value) => updateWidget());
  }

  void removeContainerItemRfid(String containerRfid, String rfid){
    _TOScanExpandStore.removeContainerItemRfid(containerRfid, rfid);
  }

  void removeContainerItem(String containerRfid, String itemCode){
    _TOScanExpandStore.removeContainerItem(containerRfid, itemCode);
  }

  void removeContainer(String containerRfid){
    _TOScanExpandStore.removeContainer(containerRfid);
  }
}
