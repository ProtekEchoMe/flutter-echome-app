import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_scan_page_arguments.dart';
import 'package:echo_me_mobile/pages/asset_registration/backup/asset_registration_search_page.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_item.dart';
import 'package:echo_me_mobile/stores/asset_return/asset_return_store.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/app_loader.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:echo_me_mobile/widgets/status_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

import 'package:echo_me_mobile/pages/asset_return/asset_return_scan_page_arguments.dart';

class AssetReturnPage extends StatefulWidget {
  final String? searchRegNum;
  AssetReturnPage({Key? key, this.searchRegNum}) : super(key: key);

  @override
  State<AssetReturnPage> createState() => _AssetReturnPageState();
}

class _AssetReturnPageState extends State<AssetReturnPage> {
  final AssetReturnStore _store = getIt<AssetReturnStore>();

  @override
  void initState() {
    super.initState();
    _store.fetchData(rtnNum: widget.searchRegNum ?? "");
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
        ));
  }

  Widget _getTitle(BuildContext ctx) {
    return BodyTitle(
      title: "assetReturn".tr(gender: "asset_return"),
      clipTitle: "Hong Kong-DC",
    );
  }

  Widget _getListBox(BuildContext ctx) {
    return Expanded(
      child: Observer(
        builder: (context) {
          var isFetching = _store.isFetching;
          return AppContentBox(
            child: isFetching
                ? const AppLoader()
                : _store.itemList.isEmpty
                ? Center(child: Text("assetReturn".tr(gender: "page_no_data")))
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
                              _store.prevPage(docNum: widget.searchRegNum ?? "");
                            },
                            child:const SizedBox(
                              width: 40,
                              child: Center(
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Observer(builder: (context) {
                              var total = _store.totalCount;
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("assetReturn".tr(gender: "bottom_bar_total") + ": ${total}"),
                                  Text(
                                      "assetReturn".tr(gender: "bottom_bar_page") + ": ${_store.currentPage}/${_store.totalPage} ")
                                ],
                              );
                            }),
                          ),
                          GestureDetector(
                            onTap: () {
                              _store.nextPage(docNum: widget.searchRegNum ?? "");
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
                      itemCount: _store.itemList.length,
                      itemBuilder: ((context, index) {
                        final listItem = _store.itemList[index];
                        return Observer(
                          builder: (context) {
                            var title = listItem.orderId;
                            var subtitle =
                            listItem.item.shipperCode.toString();
                            var status = listItem.status;
                            // ignore: prefer_function_declarations_over_variables
                            var fx = () => Navigator.pushNamed(
                                context, "/asset_return_scan",
                                arguments: AssetReturnScanPageArguments(
                                    listItem.orderId,  // listItem.orderId
                                    item: listItem.item)
                            ).then((value) => {
                              _store.fetchData(rtnNum: widget.searchRegNum ?? "")
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
    if (widget.searchRegNum != null) {
      return Padding(
        padding: const EdgeInsets.all(Dimens.horizontal_padding),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                    "assetReturn".tr(gender: "search_result_text") + "= " + widget.searchRegNum!,
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
        hintText: "assetReturn".tr(gender: "search_bar_hint"),
        onSearchButtonPressed: (str) {
          if (str != null && str.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        AssetReturnPage(searchRegNum: str.trim())));
          }
        },
      ),
    );
  }

}
