import 'dart:async';
import 'dart:math';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/assset_scan_detail_page.dart';
import 'package:echo_me_mobile/stores/assest_registration/asset_registration_scan_store.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';
import 'asset_scan_page_arguments.dart';

class AssetScanPage extends StatefulWidget {
  const AssetScanPage({Key? key}) : super(key: key);

  @override
  State<AssetScanPage> createState() => _AssetScanPageState();
}

class _AssetScanPageState extends State<AssetScanPage> {
  final AssetRegistrationScanStore _assetRegistrationScanStore =
      getIt<AssetRegistrationScanStore>();
  List<dynamic> disposer = [];
  final Set itemRfidDataSet = {};
  final Set checkedItem = {};
  EquItem? equipmentChosen;
  final bool isFetchingEquId = false;
  final AssetRegistrationApi api = getIt<AssetRegistrationApi>();
  final Map errorMap = {};
  List<EquItem> equTable = [];

  void _showSnackBar(String? str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str ?? ""),
      ),
    );
  }

  String _getContainerCode() {
    return _assetRegistrationScanStore.chosenEquipmentData.isNotEmpty
        ? (_assetRegistrationScanStore.chosenEquipmentData[0].containerCode ??
            "")
        : "";
  }

  Future<void> _changeEquipment(AssetScanPageArguments? args) async {
    print("change equ");
    try {
      if (args?.regNum == null) {
        throw "Reg Number Not Found";
      }

      if (_getContainerCode().isEmpty) {
        throw "Container Code not found";
      }

      if (_assetRegistrationScanStore.itemRfidDataSet.isEmpty) {
        throw "Assets List is empty";
      }

      if (_assetRegistrationScanStore.chosenEquipmentData.isEmpty) {
        throw "No equipment detected";
      }

      var targetContainerCode = _getContainerCode();

      List<String> rfidList = [];
      for (var element in _assetRegistrationScanStore.equipmentData) {
        if (element.containerCode == targetContainerCode) {
          if (element.rfid != null) {
            rfidList.add(element.rfid!);
          }
        }
      }

      try {
        await _assetRegistrationScanStore.registerContainer(
            rfid: rfidList, regNum: args?.regNum ?? "", throwError: true);
      } catch (e) {
        if (!e.toString().contains("Error 2109")) {
          rethrow;
        }
      }

      List<String> itemRfid = _assetRegistrationScanStore.itemRfidDataSet
          .map((e) => AscToText.getString(e))
          .toList();

      await _assetRegistrationScanStore.registerItem(
          regNum: args?.regNum ?? "",
          itemRfid: itemRfid,
          containerCode: targetContainerCode);

      _assetRegistrationScanStore.reset();
    } catch (e) {
      _assetRegistrationScanStore.errorStore.setErrorMessage(e.toString());
    }
  }

  void _rescan() {
    _assetRegistrationScanStore.reset();
  }

  Future<void> _complete(AssetScanPageArguments? args) async {
    _assetRegistrationScanStore.complete(regNum: args?.regNum ?? "");
  }

  void _onBottomBarItemTapped(AssetScanPageArguments? args, int index) {
    if (index == 0) {
      _changeEquipment(args);
    } else if (index == 1) {
      _rescan();
    } else {
      _complete(args);
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
          } else {
            item.add(element);
          }
        }
        _assetRegistrationScanStore.updateDataSet(equList: equ, itemList: item);
      }
    });
    var disposerReaction = reaction(
        (_) => _assetRegistrationScanStore.errorStore.errorMessage, (_) {
      if (_assetRegistrationScanStore.errorStore.errorMessage.isNotEmpty) {
        _showSnackBar(_assetRegistrationScanStore.errorStore.errorMessage);
      }
    });
    disposer.add(() => eventSubscription.cancel());
    disposer.add(disposerReaction);
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
    final AssetScanPageArguments? args =
        ModalRoute.of(context)!.settings.arguments as AssetScanPageArguments?;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
                heroTag: null,
                child: const Icon(Icons.add_box),
                onPressed: _addMockEquipmentId),
            const SizedBox(
              width: 20,
            ),
            FloatingActionButton(
              heroTag: null,
              onPressed: _addMockAssetId,
              child: const Icon(MdiIcons.cart),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [Text(args != null ? args.regNum : "EchoMe")],
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (args != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AssetScanDetailPage(
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
                            _assetRegistrationScanStore.isFetchingEquData
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
                            _assetRegistrationScanStore
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

  Widget _getBody(BuildContext ctx, AssetScanPageArguments? args) {
    return Expanded(
      child: Observer(builder: (context) {
        return ListView.builder(
            itemCount: 3 + _assetRegistrationScanStore.itemRfidDataSet.length,
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
                                    child: Text(_assetRegistrationScanStore
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
                if (_assetRegistrationScanStore.itemRfidDataSet.isEmpty) {
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
              var rfid = _assetRegistrationScanStore.itemRfidDataSet
                  .elementAt(index - 3);
              var isLast = index - 3 ==
                      _assetRegistrationScanStore.itemRfidDataSet.length - 1
                  ? true
                  : false;
              return _getAssetListItem(rfid, isLast);
            });
      }),
    );
  }

  Future<bool> _registerContainer(
      {bool ignoreRegisteredError = false, String regNum = ""}) async {
    try {
      print(equipmentChosen);
      if (equipmentChosen == null) {
        throw "No Equipment detected";
      }
      var targetContainerCode = equipmentChosen!.containerCode;
      List<String> rfidList = [];
      for (var element in equTable) {
        if (element.containerCode == targetContainerCode) {
          if (element.rfid != null) {
            rfidList.add(element.rfid!);
          }
        }
      }
      await api.registerContainer(rfid: rfidList, regNum: regNum);
      // EasyDebounce.debounce(
      //     'validateContainerRfid', const Duration(milliseconds: 500), () {
      //   _validateContainerRfid();
      // });
      return true;
    } catch (e) {
      if (e.toString().contains("Error 2109") &&
          ignoreRegisteredError == true) {
        return true;
      }
      _showSnackBar(e.toString());
      return false;
    }
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
                    _assetRegistrationScanStore.itemRfidDataSet.remove(rfid);
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

  Widget _getTitle(BuildContext ctx, AssetScanPageArguments? args) {
    return BodyTitle(
      title: args?.regNum ?? "No RegNum",
      clipTitle: "Hong Kong-DC",
    );
  }

  void _addMockAssetId() {
    _assetRegistrationScanStore.updateDataSet(itemList: [
      AscToText.getAscIIString(new Random().nextInt(50).toString())
    ]);
  }

  void _addMockEquipmentId() {
    var init = _assetRegistrationScanStore.equipmentRfidDataSet.length;
    List<String> list = [];
    if (init == 0) {
      list.add(AscToText.getAscIIString("CATL010000001708"));
    } else if (init == 1) {
      list.add(AscToText.getAscIIString("CATL010000001719"));
    } else if (init == 2) {
      list.add(AscToText.getAscIIString("CRFID0001"));
    } else {
      list.add(AscToText.getAscIIString(new Random().nextInt(50).toString()));
    }
    _assetRegistrationScanStore.updateDataSet(equList: list);
  }
}

class EquItem {
  int? id;
  String? containerCode;
  String? rfid;
  String? status;
  int? createdDate;

  EquItem(
      {this.id, this.containerCode, this.rfid, this.status, this.createdDate});

  EquItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    containerCode = json['containerCode'];
    rfid = json['rfid'];
    status = json['status'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['containerCode'] = this.containerCode;
    data['rfid'] = this.rfid;
    data['status'] = this.status;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
