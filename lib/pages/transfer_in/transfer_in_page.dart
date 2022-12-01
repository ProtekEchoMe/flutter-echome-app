import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/transfer_in/transfer_in_scan_page_arguments.dart';
// import 'package:echo_me_mobile/pages/transfer_out/transfer_in_scan_page_arguments.dart';
import 'package:echo_me_mobile/stores/transfer_in/transfer_in_store.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:echo_me_mobile/stores/site_code/site_code_item_store.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/app_loader.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:echo_me_mobile/widgets/status_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';

class TransferInPage extends StatefulWidget {
  final String? tiNum;
  const TransferInPage({Key? key, this.tiNum}) : super(key: key);

  @override
  State<TransferInPage> createState() => _TransferInPageState();
}

class _TransferInPageState extends State<TransferInPage> {
  final TransferInStore _transferInStore = getIt<TransferInStore>();
  final AccessControlStore _accessControlStore = getIt<AccessControlStore>();
  final SiteCodeItemStore _siteCodeItemStore = getIt<SiteCodeItemStore>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _transferInStore.fetchData(tiNum: widget.tiNum ?? "");
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
                  // onPressed: () {
                  //   showCupertinoModalPopup<void>(
                  //       context: context, builder: (BuildContext context){
                  //     return _buildBottomPicker2(
                  //         _buildCupertinoPicker(_accessControlStore.getAccessControlledTOSiteNameList));
                  //   });
                  // },
                  onPressed: () {
                    void onClickFunction(String selectedDomainKey) {
                      _transferInStore.createTransferInHeaderItem(
                          tiSite: _siteCodeItemStore.siteCodeMap.containsKey(selectedDomainKey)?
                          _siteCodeItemStore.siteCodeMap[selectedDomainKey]!.id: 0).then((_) {
                        Navigator.pushNamed(
                            context, "/transfer_in_scan_extend",
                            arguments:
                            TransferInScanPageArguments(
                                tiNum:
                                _transferInStore.directTIResponse!.tiNum ?? "",
                                item: _transferInStore.directTIResponse))
                            .then((value) => {
                          _transferInStore.fetchData(
                              tiNum: widget.tiNum ?? "")
                        });
                      });
                    }
                    DialogHelper.listSelectionDialogWithAutoCompleteBar(
                        context, List<String?>.from([..._accessControlStore.getAccessControlledTOSiteNameList, "0"]), onClickFunction,
                        willPop: true,
                        text: "transferIn".tr(gender: "direct_choose_site_text"),
                        totalText: "utilDialog".tr(gender: "total"));

                    // showCupertinoModalPopup<void>(
                    //     context: context, builder: (BuildContext context){
                    //   return _buildBottomPicker2(
                    //       _buildCupertinoPicker(_accessControlStore.getAccessControlledTOSiteNameList));
                    // });
                  },
                  child: const Icon(Icons.add),
                  // foregroundColor:  Colors.orange[700]!.withOpacity(0.5),
                  backgroundColor: Colors.orange[700]!.withOpacity(0.9),
                ))),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat
    );
  }

  Widget _getTitle(BuildContext ctx) {
    return BodyTitle(
      title: "transferIn".tr(gender: "transfer_in"),
      clipTitle: "Hong Kong-DC",
    );
  }

  Widget _getListBox(BuildContext ctx) {
    return Expanded(
      child: Observer(
        builder: (context) {
          var isFetching = _transferInStore.isFetching;
          return AppContentBox(
            child: isFetching
                ? const AppLoader()
                : _transferInStore.itemList.isEmpty
                    ? Center(child: Text("transferIn".tr(gender: "page_no_data")))
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
                                        _transferInStore.prevPage(tiNum: widget.tiNum ?? "");
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
                                        var total = _transferInStore.totalCount;
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("transferIn".tr(gender: "bottom_bar_total") + ": ${total}"),
                                            Text(
                                                "          " + "transferIn".tr(gender: "bottom_bar_page")
                                                    + ": ${_transferInStore.currentPage}/${_transferInStore.totalPage} ")
                                          ],
                                        );
                                      }),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _transferInStore.nextPage(tiNum: widget.tiNum ?? "");
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
                                itemCount: _transferInStore.itemList.length,
                                itemBuilder: ((context, index) {
                                  final listItem = _transferInStore.itemList[index];
                                  return Observer(
                                    builder: (context) {
                                      var title = listItem.tiNum;
                                      var subtitle =
                                          "${listItem.shipType} : ${listItem.shipToLocation}";
                                      var status = listItem.status;
                                      var fx = () => Navigator.pushNamed(
                                              context, "/transfer_in_scan_extend",
                                              arguments:
                                                  TransferInScanPageArguments(
                                                      tiNum:
                                                          listItem.tiNum ?? "",
                                                      item: listItem))
                                          .then((value) => {
                                                _transferInStore.fetchData(
                                                    tiNum: widget.tiNum ?? "")
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

  Widget _getSearchBar(BuildContext ctx) {
    if (widget.tiNum != null) {
      return Padding(
        padding: const EdgeInsets.all(Dimens.horizontal_padding),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                    "transferIn".tr(gender: "search_bar_hint") +
                        "= " + widget.tiNum!,
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
        hintText: "transferIn".tr(gender: "search_bar_hint"),
        onSearchButtonPressed: (str) {
          if (str.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => TransferInPage(tiNum: str.trim())));
          }
        },
      ),
    );
  }
}
