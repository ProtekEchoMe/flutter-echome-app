import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/stores/assest_registration/asset_registration_item.dart';
import 'package:echo_me_mobile/stores/assest_registration/asset_registration_store.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
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
    return Padding(
      padding: const EdgeInsets.all(Dimens.horizontal_padding),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: Text(
                  "Asset Register",
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

  Widget _getListBox(BuildContext ctx) {
    return Expanded(
      child: Observer(builder: (context) {
        return _store.isFetching
            ? Center(
                child: SpinKitChasingDots(
                color: Colors.grey,
                size: 50.0,
              ))
            : _getListBoxList(context);
      }),
    );
  }

  Widget _getListBoxList(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.horizontal_padding),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(20),
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
          padding: const EdgeInsets.all(10.0),
          child: Observer(
              builder: (context) => ListView.builder(
                  itemCount: _store.itemList.length,
                  itemBuilder: ((context, index) {
                    final item = _store.itemList[index];
                    return Observer(builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          child: ListTile(
                            leading: SizedBox(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.description),
                              ],
                            )),
                            title: Text(item.orderId),
                            subtitle: Text(item.supplierName),
                            trailing: SizedBox(
                              width: 130,
                              height: double.maxFinite,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        height: 30,
                                        child: FittedBox(
                                            child: Text(
                                          item.status,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            Navigator.pushNamed(context, "/asset_scan",arguments: AssetScanPageArguments(item.orderId, item: item.item));
                                          },
                                          icon: Icon(Icons.arrow_forward)),
                                    )
                                  ]),
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    });
                  }))),
        ),
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
    return const Padding(
      padding: EdgeInsets.all(Dimens.horizontal_padding),
      child: SizedBox(
        width: double.maxFinite,
        child: OutlineSearchBar(
          hintText: "Search by Order ID",
        ),
      ),
    );
  }
}
