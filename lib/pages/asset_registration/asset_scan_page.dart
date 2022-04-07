import 'dart:async';
import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/assset_scan_details.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:json_table/json_table.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';

import 'asset_scan_page_arguments.dart';

class RfidContainer {
  int? id;
  String? containerCode;
  String? rfid;
  String? status;
  int? createdDate;

  RfidContainer(
      {this.id, this.containerCode, this.rfid, this.status, this.createdDate});

  RfidContainer.fromJson(Map<String, dynamic> json) {
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

class AssetScanPage extends StatefulWidget {
  AssetScanPage({Key? key}) : super(key: key);

  @override
  State<AssetScanPage> createState() => _AssetScanPageState();
}

class _AssetScanPageState extends State<AssetScanPage> {
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
  final String testContainerCode = "E100000A";
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
    JsonTableColumn("containerCode", label: "Container Code"),
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

  void _changeEquipment(AssetScanPageArguments? args) async {
    print("change equ");
    try{
      if(args?.docNum == null){
        showMessage("Document Number not found");
        return;
      }
      if(equipmentChosen?.containerCode == null){
        showMessage("Container Code not found");
        return;
      }
      if(equipmentChosen!.status != "REGISTERED"){
        showMessage("Container Code not registered");
        return;
      }
      if(itemRfidDataSet.isEmpty){
        showMessage("Assets List is empy");
        return;
      }
      List<String> itemRfid = itemRfidDataSet.map((e) =>    AscToText.getString(e)).toList();
      await api.registerItem(docNum: args!.docNum, containerCode: equipmentChosen!.containerCode!, itemRfid: itemRfid );
      _rescan();
    }catch(e){
      showMessage(e.toString());
    }finally{
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

  void _complete() {}

  void _onItemTapped(AssetScanPageArguments? args, int index) {
    if (index == 0) {
      _changeEquipment(args);
    } else if (index == 1) {
      _rescan();
    } else {
      _complete();
    }
  }

  void _handleEquTable(List list) {
    List<EquItem> newList = list.map((e){
      var equItem = EquItem.fromJson(e);
      if(equipmentChosen!=null && equipmentChosen!.containerCode == equItem.containerCode){
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
    setState(() {});
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
        //   var containerCode = result["itemList"][0]["containerCode"] as String;
        //   equipmentId = containerCode;
        //   var result1 =
        //       await api.getContainerRfidDetails(containerCode: containerCode);
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
  //         var containerCode = result["itemList"][0]["containerCode"] as String;
  //         equipmentId = containerCode;
  //         var result1 =
  //             await api.getContainerRfidDetails(containerCode: containerCode);
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
          if (element.substring(0, 2) == "63") {
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
    final AssetScanPageArguments? args =
        ModalRoute.of(context)!.settings.arguments as AssetScanPageArguments?;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.play_arrow),
          onPressed: () {
            var init = equipmentRfidDataSet.length;
            if (init == 0) {
              equipmentRfidDataSet.add(AscToText.getAscIIString(testRfid));
            } else if (init == 1) {
              equipmentRfidDataSet.add(AscToText.getAscIIString("CATL010000000437"));
            } else if (init == 2) {
              equipmentRfidDataSet
                  .add(AscToText.getAscIIString("CATL010000000303"));
            } else {
              equipmentRfidDataSet.add(AscToText.getAscIIString(
                  new Random().nextInt(50).toString()));
            }

            var after = equipmentRfidDataSet.length;
            if (init != after) {
              EasyDebounce.debounce(
                  'validateContainerRfid', const Duration(milliseconds: 500),
                  () {
                _validateContainerRfid();
              });
              setState(() {
                isDebouncing = true;
              });
            }
          }),
      appBar: AppBar(
        title: Row(
          children: [Text(args != null ? args.docNum : "EchoMe")],
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (args != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AssetScanDetails(
                                arg: args,
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
        onTap:(int index) => _onItemTapped(args, index),
      ),
      body: SizedBox.expand(
        child: Column(
          children: [_getTitle(context, args), _getBody(context, args)],
        ),
      ),
    );
  }

  Widget _getBody(BuildContext ctx, AssetScanPageArguments? args) {
    return Expanded(
      child: Container(
        child: ListView.builder(
            itemCount: 3 + itemRfidDataSet.length,
            itemBuilder: (ctx, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(Dimens.horizontal_padding),
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minHeight: 0, maxHeight: 350),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      ElevatedButton(
                                          onPressed: equipmentChosen == null ||
                                                  equipmentChosen?.status ==
                                                      "REGISTERED"
                                              ? null
                                              : () async {
                                                  try {
                                                    var targetContainerCode =
                                                        equipmentChosen!
                                                            .containerCode;
                                                    List<String> rfidList = [];
                                                    for (var element
                                                        in equTable) {
                                                      if (element
                                                              .containerCode ==
                                                          targetContainerCode) {
                                                        if (element.rfid !=
                                                            null) {
                                                          rfidList.add(
                                                              element.rfid!);
                                                        }
                                                      }
                                                    }
                                                    await api.registerContainer(
                                                        rfid: rfidList);
                                                    EasyDebounce.debounce(
                                                        'validateContainerRfid',
                                                        const Duration(
                                                            milliseconds: 500),
                                                        () {
                                                      _validateContainerRfid();
                                                    });
                                                    setState(() {
                                                      isDebouncing = true;
                                                    });
                                                  } catch (e) {
                                                    showMessage(e.toString());
                                                  }
                                                },
                                          child: isDebouncing ||
                                                  isCheckingContainer
                                              ? const SpinKitDualRing(
                                                  color: Colors.blue,
                                                  size: 15,
                                                  lineWidth: 2,
                                                )
                                              : const Text("Reg"))
                                    ],
                                  ),
                                  Container(
                                    width: 40,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Container Code :",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          setState(() {
                                            equipmentId = "";
                                            equipmentChosen = null;
                                          });
                                        },
                                      )),
                                  Expanded(
                                    child: Container(
                                      width: 40,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.blueAccent)),
                                      child: Center(
                                          child: Text(equipmentId.toString())),
                                    ),
                                  )
                                ]),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SingleChildScrollView(
                                child: equTable.isEmpty
                                    ? SizedBox()
                                    : JsonTable(
                                        equTable
                                            .map((e) => e.toJson())
                                            .toList(),
                                        columns: columns,
                                        onRowSelect: (index, map) {
                                          if ((map["status"] == "PRINTED" ||
                                              map["status"] == "REGISTERED")) {
                                            equipmentId = map["containerCode"];
                                            equipmentChosen =
                                                EquItem.fromJson(map);
                                          } else {
                                            equipmentId = "";
                                            equipmentChosen = null;
                                          }
                                          setState(() {});
                                        },
                                        tableCellBuilder: (value) {
                                          return Container(
                                            height: 50,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 2.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.grey
                                                        .withOpacity(0.5))),
                                            child: Center(
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.all(Dimens.horizontal_padding),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
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
                                  child:
                                      Text(itemRfidDataSet.length.toString())),
                            )
                          ]),
                    ),
                  ),
                );
              }
              if (index == 2) {
                if (itemRfidDataSet.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(Dimens.horizontal_padding),
                    child: Center(
                        child: Text("No Data",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(fontSize: 30))),
                  );
                } else {
                  return SizedBox();
                }
              }
              var rfid = itemRfidDataSet.elementAt(index - 3);
              return Padding(
                padding: const EdgeInsets.all(Dimens.horizontal_padding),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
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
              );
            }),
      ),
    );
  }

  Widget _getTitle(BuildContext ctx, AssetScanPageArguments? args) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.horizontal_padding),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: Text(
                  args?.docNum != null && args!.docNum.isNotEmpty
                      ? args.docNum
                      : " No DocNum",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 35),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              width: 130,
              height: 30,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Text(
                "Hong Kong-DC",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              )),
            ),
          )
        ],
      ),
    );
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
