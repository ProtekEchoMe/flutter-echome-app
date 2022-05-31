import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/backup/asset_registration_search_page.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_scan_page_arguments.dart';
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_detail_page.dart';
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_scan_page_arguments.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_item.dart';
import 'package:echo_me_mobile/stores/site_code/site_code_item_store.dart';
import 'package:echo_me_mobile/stores/transfer_out/transfer_out_store.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/app_loader.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:echo_me_mobile/widgets/status_list_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

class TransferOutPage extends StatefulWidget {
  final String? toNum;

  TransferOutPage({Key? key, this.toNum}) : super(key: key);

  @override
  State<TransferOutPage> createState() => _TransferOutPageState();
}

class _TransferOutPageState extends State<TransferOutPage> {
  final TransferOutStore _transferOutStore = getIt<TransferOutStore>();
  final AccessControlStore _accessControlStore = getIt<AccessControlStore>();
  final SiteCodeItemStore _siteCodeItemStore = getIt<SiteCodeItemStore>();

  String? selectItem = "";
  int selectedIndex = 0;
  double _kPickerSheetHeight = 216.0;


  @override
  void initState() {
    // TODO: Access Control SCAN Right shall be added to TransferOut Logic
    super.initState();
    _transferOutStore.fetchData(toNum: widget.toNum ?? "");
    selectItem = _siteCodeItemStore.siteCodeMap.keys.first; // for  no onSelectedItemChanged
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EchoMeAppBar(),
        body: SizedBox.expand(
          child: Column(children: [
            _getTitle(context),
            _getSearchBar(context),
            _getListBox(context),
          ]),
        ),
      floatingActionButton:
      Container(
        height: 50,
        width: 50,
        child: FittedBox(
            child: FloatingActionButton( //TODO: Direct Transfer Out Create API
          onPressed: () {
            showCupertinoModalPopup<void>(
                context: context, builder: (BuildContext context){
              return _buildBottomPicker2(
                  _buildCupertinoPicker(_accessControlStore.getAccessControlledTOSiteNameList));
            });
          },
          child: const Icon(Icons.add),
              // foregroundColor:  Colors.orange[700]!.withOpacity(0.5),
            backgroundColor: Colors.orange[700]!.withOpacity(0.9),
      ))),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat

    );
  }

  Widget _buildBottomPicker2(Widget picker) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: Color(0xffffffff),
            border: Border(
              bottom: BorderSide(
                color: Color(0xff999999),
                width: 0.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                CupertinoButton(
                  child: const Text('Cancel'),
                  onPressed: () {Navigator.of(context).pop();},
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                ),
                  CupertinoButton(
                  child: const Text('Confirm'),
                  onPressed: () {
                    _transferOutStore.createTransferOutHeaderItem(
                        toSite: _siteCodeItemStore.siteCodeMap[selectItem]!.id).then((_) {
                        Navigator.pushNamed(
                            context, "/transfer_out_scan",
                            arguments:
                            TransferOutScanPageArguments(
                                toNum:
                                _transferOutStore.directTOResponse!.toNum ?? "",
                                item: _transferOutStore.directTOResponse))
                            .then((value) => {
                          _transferOutStore.fetchData(
                              toNum: widget.toNum ?? "")
                        });
                    });
                      Navigator.of(context).pop();
                    },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ))
              ,
            ],
          ),
        ),
        Container(
          height: 320.0,
          color: Color(0xfff7f7f7),
          child: picker
          /* the rest of the picker */
          ,
        )
      ],
    );
  }

  Widget _buildCupertinoPicker(List<String?> itemList){
    return Container(
      child: CupertinoPicker(
        magnification: 1.1,
        backgroundColor: Colors.white,
        itemExtent: 50, //height of each item
        looping: true,
        children: itemList.map((item)=> Center(
          child: Text(item!,
            style: TextStyle(fontSize: 20),),
        )).toList(),
        onSelectedItemChanged: (index) {
          // setState(() => selectedIndex = index);
          // selectItem = itemList[selectedIndex];
          selectedIndex = index;
          selectItem = itemList[selectedIndex];
        },
      ),
    );

  }



  Widget _getTitle(BuildContext ctx) {
    return BodyTitle(
      title: "Transfer Out",
      clipTitle: "Hong Kong-DC",
    );
  }

  Widget _getListBox(BuildContext ctx) {
    return Expanded(
      child: Observer(
        builder: (context) {
          var isFetching = _transferOutStore.isFetching;
          return AppContentBox(
            child: isFetching
                ? const AppLoader()
                : _transferOutStore.itemList.isEmpty
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
                                        _transferOutStore.prevPage();
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
                                        var total = _transferOutStore.totalCount;
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("Total: ${total}"),
                                            Text(
                                                "          Page: ${_transferOutStore.currentPage}/${_transferOutStore.totalPage} ")
                                          ],
                                        );
                                      }),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _transferOutStore.nextPage();
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
                                itemCount: _transferOutStore.itemList.length,
                                itemBuilder: ((context, index) {
                                  final listItem = _transferOutStore.itemList[index];
                                  return Observer(
                                    builder: (context) {
                                      var title = listItem.toNum;
                                      var subtitle =
                                          "${listItem.shipType} : ${listItem.shipToLocation}";
                                      var status = listItem.status;
                                      // ignore: prefer_function_declarations_over_variables
                                      // var fx = () => Navigator.pushNamed(
                                      //     context, "/asset_scan",
                                      //     arguments: AssetScanPageArguments(
                                      //         listItem.toNum.toString(),
                                      //         item: listItem)).then((value) => {
                                      //            _store.fetchData(docNum: widget.toNum ?? "")
                                      //         });
                                      // ignore: prefer_function_declarations_over_variables
                                      var fx = () => Navigator.pushNamed(
                                              context, "/transfer_out_scan",
                                              arguments:
                                                  TransferOutScanPageArguments(
                                                      toNum:
                                                          listItem.toNum ?? "",
                                                      item: listItem))
                                          .then((value) => {
                                                _transferOutStore.fetchData(
                                                    toNum: widget.toNum ?? "")
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

  Widget _getSearchBar(BuildContext ctx) {
    if (widget.toNum != null) {
      return Padding(
        padding: const EdgeInsets.all(Dimens.horizontal_padding),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                    "Searching for Transfer Out Number = " + widget.toNum!,
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
        backgroundColor: Theme.of(context).cardColor,
        hintText: "Search by Transfer Out Number",
        onSearchButtonPressed: (str) {
          if (str != null && str.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => TransferOutPage(toNum: str.trim())));
          }
        },
      ),
    );
  }
}
