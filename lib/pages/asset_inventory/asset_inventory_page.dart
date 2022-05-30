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
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import '../../stores/asset_inventory/asset_inventory_store.dart';

class AssetInventoryPage extends StatefulWidget {
  final String? assetCode;
  final String? skuCode;
  AssetInventoryPage({Key? key, this.assetCode, this.skuCode}) : super(key: key);

  final AccessControlStore accessControlStore = getIt<AccessControlStore>();

  @override
  State<AssetInventoryPage> createState() => _AssetInventoryPageState();
}

class _AssetInventoryPageState extends State<AssetInventoryPage> {
  AssetInventoryStore _store = getIt<AssetInventoryStore>();
  LoginFormStore _loginFormStore = getIt<LoginFormStore>();

  @override
  void initState() {
    super.initState();
    _store.fetchData(
        assetCode: widget.assetCode ?? "", skuCode: widget.skuCode ?? "", siteCode: _loginFormStore.siteCode ?? "");
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
      title: "Asset Inventory",
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
                                        _store.prevPage(
                                          assetCode: widget.assetCode ?? "", skuCode: widget.skuCode ?? "", siteCode: _loginFormStore.siteCode ?? ""
                                        );
                                      },
                                      child: SizedBox(
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
                                        _store.nextPage(
                                          assetCode: widget.assetCode ?? "", skuCode: widget.skuCode ?? "", siteCode: _loginFormStore.siteCode ?? ""
                                        );
                                      },
                                      child: SizedBox(
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
                                  return Observer(
                                    builder: (context) {
                                      final listItem = _store.itemList[index];
                                      var assetCode = listItem.assetCode;
                                      var skuCode = listItem.skuCode;
                                      var title = "$skuCode/$assetCode";
                                      var subtitle =
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

  Widget _getSearchBar(BuildContext ctx) {
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
}
