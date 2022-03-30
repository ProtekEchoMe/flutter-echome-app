import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_scan_page_arguments.dart';
import 'package:echo_me_mobile/stores/assest_registration/asset_registration_item.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AssetRegistrationSearchPage extends StatefulWidget {
  final String searchDocNum;
  AssetRegistrationSearchPage({Key? key, required this.searchDocNum})
      : super(key: key);

  @override
  State<AssetRegistrationSearchPage> createState() =>
      _AssetRegistrationSearchPageState();
}

class _AssetRegistrationSearchPageState
    extends State<AssetRegistrationSearchPage> {

  bool isFetching = false;
  Repository repository = getIt<Repository>();
  List<AssetRegistrationItem>  dataList = [];
  
  Future<void> fetchData() async {
    isFetching = true;
    try{
      var data = await repository.getAssetRegistration(docNumber: widget.searchDocNum);
      List<RegistrationItem> itemList = data.itemList;
      List<AssetRegistrationItem> list = itemList.map((RegistrationItem e) =>AssetRegistrationItem(e)).toList();
      dataList.addAll(list);
    }catch(e){
      print(e);
    }finally{
      print("finally");
      isFetching = false;
      print(dataList);
      print(isFetching);
      setState(() {
        
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchoMeAppBar(titleText: "Search Result"),
      body: SizedBox.expand(
        child: Column(children: [
          _getTitle(context),
          _getSubTitle(context),
          _getListBox(context)
        ]),
      ),
    );
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
                  "Searching",
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

  Widget _getSubTitle(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(Dimens.horizontal_padding),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                    "Seraching for Document Number = " + widget.searchDocNum,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

    Widget _getListBox(BuildContext ctx) {
      print(isFetching);
    return Expanded(
      child: Builder(builder: (context) {
        return isFetching
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
                  itemCount: dataList.length,
                  itemBuilder: ((context, index) {
                    final item = dataList[index];
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
}
