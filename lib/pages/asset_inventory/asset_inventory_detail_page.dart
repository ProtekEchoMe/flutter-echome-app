import 'package:echo_me_mobile/models/asset_inventory/asset_inventory_item.dart';
import 'package:echo_me_mobile/stores/asset_inventory/asset_inventory_scan_store.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';
import 'package:echo_me_mobile/di/service_locator.dart';

import 'package:zebra_rfd8500/zebra_rfd8500.dart';

import 'package:echo_me_mobile/utils/soundPoolUtil.dart';
final SoundPoolUtil soundPoolUtil = SoundPoolUtil();

class AssetInventoryDetailPage extends StatefulWidget {
  AssetInventoryItem? item;
  AssetInventoryDetailPage({Key? key, AssetInventoryItem? item})
      : super(key: key) {
    this.item = item;
  }
  @override
  State<AssetInventoryDetailPage> createState() =>
      _AssetInventoryDetailPageState();
}

class _AssetInventoryDetailPageState extends State<AssetInventoryDetailPage> {
  String disStr = "";
  List<dynamic> disposer = [];
  TextEditingController itemSearchTextController = TextEditingController();
  final AssetInventoryScanStore _assetInventoryScanStore = getIt<AssetInventoryScanStore>();

  void initState() {
    super.initState();
    soundPoolUtil.initState();
    var eventSubscription = ZebraRfd8500.eventStream.listen((event) {
      // print("event: " + event.toString());
      // print("event.type: " + event.type.toString());
      if (event.type == ScannerEventType.locatingEvent) {
        for (var disStr in (event.data as List<String>)) {
          print("element: " + disStr);
          // updateLocatingDis(element);
          _assetInventoryScanStore.updateDisStr(disStr);
          double volume = double.parse(disStr).abs() / 100 ;
          soundPoolUtil.updateVolume(volume);
          soundPoolUtil.playCheering();
          // setState((){
          //   updateLocatingDis(element);
          // });
        }
        // _assetRegistrationScanStore.updateDataSet(equList: equ, itemList: item);
        print("");
      }
    });
    // var disposerReaction = reaction(
    //         (_) => _assetRegistrationScanStore.errorStore.errorMessage, (_) {
    //   if (_assetRegistrationScanStore.errorStore.errorMessage.isNotEmpty) {
    //     DialogHelper.showErrorDialogBox(context, errorMsg: _assetRegistrationScanStore.errorStore.errorMessage);
    //     _showSnackBar(_assetRegistrationScanStore.errorStore.errorMessage);
    //   }
    // });

    disposer.add(() => eventSubscription.cancel());
    // disposer.add(disposerReaction);
  }

  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < disposer.length; i++) {
      disposer[i]();
    }
  }

  void updateLocatingDis(String disStr){
    this.disStr = disStr;
  }


  Future<void> _onBottomBarItemTapped(int index) async {
    try{
      if (index == 0) {
        print("Start Clicked");
        // ZebraRfd8500.getAvailableRFIDReaderList().then((value) {
        //   setState(() {
        //     readerList = value;
        //   });
        String rfid = widget.item?.rfid ?? "";
        String rfidHexCode = AscToText.getAscIIString(rfid);
        rfidHexCode = "5341544C303130303030303031363431";
        var test = await ZebraRfd8500.performTagLocating(rfidHexCode);
        print(test.toString());
      } else if (index == 1) {

        print("Stop Clicked");
        var test = await ZebraRfd8500.stopTagLocating();
        print(test.toString());
      }
    }catch (e){
      // _assetRegistrationScanStore.errorStore.setErrorMessage(e.toString());
      print(e.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    print(widget.item);
    var list = widget.item != null
        ? widget.item!
            .toJson()
            .keys
            .map((e) => [e, widget.item!.toJson()[e]])
            .toList()
        : [];
    print(list);
    return Scaffold(
      appBar: EchoMeAppBar(),
      body: SizedBox.expand(
        child: Column(
          children: [
            BodyTitle(
              title: "Inventory Details",
              clipTitle: "Hong Kong-DC",
            ),
            Expanded(
              child: AppContentBox(
                child: widget.item != null
                    ? ListView.separated(
                        itemBuilder: (ctx, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text((list[index] as List)[0].toString()),
                                  Text((list[index] as List)[1].toString()),
                                ],
                              ),
                        ),
                        separatorBuilder: (ctx, int) =>
                            const Divider(color: Colors.grey),
                        itemCount: widget.item!.toJson().length)
                    : const Center(child: Text("No data")),
              ),
            ),
          ],
        ),
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
              label: 'Start',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.signal_cellular_alt),
              label: 'Stop',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.eleven_mp),
            //   label: 'Debug',
            // ),
          ],
          onTap: (int index) => _onBottomBarItemTapped(index),
        ),
        floatingActionButton:
        Container(
            height: 50,
            width: 50,
            child: FittedBox(
                child: FloatingActionButton( //TODO: Direct Transfer Out Create API
                  // onPressed: () {
                  //   showCupertinoModalPopup<void>(
                  //       context: context, builder: (BuildContext context){
                  //     return _buildBottomPicker2(
                  //         _buildCupertinoPicker(_accessControlStore.getAccessControlledTOSiteNameList));
                  //   });
                  // },
                  onPressed: () {
                    print("disStr: " + disStr);
                    //testing
                    // if (_assetInventoryScanStore.disStr == ""){
                    //   _assetInventoryScanStore.updateDisStr("0");
                    // }
                    // int num = int.parse(_assetInventoryScanStore.disStr) + 1;
                    // _assetInventoryScanStore.updateDisStr(num.toString());
                    // setState((){
                    //   updateLocatingDis(disStr);
                    // });
                  },
                  // child: const Icon(Icons.add),
                  // child: itemSearchTextController,
                  // child: Text(disStr.toString()),
                  child: Observer(
                    builder: (context) => Container(
                      child: Center(
                        child: Text(
                          _assetInventoryScanStore
                              .disStr
                        ),
                      ),
                    ),
                  ),
                  // Text(disStr.toString()),
                  // foregroundColor:  Colors.orange[700]!.withOpacity(0.5),
                  // backgroundColor: Colors.orange[700]!.withOpacity(0.9),
                ))),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat
    );
  }


}
