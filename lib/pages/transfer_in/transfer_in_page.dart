import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_scan_page_arguments.dart';
import 'package:echo_me_mobile/stores/assest_registration/asset_registration_item.dart';
import 'package:echo_me_mobile/stores/transfer_out/transfer_out_store.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/app_loader.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:echo_me_mobile/widgets/status_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

class TransferInPage extends StatefulWidget {
  final String? toNum;
  TransferInPage({Key? key, this.toNum}) : super(key: key);

  @override
  State<TransferInPage> createState() => _TransferInPageState();
}

class _TransferInPageState extends State<TransferInPage> {
  final TransferOutStore _store = getIt<TransferOutStore>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _store.fetchData(toNum: widget.toNum ?? "");
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
      title: "Transfer In",
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
                                        _store.prevPage();
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
                                        var total = _store.totalCount;
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("Total: ${total}"),
                                            Text(
                                                "Page: ${_store.currentPage}/${_store.totalPage} ")
                                          ],
                                        );
                                      }),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _store.nextPage();
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
                                      var title = listItem.toNum;
                                      var subtitle =
                                          "${listItem.shipType} : ${listItem.shipToLocation}";
                                      var status = listItem.status;
                                      var fx = () => Navigator.pushNamed(
                                              context, "/transfer_out_scan",
                                              arguments:
                                                  TransferOutScanPageArguments(
                                                      toNum:
                                                          listItem.toNum ?? "",
                                                      item: listItem))
                                          .then((value) => {
                                                _store.fetchData(
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
                    builder: (_) => TransferInPage(toNum: str.trim())));
          }
        },
      ),
    );
  }
}
