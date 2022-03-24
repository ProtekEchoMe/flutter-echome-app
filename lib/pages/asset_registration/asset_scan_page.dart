import 'dart:async';

import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/utils/hex_to_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';
import "package:hex/hex.dart";

import '../../widgets/echo_me_app_bar.dart';
import 'asset_scan_page_arguments.dart';

class AssetScanPage extends StatefulWidget {
  AssetScanPage({Key? key}) : super(key: key);

  @override
  State<AssetScanPage> createState() => _AssetScanPageState();
}

class _AssetScanPageState extends State<AssetScanPage> {
  List<StreamSubscription> disposer = [];
  final Set itemRfidDataSet = {};
  final Set checkedItem = {};
  final Set equipmentRfidDataSet = {};
  final String equipmentId = "";
  final bool isFetchingEquId = false;
  //  copy paste code, please rearrange

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _changeEquipment() {}

  void _rescan() {
    itemRfidDataSet.clear();
    checkedItem.clear();
    equipmentRfidDataSet.clear();
    setState(() {
      
    });
  }

  void _complete() {}

  void _onItemTapped(int index) {
    if (index == 0) {
      _changeEquipment();
    } else if (index == 1) {
      _rescan();
    } else {
      _complete();
    }
  }
  // ^^^^ copy paste code, please rearrange

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var eventSubscription = ZebraRfd8500.eventStream.listen((event) {
      print(event);
      print(event.type);
      if (event.type == ScannerEventType.readEvent) {
        var init = itemRfidDataSet.length;
        var init1 = equipmentRfidDataSet
        .length;
        List<String> item = [];
        List<String> equ = [];
        (event.data as List<String>).forEach((element) { 
          if(element.substring(0,2) == "63"){
            equ.add(element);
          }else{
            item.add(element);
          }
        });
        itemRfidDataSet.addAll(item);
        equipmentRfidDataSet.addAll(equ);
        var after = itemRfidDataSet.length;
        var after1 = equipmentRfidDataSet.length;
        if (init != after || init1 != after1) {
          setState(() {});
        }
      }
    });
    disposer.add(eventSubscription);
  }

  Widget _getDataList() {
    return SingleChildScrollView(
        child: Column(
      children: itemRfidDataSet.map((e) => Text(e)).toList(),
    ));
    //  itemRfidDataSet.length == 0 ? Center(child: Text("No Data")) : _getDataList()
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
      appBar: EchoMeAppBar(titleText: args != null ? args.docNum : null),
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
        onTap: _onItemTapped,
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
              print(index);
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(Dimens.horizontal_padding),
                  child: Container(
                    width: double.maxFinite,
                    height: 130,
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
                        ]),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Equipment",
                                  style: Theme.of(context).textTheme.titleLarge,
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
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Current ID :",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: isFetchingEquId
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: SpinKitRing(
                                              color: Colors.blue,
                                              size: 30.0,
                                              lineWidth: 3,
                                            ),
                                          )
                                        : null,
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 40,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                          child: Text(equipmentId
                                              .toString())),
                                    ),
                                  )
                                ]),
                          ),
                        )
                      ],
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
              if(index ==2){
                if(itemRfidDataSet.isEmpty){
                  return Padding(padding: EdgeInsets.all(Dimens.horizontal_padding),
                  child: Center(child: Text("No Data", style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 30))),);
                }else{
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
                          Expanded(child: Text(
                            HexToText.getString(rfid),
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
