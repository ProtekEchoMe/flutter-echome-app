import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_inventory/asset_inventory_detail_page.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_item.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/app_loader.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:echo_me_mobile/widgets/status_list_item.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:echo_me_mobile/stores/asset_inventory/asset_inventory_store.dart';
import 'package:echo_me_mobile/stores/asset_inventory/asset_inventory_scan_store.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';

import 'package:echo_me_mobile/utils/ascii_to_text.dart';
import 'package:echo_me_mobile/utils/soundPoolUtil.dart';


class AssetInventoryPage extends StatefulWidget {
  final String? assetCode;
  final String? productCode;

  AssetInventoryPage({Key? key, this.assetCode, this.productCode}) : super(key: key);

  @override
  State<AssetInventoryPage> createState() => _AssetInventoryPageState();
}

class _AssetInventoryPageState extends State<AssetInventoryPage> {
  final AssetInventoryStore _assetInventoryStore = getIt<AssetInventoryStore>();
  final AssetInventoryScanStore _assetInventoryScanStore = getIt<AssetInventoryScanStore>();
  final LoginFormStore _loginFormStore = getIt<LoginFormStore>();

  TextEditingController skuSearchBarTextController = TextEditingController();
  final SoundPoolUtil soundPoolUtil = SoundPoolUtil();

  //test
  int i = 0;

  List<dynamic> disposer = [];

  @override
  void initState() {
    super.initState();
    _assetInventoryStore.fetchData(
        assetCode: widget.assetCode ?? "", productCode: widget.productCode ?? "", siteCode: _loginFormStore.siteCode ?? "");

    var eventSubscription = ZebraRfd8500.eventStream.listen((event) {
      print(event);
      print(event.type);
      soundPoolUtil.initState();
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
        //TODO: Update Serach Bar Input wheen having input from scanner gun
        _assetInventoryScanStore.updateDataSet(equList: equ, itemList: item);
        if(item.isNotEmpty) {
          skuSearchBarTextController.text = AscToText.getString(item[0]);
        }
        print("");
      }
    });

    disposer.add(() => eventSubscription.cancel());

  }

  @override
  Widget build(BuildContext context) {
    Widget scaffold = Scaffold(
        appBar: EchoMeAppBar(),
        body: SizedBox.expand(
          child: Column(children: [
            _getTitle(context),
            _getSearchBarCombined(context),
            _getListBox(context),
          ]),
        ));


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

  Widget _getTitle(BuildContext ctx) {
    return BodyTitle(
      title: "Asset Inventory",
      clipTitle: "Hong Kong-DC",
    );
  }

  Widget _getListBox(BuildContext ctx) {
    return Expanded(
      child: Observer(
        builder: (context) {
          var isFetching = _assetInventoryStore.isFetching;
          return AppContentBox(
            child: isFetching
                ? const AppLoader()
                : _assetInventoryStore.itemList.isEmpty
                    ? const Center(child: Text("No Data"))
                    : Stack(
                        children: [
                          Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              height: kTextTabBarHeight,
                              child: Container(
                                color: Theme.of(context).secondaryHeaderColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _assetInventoryStore.prevPage(
                                          assetCode: widget.assetCode ?? "", productCode: widget.productCode ?? "", siteCode: _loginFormStore.siteCode ?? ""
                                        );
                                      },
                                      child: const SizedBox(
                                        width: 40,
                                        child: Center(
                                          child: Icon(Icons.arrow_back),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Observer(builder: (context) {
                                        var total = _assetInventoryStore.totalCount;
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("Total: ${total}"),
                                            Text(
                                                "Page: ${_assetInventoryStore.currentPage}/${_assetInventoryStore.totalPage} ")
                                          ],
                                        );
                                      }),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _assetInventoryStore.nextPage(
                                          assetCode: widget.assetCode ?? "", productCode: widget.productCode ?? "", siteCode: _loginFormStore.siteCode ?? ""
                                        );
                                      },
                                      child: const SizedBox(
                                        width: 40,
                                        child: Center(
                                          child: Icon(Icons.arrow_forward),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: kTextTabBarHeight,
                            child: Observer(
                              builder: (context) => ListView.builder(
                                itemCount: _assetInventoryStore.itemList.length,
                                itemBuilder: ((context, index) {
                                  return Observer(
                                    builder: (context) {
                                      final listItem = _assetInventoryStore.itemList[index];
                                      var productCode = listItem.productCode;
                                      var regNum = listItem.regNum;
                                      var tiNum = listItem.tiNum;
                                      var toNum = listItem.toNum;
                                      var rfid = listItem.rfid;

                                      var subtitle = "";
                                      (productCode != null) ? subtitle += "productCode: $productCode" : "";
                                      (tiNum != null) ? subtitle += "\nTi: $tiNum" : "";
                                      (toNum != null) ? subtitle += "\nTo :$toNum" : "";
                                      (regNum != null) ? subtitle += "\nReg: $regNum" : "";
                                      (rfid != null) ? subtitle += "\nRfid: $rfid" : "";
                                      // subtitle += tiNum ?? "";
                                      // subtitle += toNum ?? "";

                                      var title =
                                          listItem.description.toString();
                                      var status = listItem.status;
                                      // ignore: prefer_function_declarations_over_variables
                                      var fx = () {
                                        print(listItem);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AssetInventoryDetailPage(item:listItem)));};
                                      return StatusListItem(
                                        title: title,
                                        subtitle: subtitle,
                                        titleTextSize: 15,
                                        subtitleTextSize: 15,
                                        callback: fx,
                                      );
                                    },
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }

  Color _getColor(RegistrationItemStatus status) {
    if (status.name == "draft") {
      return Colors.grey;
    }
    if (status.name == "pending") {
      return Colors.green;
    }
    if (status.name == "processing") {
      return Colors.red;
    }
    return Colors.blue;
  }

  Widget _getSearchBarAsset(BuildContext ctx) {
    if (widget.assetCode != null) {
      return Padding(
        padding: const EdgeInsets.all(Dimens.horizontal_padding),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                    "Searching for Asset Code = " + widget.assetCode!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(Dimens.horizontal_padding),
      child: OutlineSearchBar(
        // initText: "INIT TEXT",
        textEditingController: skuSearchBarTextController,
        backgroundColor: Theme.of(context).cardColor,
        hintText: "Search by Asset Code",
        onSearchButtonPressed: (str) {
          if (str != null && str.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AssetInventoryPage(assetCode: str.trim())));
          }
        },
      ),
    );
  }

  Widget _getSearchBarSKU(BuildContext ctx) {
    if (widget.assetCode != null) {
      return Padding(
        padding: const EdgeInsets.all(Dimens.horizontal_padding),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                    "Searching for SKU  = " + widget.productCode!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(Dimens.horizontal_padding),
      child: OutlineSearchBar(
        // initText: "INIT TEXT",
        textEditingController: skuSearchBarTextController,
        backgroundColor: Theme.of(context).cardColor,
        hintText: "Search by SKU",
        onSearchButtonPressed: (str) {
          if (str != null && str.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AssetInventoryPage(productCode: skuSearchBarTextController.text.trim())));
          }
        },
      ),
    );
  }

  Widget _getSearchBarCombined(BuildContext ctx) {
    if (widget.assetCode != null) {
      return Padding(
        padding: const EdgeInsets.all(Dimens.horizontal_padding),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                    "Searching for SKU/RFID  = " + widget.productCode! + widget.assetCode!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(Dimens.horizontal_padding),
      child: OutlineSearchBar(
        // initText: "INIT TEXT",
        textEditingController: skuSearchBarTextController,
        backgroundColor: Theme.of(context).cardColor,
        hintText: "Search by productCode/Rfid",
        onSearchButtonPressed: (str) {
          if (str != null && str.isNotEmpty) {
            String skuCode = "";
            String assetCode = "";
            str.startsWith("SATL")? assetCode = str.trim() : skuCode = str.trim();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AssetInventoryPage(productCode: skuCode, assetCode: assetCode)));
          }
        },
      ),
    );
  }
}
