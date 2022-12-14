import 'dart:async';
import 'dart:math';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/models/equipment_data/equipment_data.dart';
import 'package:echo_me_mobile/pages/asset_registration/assset_scan_detail_page.dart';
import 'package:echo_me_mobile/pages/asset_return/assset_return_scan_detail_page.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_scan_store.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:echo_me_mobile/stores/asset_return/asset_return_scan_expand_store.dart';
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
import 'asset_return_scan_page_arguments.dart';

import 'package:echo_me_mobile/utils/soundPoolUtil.dart';
// import 'package:echo_me_mobile/utils/observer_util.dart';

import 'package:dismissible_expanded_list/dismissible_expanded_list.dart';
import 'package:echo_me_mobile/models/asset_registration/registration_order_detail.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_scan_expand_store.dart';
import 'dart:io';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';


class AssetReturnScanExpandPage extends StatefulWidget {
  const AssetReturnScanExpandPage({Key? key}) : super(key: key);

  @override
  State<AssetReturnScanExpandPage> createState() => _AssetReturnScanExpandPageState();
}

class _AssetReturnScanExpandPageState extends State<AssetReturnScanExpandPage> {
  final AssetRegistrationScanStore _assetRegistrationScanStore =
  getIt<AssetRegistrationScanStore>();
  final LoginFormStore loginFormStore = getIt<LoginFormStore>();


  List<dynamic> disposer = [];
  final AssetRegistrationApi api = getIt<AssetRegistrationApi>();
  final Repository repository = getIt<Repository>();

  final SoundPoolUtil soundPoolUtil = SoundPoolUtil();

  bool isDialogShown = false;

  String rtnNum = "";
  bool isFetchedData = false;
  String title = 'Not Yet Selected';
  String selectedId = '1';
  bool removeTileOnDismiss = true;
  bool dataControl = false;
  final AssetReturnScanExpandStore _assetReturnScanExpandStore = getIt<AssetReturnScanExpandStore>();

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
    return _assetReturnScanExpandStore.chosenEquipmentData.isNotEmpty
        ? (_assetReturnScanExpandStore.chosenEquipmentData[0].containerCode ?? "")
        : "";
  }

  String _getcontainerAssetCode() {
    // return _assetReturnScanExpandStore.equipmentData[_assetReturnScanExpandStore.activeContainer].containerAssetCode ?? "";

    return _assetReturnScanExpandStore.equipmentData[_assetReturnScanExpandStore.activeContainer] != null
        ? (_assetReturnScanExpandStore.equipmentData[_assetReturnScanExpandStore.activeContainer]?.containerAssetCode ?? "")
        : "";

    // return _assetReturnScanExpandStore.chosenEquipmentData.isNotEmpty
    //     ? (_assetReturnScanExpandStore.chosenEquipmentData[0].containerAssetCode ?? "")
    //     : "";
  }

  Future<bool> _changeEquipment(AssetReturnScanPageArguments? args) async {
    print("change equ_expand");
    try {
      if (args?.rtnNum == null) {
        throw "Reg Number Not Found";
      }

      if (_getcontainerAssetCode().isEmpty) {
        throw "Container Code not found";
      }

      if (_assetReturnScanExpandStore.itemRfidDataSet.isEmpty) {
        throw "Assets List is empty";
      }

      // if (_assetReturnScanExpandStore.chosenEquipmentData.isEmpty) {
      //   throw "No equipment detected";
      // }

      var targetcontainerAssetCode = _getcontainerAssetCode();

      List<String> rfidList = [];

      // for (var element in _assetReturnScanExpandStore.equipmentData.keys) {
      //   if (element.containerAssetCode == targetcontainerAssetCode) {
      //     if (element.rfid != null) {
      //       rfidList.add(element.rfid!);
      //     }
      //   }
      // }

      // _assetReturnScanExpandStore.equipmentData.forEach((containerRFID, containerData) {
      //   var element = containerData;
      //   if (element.containerAssetCode == targetcontainerAssetCode) {
      //     if (element.rfid != null) {
      //       rfidList.add(element.rfid!);
      //     }
      //   }
      // });

      rfidList.add(_assetReturnScanExpandStore.equipmentData[_assetReturnScanExpandStore.activeContainer]?.rfid ?? "");

      try {
        await _assetReturnScanExpandStore.registerContainer(
            rfid: rfidList, rtnNum: args?.rtnNum ?? "", throwError: true);
      } catch (e, s) {
        if (!e.toString().contains("Error 2109")) {
          // _assetReturnScanExpandStore.errorStore.setErrorMessage(e.toString());
          // rethrow;
          print(e.toString());
        }
        print(s);
        // rethrow;
      }

      // List<String> itemRfid = _assetReturnScanExpandStore.itemRfidDataSet
      //     .map((e) => AscToText.getString(e))
      //     .toList();
      // List<String> itemRfid = _assetReturnScanExpandStore.itemRfidDataSet.toList();

      // if already checkedin item, it will not submit to backend
      List<String> itemRfid = <String>[];
      _assetReturnScanExpandStore.itemRfidDataSet.forEach((rfid) {
        if(_assetReturnScanExpandStore.itemRfidStatus.containsKey(rfid)){
          String rfidStatus = _assetReturnScanExpandStore.itemRfidStatus[rfid];
          if(rfidStatus == "Scanned"){
            itemRfid.add(rfid);
          }
        }else{
          itemRfid.add(rfid);
        }
        // if (_assetReturnScanExpandStore.rfidCodeMapper.containsKey(rfid)){
        //   itemRfid.add(rfid);
        // }

      });

      await _assetReturnScanExpandStore.registerItem(
          rtnNum: args?.rtnNum ?? "",
          itemRfid: itemRfid,
          containerAssetCode: targetcontainerAssetCode,
          throwError: true);
      _assetReturnScanExpandStore.reset();
      fetchOrderDetailData(args!.rtnNum, loginFormStore.siteId!); // refresh page
      return true;
    } catch (e, s) {
      _assetReturnScanExpandStore.errorStore.setErrorMessage(e.toString());
      print(s);
      return false;
    }
  }

  void _rescan() {
    _assetReturnScanExpandStore.reset();
  }

  void _rescanContainer() {
    _assetReturnScanExpandStore.resetContainer();
  }

  Future<bool> _complete(AssetReturnScanPageArguments? args) async {
    try {
      _assetReturnScanExpandStore.complete(rtnNum: args?.rtnNum ?? "");
      return true;
    } catch (e, s) {
      print(s);
      return false;
    }
  }

  Future<String> fetchData(AssetReturnScanPageArguments? args) async {
    var result = await repository.fetchAssetRetrunLineData(args);
    var newTotalProduct = (result as List).length.toString();
    int newTotalQuantity = 0;
    int totalRegQuantity = 0;
    (result as List).forEach((e) {
      try {
        newTotalQuantity += e["quantity"] as int;
        totalRegQuantity += e["checkinQty"] as int;
      } catch (e, s) {
        print(s);
        print(e);
      }
      ;
    });

    return "assetRegistration".tr(gender: "bottom_bar_total") +
        ": $totalRegQuantity / $newTotalQuantity";
  }

  Future<void> _onBottomBarItemTapped(
      AssetReturnScanPageArguments? args, int index) async {
    try {
      if (index == 0) {
        // if (!accessControlStore.hasARChangeRight)
        //   throw "assetRegistration".tr(gender: "scan_page_no_right_change");

        String boxStr = "";
        boxStr += "Active Container: ${(_assetReturnScanExpandStore.rfidCodeMapper[_assetReturnScanExpandStore.activeContainer!]) ?? _assetReturnScanExpandStore.activeContainer! ?? ""}";
        boxStr += "\n";
        boxStr += "Item(s): ${_assetReturnScanExpandStore.itemRfidDataSet.length}";
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            // title:
            //     "assetRegistration".tr(gender: "scan_page_confirm_to_change"),
            title: boxStr,
            trueOptionText: "assetRegistration"
                .tr(gender: "scan_page_change_confirm_option"),
            falseOptionText: "assetRegistration"
                .tr(gender: "scan_page_change_cancel_option"));
        if (flag == true) {
          await _changeEquipment(args)
              ? _showSnackBar(
              "assetRegistration".tr(gender: "scan_page_change_success"))
              : "";

          // _assetReturnScanExpandStore.reset();
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
          fetchOrderDetailData(rtnNum, loginFormStore.siteId!);
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
          // _assetReturnScanExpandStore.reset();
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
      _assetReturnScanExpandStore.errorStore.setErrorMessage(e.toString());
      print(s);
    }
  }

  @override
  void initState() {
    super.initState();
    soundPoolUtil.initState();
    // fetchOrderDetailData(rtnNum);
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
        _assetReturnScanExpandStore.updateDataSet(equList: equ, itemList: item);
        print(equ.toString());
        print(item.toString());
        // updateWidget();
        // print("widget updated");

        print("");
      }
    });
    var disposerReaction =
    reaction((_) => _assetReturnScanExpandStore.errorStore.errorMessage, (_) {
      if (_assetReturnScanExpandStore.errorStore.errorMessage.isNotEmpty) {
        DialogHelper.showErrorDialogBox(context,
            errorMsg: _assetReturnScanExpandStore.errorStore.errorMessage);
        _showSnackBar(_assetReturnScanExpandStore.errorStore.errorMessage);
        print("dispoerReaction");
      }
    });

    var disposerUpdateUIReaction =
    reaction((_) => _assetReturnScanExpandStore.needUpdateUI, (_) {
      print("disposerUpdateUIReaction, udpateUI Successfully, needUpdateUI: ${_assetReturnScanExpandStore.needUpdateUI}");
      if (_assetReturnScanExpandStore.needUpdateUI) {
        updateWidget();
        // setState(() {
        //   list = list;
        // });
        _assetReturnScanExpandStore.needUpdateUI = false;

      }
      print("disposerUpdateUIReaction, udpateUI Successfully, needUpdateUI: ${_assetReturnScanExpandStore.needUpdateUI}");
    });

    var disposerUpdateItemReaction =
    reaction((_) => _assetReturnScanExpandStore.needUpdateItem, (_) async {
      print("disposerUpdateItemReaction, udpateItem Successfully, needUpdateItem: ${_assetReturnScanExpandStore.needUpdateItem}");
      if (_assetReturnScanExpandStore.needUpdateItem) {

        void onClickFunction(containerCode) async {
          if (_assetReturnScanExpandStore.containerCodeRfidMapper[containerCode].isNotEmpty){
            _assetReturnScanExpandStore.activeContainer = _assetReturnScanExpandStore.containerCodeRfidMapper[containerCode][0];
          }else{
            print("error");
          }

        }
        Map<String,String> containerCodeRfidMap = {};
        _assetReturnScanExpandStore.equipmentData.values.forEach((equipmentData) {
          containerCodeRfidMap[equipmentData.containerCode!] = equipmentData.rfid!;
        });

        if (_assetReturnScanExpandStore.equipmentData.length == 1){
          String? containerCode = containerCodeRfidMap.keys.toList().first;
          _assetReturnScanExpandStore.activeContainer = _assetReturnScanExpandStore.containerCodeRfidMapper[containerCode][0];
        }else if (containerCodeRfidMap.keys.isNotEmpty && _assetReturnScanExpandStore.activeContainer == ""){
          await DialogHelper.listSelectionDialogWithAutoCompleteBar(context,
              containerCodeRfidMap.keys.toList(), onClickFunction, willPop: true, text: "Select Container");
        }
        //key
        _assetReturnScanExpandStore.validateItemRfid();
        // setState(() {
        //   list = list;
        // });
        _assetReturnScanExpandStore.needUpdateItem = false;

      }
      print("disposerUpdateUIReaction, udpateUI Successfully, needUpdateUI: ${_assetReturnScanExpandStore.needUpdateUI}");
    });

    var scanDisposeReaction =
    reaction((_) => _assetReturnScanExpandStore.equipmentData, (_) {
      try {
        if (!accessControlStore.hasARScanRight)
          throw "assetRegistration".tr(gender: "scan_page_no_right_scan");
        Set<String?> containerAssetCodeSet = Set<String?>();
        // print("disposer1 called");
        _assetReturnScanExpandStore.chosenEquipmentData.forEach(
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
        _assetReturnScanExpandStore.errorStore.setErrorMessage(e.toString());
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
    final AssetReturnScanPageArguments? args =
    ModalRoute.of(context)!.settings.arguments as AssetReturnScanPageArguments?;
    rtnNum = args!.rtnNum;
    if (!isFetchedData){
      fetchOrderDetailData(rtnNum, loginFormStore.siteId!);
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

  Widget _getDocumentInfo(AssetReturnScanPageArguments? args) {
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
                                  text: "${(_assetReturnScanExpandStore.rfidCodeMapper[_assetReturnScanExpandStore.activeContainer!]) ?? _assetReturnScanExpandStore.activeContainer! ?? ""}",
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
                        text: "${_assetReturnScanExpandStore.totalCheckedQty}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    TextSpan(
                        text: (_assetReturnScanExpandStore.itemRfidDataSet.length != 0)
                            ? "(+${_assetReturnScanExpandStore.addedQty})"
                            : "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    TextSpan(
                        text: "/${_assetReturnScanExpandStore.totalQty}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    TextSpan(text: "  |  " + "SKU Tracker: "),
                    TextSpan(
                        text:
                        "${_assetReturnScanExpandStore.totalCheckedSKU}/${_assetReturnScanExpandStore.itemCodeRfidMapper.length}",
                        //_assetReturnScanExpandStore.orderLineDTOMap["Not Yet Scan"].orderLineItemsMap.length
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
                        text: "${_assetReturnScanExpandStore.totalContainer}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                    TextSpan(text: "  |  " + "Out of List Item(s): "),
                    TextSpan(
                        text: "${_assetReturnScanExpandStore.outOfListQty}",
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
            //         "${_assetReturnScanExpandStore.totalContainer}" + "  |  " + "Out of List Item(s): " + "${_assetReturnScanExpandStore.outOfListQty}"))),
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
                            _assetReturnScanExpandStore.isFetchingEquData
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
                            _assetReturnScanExpandStore.equipmentRfidDataSet.length
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
                            _assetReturnScanExpandStore.isFetchingEquData
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
                            _assetReturnScanExpandStore.equipmentRfidDataSet.length
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

  Widget _getBody(BuildContext ctx, AssetReturnScanPageArguments? args) {
    return Expanded(
      child: Observer(builder: (context) {
        return ListView.builder(
            itemCount: 3 + _assetReturnScanExpandStore.itemRfidDataSet.length,
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
                                    child: Text(_assetReturnScanExpandStore
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
                if (_assetReturnScanExpandStore.itemRfidDataSet.isEmpty) {
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
              _assetReturnScanExpandStore.itemRfidDataSet.elementAt(index - 3);
              var isLast =
              index - 3 == _assetReturnScanExpandStore.itemRfidDataSet.length - 1
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
                    _assetReturnScanExpandStore.itemRfidDataSet.remove(rfid);
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
      title: (args?.rtnNum ?? "No rtnNum") + " [Reg]",
      clipTitle: "Hong Kong-DC",
    );
  }

  void _addMockAssetId() {
    _assetReturnScanExpandStore.updateDataSet(
        itemList: [AscToText.getAscIIString(Random().nextInt(50).toString())]);
  }

  void _addMockEquipmentId() {
    // var init = _assetReturnScanExpandStore.equipmentRfidDataSet.length;
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
    _assetReturnScanExpandStore.updateDataSet(equList: list);
  }

  void _addMockEquipmentIdCaseOne() {
    List<String> list = [];
    list.add(AscToText.getAscIIString("CATL010000001382"));
    list.add(AscToText.getAscIIString("CATL010000000842"));
    _assetReturnScanExpandStore.updateDataSet(equList: list);
  }

  void _addMockEquipmentIdCaseTwo() {
    List<String> list = [];
    list.add(AscToText.getAscIIString("SATL010000000808"));
    list.add(AscToText.getAscIIString("CATL010000000819"));
    _assetReturnScanExpandStore.updateDataSet(equList: list);
  }

  Future<void> _debug() async {
    List<String> list = [];
    List<String> resultList = await ZebraRfd8500.debug();
    resultList.forEach((element) {
      list.add(element);
    });
    // list.add(AscToText.getAscIIString("CATL010000000808"));
    // list.add(AscToText.getAscIIString("CATL010000000819"));
    _assetReturnScanExpandStore.updateDataSet(equList: list);
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
    _assetReturnScanExpandStore.updateDataSet(equList: list1, itemList: list2);
  }

  List<Widget> _getButtonTestList() {
    List<Widget> output = [
      TextButton(
          onPressed: () async {
            // var result = await repository.getAssetRegistrationOrderDetail(rtnNum: "GDC0980203", site: 2);
            var result2 =
            await _assetReturnScanExpandStore.fetchOrderDetail("Mixson_AR3", loginFormStore.siteId!);
          },
          child: Text("Fetch Data")),
      // TextButton(
      //     onPressed: () async {
      //       _assetReturnScanExpandStore.loadOrderLineJson();
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
            await _assetReturnScanExpandStore.turnOrderLineDtoMapIntoWidget();

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
      //       _assetReturnScanExpandStore.addScannedRFID("W000114", [
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
      //       _assetReturnScanExpandStore.createContainer(
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
            _assetReturnScanExpandStore.updateDataSet(
                equList: equList, itemList: itemList);
          },
          child: Text("updateDataSet")),
      TextButton(
          onPressed: ()  {
            _assetReturnScanExpandStore.errorStore.setErrorMessage("Test");

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
                _assetReturnScanExpandStore.needUpdateUI = true;
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
          // List<String>? rfidList = (_assetReturnScanExpandStore.itemCodeRfidMapper[itemCode] as List).map((item) => item as String).toList();
          List<String> rfidList = <String>[];

          if(_assetReturnScanExpandStore.containerCodeRfidMapper.containsKey(containerCode)){
            List<String> containerRFIDList =
            _assetReturnScanExpandStore.containerCodeRfidMapper[containerCode];
            containerRFIDList.forEach((containerRFID) => rfidList.addAll(
                _assetReturnScanExpandStore.orderLineDTOMap[containerRFID]
                    .orderLineItemsMap[itemCode].rfid));
            ;

          }else{
            // Out of List
            rfidList.add(itemCode);
          }

          List<String>? rfidListInput =
          (rfidList as List).map((item) => item as String).toList();

          _assetReturnScanExpandStore.dialogDisplayRFIDList = ObservableList.of(rfidListInput);
          showStackDialog(
              containerCodeStr: containerCodeStr,
              rfidList: rfidListInput,
              justScannedRfidList: _assetReturnScanExpandStore.itemRfidDataSet.toList(),
              // title: itemTitle,
              title: _assetReturnScanExpandStore.rtnNum!,
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
            // if (containerRfid == "Not Yet Scan"){
            //   print("c8");
            //   return;
            // }
            removeContainer(containerRfid);
            // list[parentIndex]
            print("c9");
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
    if (_assetReturnScanExpandStore.containerCodeRfidMapper.containsKey(containerCodeStr)){
      if (_assetReturnScanExpandStore.containerCodeRfidMapper[containerCodeStr].isNotEmpty){
        containerRfid = _assetReturnScanExpandStore.containerCodeRfidMapper[containerCodeStr][0];
      }
    }
    return AppContentBox(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Builder(
            builder: (context) => ListView.builder(
                itemCount: _assetReturnScanExpandStore.dialogDisplayRFIDList.length,
                itemBuilder: ((context, index) {
                  final rfid = _assetReturnScanExpandStore.dialogDisplayRFIDList[index];
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
                                              _assetReturnScanExpandStore.removeContainerItemRfid(containerRfid, rfid).then((value) {
                                                setState(() {
                                                  print("remove ${_assetReturnScanExpandStore.dialogDisplayRFIDList}");
                                                  _assetReturnScanExpandStore.dialogDisplayRFIDList.removeWhere((element) => element == rfid);
                                                  _assetReturnScanExpandStore.needUpdateUI = true;
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
    if (_assetReturnScanExpandStore.containerCodeRfidMapper.containsKey(containerCodeStr)){
      if (_assetReturnScanExpandStore.containerCodeRfidMapper[containerCodeStr].isNotEmpty){
        containerRfid = _assetReturnScanExpandStore.containerCodeRfidMapper[containerCodeStr][0];
      }
    }
    String containerRFID = _assetReturnScanExpandStore.containerCodeRfidMapper[containerCodeStr][0];
    // String containerRFID = containerCodeStr;

    return AppContentBox(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Builder(
            builder: (context) => ListView.builder(
                itemCount:  _assetReturnScanExpandStore.orderLineDTOMap[containerRFID]
                    .orderLineItemsMap[itemCode].rfid.length,
                itemBuilder: ((context, index) {
                  final rfid = _assetReturnScanExpandStore.orderLineDTOMap[containerRFID]
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
                                                _assetReturnScanExpandStore.removeContainerItemRfid(containerRfid, rfid).then((value) {
                                                  _assetReturnScanExpandStore.needUpdateUI = true;
                                                  print("remove rfid is clicked");
                                                } );
                                                // _assetReturnScanExpandStore.orderLineDTOMap =_assetReturnScanExpandStore.orderLineDTOMap;
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
    //             return Text(_assetReturnScanExpandStore.rtnNum!);
    //           }),
    //           TextButton(onPressed: (){
    //             setState(() {
    //               print(title);
    //               _assetReturnScanExpandStore.rtnNum = "hiiii";
    //               print(_assetReturnScanExpandStore.rtnNum);
    //             });
    //           }, child: Text(_assetReturnScanExpandStore.rtnNum!)),
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
                            // _assetReturnScanExpandStore.isFetchingEquData
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
                            // child: Text(_assetReturnScanExpandStore.rtnNum!),
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
    orderLineWidget = await _assetReturnScanExpandStore.turnOrderLineDtoMapIntoWidget();

    setState(() {
      list = orderLineWidget;
    });
  }

  void fetchOrderDetailData(String rtnNum, int site) {
    _assetReturnScanExpandStore
        .fetchOrderDetail(rtnNum, site)
        .then((value) => updateWidget());
  }

  void removeContainerItemRfid(String containerRfid, String rfid){
    _assetReturnScanExpandStore.removeContainerItemRfid(containerRfid, rfid);
  }

  void removeContainerItem(String containerRfid, String itemCode){
    _assetReturnScanExpandStore.removeContainerItem(containerRfid, itemCode);
  }

  void removeContainer(String containerRfid){
    _assetReturnScanExpandStore.removeContainer(containerRfid);
  }
}
