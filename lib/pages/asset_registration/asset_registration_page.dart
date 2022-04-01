import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_registration_search_page.dart';
import 'package:echo_me_mobile/stores/assest_registration/asset_registration_item.dart';
import 'package:echo_me_mobile/stores/assest_registration/asset_registration_store.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/app_loader.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:echo_me_mobile/widgets/status_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

import 'asset_scan_page_arguments.dart';

class AssetRegistrationPage extends StatefulWidget {
  AssetRegistrationPage({Key? key}) : super(key: key);

  @override
  State<AssetRegistrationPage> createState() => _AssetRegistrationPageState();
}

class _AssetRegistrationPageState extends State<AssetRegistrationPage> {
  AssetRegistrationStore _store = getIt<AssetRegistrationStore>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _store.fetchData();
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
      title: "Asset Register",
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
                                      onTap: () {},
                                      child: SizedBox(
                                        width: 40,
                                        child: Center(
                                          child: Icon(Icons.arrow_back),
                                        ),
                                      ),
                                    ),
                                    Text("1/1"),
                                    GestureDetector(
                                      onTap: () {},
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
                                itemCount: _store.itemList.length + 20,
                                itemBuilder: ((context, index) {
                                  final listItem = _store.itemList[0];
                                  return Observer(
                                    builder: (context) {
                                      var title = listItem.orderId;
                                      var subtitle =
                                          listItem.item.shipperCode.toString();
                                      var status = listItem.status;
                                      // ignore: prefer_function_declarations_over_variables
                                      var fx = () => Navigator.pushNamed(
                                          context, "/asset_scan",
                                          arguments: AssetScanPageArguments(
                                              listItem.orderId,
                                              item: listItem.item));
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
    return Padding(
      padding: const EdgeInsets.all(Dimens.horizontal_padding),
      child: OutlineSearchBar(
        // initText: "INIT TEXT",
        backgroundColor: Theme.of(context).cardColor,
        hintText: "Search by Document Number",
        onSearchButtonPressed: (str) {
          if (str != null && str.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        AssetRegistrationSearchPage(searchDocNum: str)));
          }
        },
      ),
    );
  }
}
