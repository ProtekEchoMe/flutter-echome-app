import 'dart:async';
import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_detail_page.dart';
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_scan_page_arguments.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:json_table/json_table.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';

class RfidContainer {
  int? id;
  String? containerAssetCode;
  String? rfid;
  String? status;
  int? createdDate;

  RfidContainer(
      {this.id, this.containerAssetCode, this.rfid, this.status, this.createdDate});

  RfidContainer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    containerAssetCode = json['containerAssetCode'];
    rfid = json['rfid'];
    status = json['status'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['containerAssetCode'] = this.containerAssetCode;
    data['rfid'] = this.rfid;
    data['status'] = this.status;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

class TransferOutScanPage extends StatefulWidget {
  TransferOutScanPage({Key? key}) : super(key: key);

  @override
  State<TransferOutScanPage> createState() => _TransferOutScanPageState();
}

class _TransferOutScanPageState extends State<TransferOutScanPage> {
  static final inputFormat = DateFormat('dd/MM/yyyy');
  List<StreamSubscription> disposer = [];
  final Set itemRfidDataSet = {};
  final Set checkedItem = {};
  final Set<String> equipmentRfidDataSet = {};
  String equipmentId = "";
  EquItem? equipmentChosen;
  List<RfidContainer> containerDetails = [];
  final bool isFetchingEquId = false;
  final AssetRegistrationApi api = getIt<AssetRegistrationApi>();
  final String testcontainerAssetCode = "E100000A";
  final String testRfid = "CRFID0001";
  bool isCheckingContainer = false;
  bool hasDifferentContainer = false;
  bool isDebouncing = false;
  String containerErrorMsg = "";
  String? highlightedIndex;
  final Map errorMap = {};
  List<EquItem> equTable = [];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<JsonTableColumn> columns = [
    JsonTableColumn("id", label: "id"),
    JsonTableColumn("rfid", label: "Container RFID", valueBuilder: (value) {
      try {
        return AscToText.getString(value.toString());
      } catch (e) {
        return value.toString();
      }
    }),
    JsonTableColumn("containerAssetCode", label: "Container Code"),
    JsonTableColumn("status", label: "Status"),
    JsonTableColumn("createdDate", label: "Created At", valueBuilder: (value) {
      try {
        if (value is String) {
          return inputFormat
              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(value)));
        }
        return inputFormat.format(DateTime.fromMillisecondsSinceEpoch(value));
      } catch (e) {
        return value.toString();
      }
    })
  ];

  void showMessage(String? str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str ?? ""),
      ),
    );
  }

  Future<void> _changeEquipment(TransferOutScanPageArguments? args) async {
    print("change equ");
    try {
      if (args?.toNum == null) {
        showMessage("Transfer Out Code not found");
        return;
      }
      if (equipmentChosen?.containerAssetCode == null) {
        showMessage("Container Code not found");
        return;
      }
      if (itemRfidDataSet.isEmpty) {
        showMessage("Assets List is empty");
        return;
      }
      // if (equipmentChosen!.status != "REGISTERED") {
      //   showMessage("Container Code not registered");
      //   return;
      // }
      var result = await _registerContainer(ignoreRegisteredError: true, toNum:args?.toNum ??"");
      if (result == false) {
        return;
      }
      List<String> itemRfid =
          itemRfidDataSet.map((e) => AscToText.getString(e)).toList();
      await api.registerToItem(
          toNum: args!.toNum,
          containerAssetCode: equipmentChosen!.containerAssetCode!,
          itemRfid: itemRfid);
      _rescan();
    } catch (e) {
      showMessage(e.toString());
    } finally {
      setState(() {});
    }
  }

  void _rescan() {
    itemRfidDataSet.clear();
    checkedItem.clear();
    equipmentRfidDataSet.clear();
    containerErrorMsg = "";
    hasDifferentContainer = false;
    isDebouncing = false;
    isCheckingContainer = false;
    equipmentId = "";
    equipmentChosen = null;
    equTable.clear();
    EasyDebounce.cancel('validateContainerRfid');
    setState(() {});
  }

  Future<void> _complete(TransferOutScanPageArguments? args) async {
    try {
      await api.completeToRegister(toNum: args!.toNum);
    } catch (e) {
      showMessage(e.toString());
    } finally {
      setState(() {});
    }
  }

  void _onItemTapped(TransferOutScanPageArguments? args, int index) {
    if (index == 0) {
      _changeEquipment(args);
    } else if (index == 1) {
      _rescan();
    } else {
      _complete(args);
    }
  }

  void _handleEquTable(List list) {
    List<EquItem> newList = list.map((e) {
      var equItem = EquItem.fromJson(e);
      if (equipmentChosen != null &&
          equipmentChosen!.containerAssetCode == equItem.containerAssetCode) {
        //update EquipmentChosen
        equipmentChosen = equItem;
      }
      return equItem;
    }).toList();
    if (newList.length < equipmentRfidDataSet.length) {
      var newListRfidSet = newList.map((e) => e.rfid).toSet();
      for (var i = 0; i < equipmentRfidDataSet.length; i++) {
        String equRfid = AscToText.getString(equipmentRfidDataSet.elementAt(i));
        var newRow = EquItem(rfid: equRfid, status: "CANT FIND");
        if (!newListRfidSet.contains(equRfid)) newList.add(newRow);
      }
    }
    equTable = newList;
    _setEquipmentAuto();
    setState(() {});
  }

  void _setEquipmentAuto() {
    for (var element in equTable) {
      if (element.containerAssetCode != null) {
        equipmentId = element.containerAssetCode!;
        equipmentChosen = element;
        return;
      }
    }
  }

  // ^^^^ copy paste code, please rearrange
  Future<void> _validateContainerRfid() async {
    if (isCheckingContainer || equipmentRfidDataSet.isEmpty) {
      return;
    }
    setState(() {
      isCheckingContainer = true;
      isDebouncing = false;
    });

    var hasDiff = false;
    var containerErrorMsg1 = "";
    try {
      if (containerDetails.isEmpty) {
        List<String> list =
            equipmentRfidDataSet.map((e) => AscToText.getString(e)).toList();
        var result = await api.getContainerDetails(rfid: list);
        _handleEquTable(result["itemList"] as List);
        // if ((result["itemList"] as List).isEmpty) {
        //   hasDiff = true;
        //   containerErrorMsg1 = "Can't Find Container";
        //   print("cant find container");
        //   throw Exception("Cant find container");
        // }
        // if ((result["itemList"] as List).isNotEmpty) {
        //   _handleEquTable(result["itemList"] as List);
        //   var containerAssetCode = result["itemList"][0]["containerAssetCode"] as String;
        //   equipmentId = containerAssetCode;
        //   var result1 =
        //       await api.getContainerRfidDetails(containerAssetCode: containerAssetCode);
        //   if ((result1["itemList"] as List).isNotEmpty) {
        //     List<RfidContainer> list = (result1["itemList"] as List)
        //         .map((e) => RfidContainer.fromJson(e))
        //         .toList();
        //     containerDetails = list;
        //   }
        // }
      }
      // var set = containerDetails.map((e) => e.rfid).toSet();
      // equipmentRfidDataSet.forEach((element) {
      //   if (!set.contains(element)) {
      //     hasDiff = true;
      //     containerErrorMsg1 = "Different Equipment";
      //   }
      // });
    } catch (e) {
      showMessage(e.toString());
    } finally {
      setState(() {
        isCheckingContainer = false;
        hasDifferentContainer = hasDiff;
        containerErrorMsg = containerErrorMsg1;
      });
    }
  }

  // Future<void> _validateContainerRfid() async {
  //   if (isCheckingContainer) {
  //     return;
  //   }
  //   setState(() {
  //     isCheckingContainer = true;
  //     isDebouncing = false;
  //   });
  //   if (equipmentRfidDataSet.isEmpty) {
  //     return;
  //   }
  //   var hasDiff = false;
  //   var containerErrorMsg1 = "";
  //   try {
  //     if (containerDetails.isEmpty) {
  //       String containerRfid = equipmentRfidDataSet.first;
  //       var result = await api.getContainerRfidDetails(rfid: containerRfid);
  //       if ((result["itemList"] as List).isEmpty) {
  //         hasDiff = true;
  //         containerErrorMsg1 = "Can't Find Container";
  //         print("cant find container");
  //         throw Exception("Cant find container");
  //       }
  //       if ((result["itemList"] as List).isNotEmpty) {
  //         var containerAssetCode = result["itemList"][0]["containerAssetCode"] as String;
  //         equipmentId = containerAssetCode;
  //         var result1 =
  //             await api.getContainerRfidDetails(containerAssetCode: containerAssetCode);
  //         if ((result1["itemList"] as List).isNotEmpty) {
  //           List<RfidContainer> list = (result1["itemList"] as List)
  //               .map((e) => RfidContainer.fromJson(e))
  //               .toList();
  //           containerDetails = list;
  //         }
  //       }
  //     }
  //     var set = containerDetails.map((e) => e.rfid).toSet();
  //     equipmentRfidDataSet.forEach((element) {
  //       if (!set.contains(element)) {
  //         hasDiff = true;
  //         containerErrorMsg1 = "Different Equipment";
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     setState(() {
  //       isCheckingContainer = false;
  //       hasDifferentContainer = hasDiff;
  //       containerErrorMsg = containerErrorMsg1;
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var eventSubscription = ZebraRfd8500.eventStream.listen((event) {
      print(event);
      print(event.type);
      if (event.type == ScannerEventType.readEvent) {
        var init = itemRfidDataSet.length;
        var init1 = equipmentRfidDataSet.length;
        List<String> item = [];
        List<String> equ = [];
        (event.data as List<String>).forEach((element) {
          if (element.substring(0, 2) == "63" ||
              element.substring(0, 2) == "43") {
            equ.add(element);
          } else {
            item.add(element);
          }
        });
        itemRfidDataSet.addAll(item);
        equipmentRfidDataSet.addAll(equ);
        var after = itemRfidDataSet.length;
        var after1 = equipmentRfidDataSet.length;
        if (init1 != after1) {
          EasyDebounce.debounce(
              'validateContainerRfid', const Duration(milliseconds: 500), () {
            _validateContainerRfid();
          });
          setState(() {
            isDebouncing = true;
          });
        }
        if (init != after || init1 != after1) {
          setState(() {});
        }
      }
    });
    disposer.add(eventSubscription);
  }

  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < disposer.length; i++) {
      disposer[i].cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TransferOutScanPageArguments? args = ModalRoute.of(context)!
        .settings
        .arguments as TransferOutScanPageArguments?;
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
                if (args != null && args.item != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TransferOutDetailPage(
                                arg: args.item!,
                                // arg: args.item!,
                              )));
                }
              },
              icon: Icon(MdiIcons.clipboardList)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black54,
        selectedIconTheme:
            IconThemeData(color: Colors.black54, size: 25, opacity: .8),
        unselectedIconTheme:
            IconThemeData(color: Colors.black54, size: 25, opacity: .8),
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
        onTap: (int index) => _onItemTapped(args, index),
      ),
      body: SizedBox.expand(
        child: Column(
          children: [_getTitle(context, args), _getBody(context, args)],
        ),
      ),
    );
  }

  void _addMockAssetId() {
    itemRfidDataSet.add(AscToText.getAscIIString("SATL010000000011"));
    setState(() {});
  }

  void _addMockEquipmentId() {
    var init = equipmentRfidDataSet.length;
    if (init == 0) {
      equipmentRfidDataSet.add(AscToText.getAscIIString("CRFID0002"));
    } else if (init == 1) {
      equipmentRfidDataSet.add(AscToText.getAscIIString("CRFID0001"));
    } else if (init == 2) {
      equipmentRfidDataSet.add(AscToText.getAscIIString("CATL010000000392"));
    } else {
      equipmentRfidDataSet
          .add(AscToText.getAscIIString(new Random().nextInt(50).toString()));
    }

    var after = equipmentRfidDataSet.length;
    if (init != after) {
      EasyDebounce.debounce(
          'validateContainerRfid', const Duration(milliseconds: 500), () {
        _validateContainerRfid();
      });
      setState(() {
        isDebouncing = true;
      });
    }
  }

  Widget _getBody(BuildContext ctx, TransferOutScanPageArguments? args) {
    return Expanded(
      child: Container(
        child: ListView.builder(
            itemCount: 3 + itemRfidDataSet.length,
            itemBuilder: (ctx, index) {
              if (index == 0) {
                return ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 0, maxHeight: 350),
                  child: AppContentBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Equipment",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    isDebouncing || isCheckingContainer
                                        ? const SpinKitDualRing(
                                            color: Colors.blue,
                                            size: 15,
                                            lineWidth: 2,
                                          )
                                        : const SizedBox()
                                    // ElevatedButton(
                                    //     onPressed: false
                                    //         ? null
                                    //         : _registerContainer,
                                    //     child:
                                    //         isDebouncing || isCheckingContainer
                                    //             ? const SpinKitDualRing(
                                    //                 color: Colors.blue,
                                    //                 size: 15,
                                    //                 lineWidth: 2,
                                    //               )
                                    //             : const Text("Reg"))
                                  ],
                                ),
                                Container(
                                  width: 40,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                      child: Text(equipmentRfidDataSet.length
                                          .toString())),
                                )
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Container Code :",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(
                                  height: 40,
                                  width: 40,
                                  // child: IconButton(
                                  //   icon: Icon(Icons.close),
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       equipmentId = "";
                                  //       equipmentChosen = null;
                                  //     });
                                  //   },
                                  // )
                                ),
                                Expanded(
                                  child: Container(
                                    width: 40,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.blueAccent)),
                                    child: Center(
                                        child: Text(equipmentId.toString())),
                                  ),
                                )
                              ]),
                        ),
                        // Flexible(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(15.0),
                        //     child: SingleChildScrollView(
                        //       child: equTable.isEmpty
                        //           ? SizedBox()
                        //           : JsonTable(
                        //               equTable.map((e) => e.toJson()).toList(),
                        //               columns: columns,
                        //               onRowSelect: (index, map) {
                        //                 if ((map["status"] == "PRINTED" ||
                        //                     map["status"] == "REGISTERED")) {
                        //                   equipmentId = map["containerAssetCode"];
                        //                   equipmentChosen =
                        //                       EquItem.fromJson(map);
                        //                 } else {
                        //                   equipmentId = "";
                        //                   equipmentChosen = null;
                        //                 }
                        //                 setState(() {});
                        //               },
                        //               tableCellBuilder: (value) {
                        //                 return Container(
                        //                   height: 50,
                        //                   padding: EdgeInsets.symmetric(
                        //                       horizontal: 4.0, vertical: 2.0),
                        //                   decoration: BoxDecoration(
                        //                       border: Border.all(
                        //                           width: 0.5,
                        //                           color: Colors.grey
                        //                               .withOpacity(0.5))),
                        //                   child: Center(
                        //                     child: Text(
                        //                       value,
                        //                       textAlign: TextAlign.center,
                        //                     ),
                        //                   ),
                        //                 );
                        //               },
                        //             ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                );
              }
              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.horizontal_padding),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
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
                        padding: EdgeInsets.all(10),
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
                                    child: Text(
                                        itemRfidDataSet.length.toString())),
                              )
                            ]),
                      ),
                    ),
                  ),
                );
              }
              if (index == 2) {
                if (itemRfidDataSet.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.horizontal_padding),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
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
                          padding: EdgeInsets.all(Dimens.horizontal_padding),
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
                  return SizedBox();
                }
              }
              var rfid = itemRfidDataSet.elementAt(index - 3);
              var isLast =
                  index - 3 == itemRfidDataSet.length - 1 ? true : false;
              return _getAssetListItem(rfid, isLast);
            }),
      ),
    );
  }

  Future<bool> _registerContainer({bool ignoreRegisteredError = false, String toNum=""}) async {
    try {
      print(equipmentChosen);
      if (equipmentChosen == null) {
        throw "No Equipment detected";
      }
      var targetcontainerAssetCode = equipmentChosen!.containerAssetCode;
      List<String> rfidList = [];
      for (var element in equTable) {
        if (element.containerAssetCode == targetcontainerAssetCode) {
          if (element.rfid != null) {
            rfidList.add(element.rfid!);
          }
        }
      }
      await api.registerToContainer(rfid: rfidList, toNum: toNum);
      EasyDebounce.debounce(
          'validateContainerRfid', const Duration(milliseconds: 500), () {
        _validateContainerRfid();
      });
      setState(() {
        isDebouncing = true;
      });
      return true;
    } catch (e) {
      if (e.toString().contains("Error 2109") &&
          ignoreRegisteredError == true) {
        return true;
      }
      showMessage(e.toString());
      return false;
    }
  }

  Widget _getAssetListItem(rfid, isLast) {
    if (isLast) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimens.horizontal_padding),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                  vertical: BorderSide(
                      color: Theme.of(context).primaryColor, width: 6),
                )),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                        value: checkedItem.contains(rfid),
                        onChanged: (bool? value) {
                          if (value == null) {
                            value = false;
                          }
                          if (value == true) {
                            setState(() {
                              checkedItem.add(rfid);
                            });
                            return;
                          }
                          if (value == false) {
                            setState(() {
                              checkedItem.remove(rfid);
                            });
                            return;
                          }
                        }),
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
                              itemRfidDataSet.remove(rfid);
                              checkedItem.remove(rfid);
                            });
                          },
                          icon: Icon(Icons.close)),
                    )
                  ]),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.horizontal_padding),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
              vertical:
                  BorderSide(color: Theme.of(context).primaryColor, width: 6),
            )),
        child: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                      value: checkedItem.contains(rfid),
                      onChanged: (bool? value) {
                        if (value == null) {
                          value = false;
                        }
                        if (value == true) {
                          setState(() {
                            checkedItem.add(rfid);
                          });
                          return;
                        }
                        if (value == false) {
                          setState(() {
                            checkedItem.remove(rfid);
                          });
                          return;
                        }
                      }),
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
                            itemRfidDataSet.remove(rfid);
                            checkedItem.remove(rfid);
                          });
                        },
                        icon: Icon(Icons.close)),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Widget _getAssetListBottom({double padding = Dimens.horizontal_padding}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.symmetric(
                vertical:
                    BorderSide(color: Theme.of(context).primaryColor, width: 6),
              )),
        ),
      ),
    );
  }

  Widget _getTitle(BuildContext ctx, TransferOutScanPageArguments? args) {
    return BodyTitle(
      title: args?.toNum ?? "No DocNum",
      clipTitle: "Hong Kong-DC",
    );
  }
}

class EquItem {
  int? id;
  String? containerAssetCode;
  String? rfid;
  String? status;
  int? createdDate;

  EquItem(
      {this.id, this.containerAssetCode, this.rfid, this.status, this.createdDate});

  EquItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    containerAssetCode = json['containerAssetCode'];
    rfid = json['rfid'];
    status = json['status'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['containerAssetCode'] = this.containerAssetCode;
    data['rfid'] = this.rfid;
    data['status'] = this.status;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
