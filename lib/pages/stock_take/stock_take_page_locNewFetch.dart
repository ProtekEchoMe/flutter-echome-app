import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_item.dart';
import 'package:echo_me_mobile/pages/asset_registration/backup/asset_registration_search_page.dart';
import 'package:echo_me_mobile/pages/stock_take/stock_take_scan_detail_page.dart';
import 'package:echo_me_mobile/stores/stock_take/stock_take_store.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_store.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/app_loader.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:echo_me_mobile/widgets/status_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

import 'package:echo_me_mobile/stores/stock_take/stock_take_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_loc_item.dart';
import 'stock_take_scan_page_arguments.dart';

import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class StockTakeLocNewPage extends StatefulWidget {
  final StockTakeLocItem? stockTakeLocItem;

  StockTakeLocNewPage({Key? key, this.stockTakeLocItem}) : super(key: key);

  @override
  State<StockTakeLocNewPage> createState() => _StockTakeLocNewPageState();
}

class _StockTakeLocNewPageState extends State<StockTakeLocNewPage> {
  final StockTakeStore _stockTakeStore = getIt<StockTakeStore>();
  final AccessControlStore accessControlStore = getIt<AccessControlStore>();


  List<StockTakeLocItem> getSTLocItemList(String locString, String stNum,
      String status) {
    List<StockTakeLocItem> tempSTLocItemList = [];
    List<String> locCodeList = locString.split(",");
    tempSTLocItemList.addAll(locCodeList.map((e) =>
        StockTakeLocItem(stNum: stNum, locCode: e, status: status)));
    return tempSTLocItemList;
  }

  @override
  void initState() {
    super.initState();
    //temp for not having fetch api from backend
    // List<StockTakeLocItem> locItemList = getSTLocItemList(
    //     widget.stockTakeLocItem?.locCode ?? "",
    //     widget.stockTakeLocItem?.stNum ?? "",
    //     widget.stockTakeLocItem?.status ?? "");
    //
    // List<StockTakeLocItemHolder> list = locItemList
    //     .map((StockTakeLocItem e) => StockTakeLocItemHolder(e))
    //     .toList();
    //
    // _stockTakeStore.addAllLocItem(list);
    _stockTakeStore.fetchHeaderLocData(stNum: widget.stockTakeLocItem?.stNum ?? "");
  }

  @override
  Widget build(BuildContext context) {
    // final StockTakeScanPageArguments? args =
    // ModalRoute
    //     .of(context)!
    //     .settings
    //     .arguments as StockTakeScanPageArguments?;

    final StockTakeScanPageArguments? args = new StockTakeScanPageArguments(widget.stockTakeLocItem?.stNum ?? "");


    return Scaffold(
        appBar: EchoMeAppBar(actionList: [
          IconButton(onPressed: () {
            if (args != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          StockTakeScanDetailPage(
                            arg: args,
                          )));
            }
          }, icon: const Icon(MdiIcons.clipboardList))
        ],),
        body: SizedBox.expand(
          child: Column(children: [
            _getTitle(context),
            _getSearchBar(context),
            _getListBox(context),
          ]),

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
              icon: Icon(Icons.signal_cellular_alt),
              label: 'Refresh',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Complete ',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.eleven_mp),
            //   label: 'Debug',
            // ),
          ],
          onTap: (int index) =>
              _onBottomBarItemTapped(
                  widget.stockTakeLocItem?.stNum ?? "", index),
        ));
  }

  Future<void> _onBottomBarItemTapped(String? stNum, int index) async {
    try {
      if (index == 0) {
        print("refresh");
      } else if (index == 1) {
        print("Complete");
        if (!accessControlStore.hasARChangeRight) throw "No Change Right";
        bool? flag = await DialogHelper.showTwoOptionsDialog(context,
            title: "Confirm to Complete Order?",
            trueOptionText: "Complete",
            falseOptionText: "Cancel");
        if (flag == true) {
          await _completeStockTakeHeader(stNum: stNum) ? _showSnackBar(
              "Complete Successfully") : "";

          // _assetRegistrationScanStore.reset();
        }
      }
    } catch (e) {
      _stockTakeStore.errorStore.setErrorMessage(e.toString());
    }
  }

  Future<bool> _completeStockTakeHeader({String? stNum = ""}) async {
    try {
      _stockTakeStore.completeStockTakeHeader(stNum: stNum ?? "");
      return true;
    } catch (e) {
      return false;
    }
  }

  void _showSnackBar(String? str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str ?? ""),
      ),
    );
  }

  Widget _getTitle(BuildContext ctx) {
    return BodyTitle(
      title: "Stock Take",
      clipTitle: "Hong Kong-DC",
    );
  }

  Widget _getListBox(BuildContext ctx) {
    return Expanded(
      child: Observer(
        builder: (context) {
          var isFetching = _stockTakeStore.isFetching;
          return AppContentBox(
            child: isFetching
                ? const AppLoader()
                : _stockTakeStore.locHeaderList.isEmpty
                ? const Center(child: Text("No Data"))
                : Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: kTextTabBarHeight,
                    child: Container(
                      color: Theme
                          .of(context)
                          .secondaryHeaderColor,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _stockTakeStore.prevPage(
                                  docNum: widget.stockTakeLocItem?.stNum ?? "");
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
                              var total = _stockTakeStore.totalCount;
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Total: ${total}"),
                                  Text(
                                      "Page: ${_stockTakeStore
                                          .currentPage}/${_stockTakeStore
                                          .totalPage} ")
                                ],
                              );
                            }),
                          ),
                          GestureDetector(
                            onTap: () {
                              _stockTakeStore.nextPage(
                                  docNum: widget.stockTakeLocItem?.stNum ?? "");
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
                    builder: (context) =>
                        ListView.builder(
                          itemCount: _stockTakeStore.locHeaderList.length,
                          // itemCount: _store.itemLineUniObjLocList.length,
                          itemBuilder: ((context, index) {
                            final listItem = _stockTakeStore.locHeaderList[index];
                            // final listItem =
                            //     _store.itemLineUniObjLocList[index];
                            return Observer(
                              builder: (context) {
                                var title = listItem.locCode;
                                var subtitle =
                                    "";
                                var status = listItem.status == "" ? "Created" : listItem.status;
                                // ignore: prefer_function_declarations_over_variables
                                // var fx = () => Navigator.pushNamed(
                                //     context, "/stock_take_loc",
                                //     arguments: StockTakeScanPageArguments(
                                //         listItem.orderId,
                                //         item: listItem.item)).then((value) => {
                                //            _store.fetchData(stNum: widget.stockTakeLocItem?.stNum ?? "")
                                //         });
                                var fx = () =>
                                    Navigator.pushNamed(
                                        context, "/stock_take_scan",
                                        arguments:
                                        StockTakeScanPageArguments(
                                            listItem.orderId,
                                            // item: StockTakeItem(),
                                            stockTakeLocHeader: listItem.header))
                                        .then((value) =>
                                    {
                                      _stockTakeStore.fetchData(
                                          stNum:
                                          widget.stockTakeLocItem?.stNum ??
                                              "")
                                    });
                                return StatusListItem(
                                  title: title,
                                  subtitle: subtitle,
                                  status: status,
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

  Color _getColor(StockTakeItemStatus status) {
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

  Widget _getSearchBar(BuildContext ctx) {
    if (widget.stockTakeLocItem?.stNum != null) {
      return Padding(
        padding: const EdgeInsets.all(Dimens.horizontal_padding),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                    "Stock Take Line: " +
                        (widget.stockTakeLocItem?.stNum ?? ""),
                    style: Theme
                        .of(context)
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
        backgroundColor: Theme
            .of(context)
            .cardColor,
        hintText: "Search by Document Number",
        onSearchButtonPressed: (str) {
          if (str != null && str.isNotEmpty) {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) => StockTakeLocNewPage(searchRegNum: str.trim())));
            //
            // Navigator.pushNamed(
            //         context, "/stock_take_loc",
            //         arguments: StockTakeScanPageArguments(
            //             listItem.orderId,
            //             item: listItem.item)).then((value) => {
            //                _store.fetchData(stNum: widget.stockTakeLocItem?.stNum ?? "")
            //             });
          }
        },
      ),
    );
  }
}
