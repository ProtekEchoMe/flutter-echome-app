import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/data/siteCode/site_code_list.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:echo_me_mobile/stores/site_code/site_code_item_store.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';

class BodyTitle extends StatelessWidget {
  final LoginFormStore loginFormStore = getIt<LoginFormStore>();
  final SiteCodeItemStore siteCodeStore = getIt<SiteCodeItemStore>();
  final AccessControlStore accessControlStore = getIt<AccessControlStore>();
  String? title;
  String? clipTitle;
  bool allowSwitchSite;
  BodyTitle({Key? key, this.title, this.clipTitle, this.allowSwitchSite = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.horizontal_padding),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: _getTitle(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: (){if(allowSwitchSite){
                  void onClickFunction(e) async {
                    if (e != loginFormStore.siteCode) {
                      await loginFormStore.changeSite(siteCode: e!);
                    }
                  }
                  siteCodeStore.fetchData(limit: 0).then(
                          (value) => DialogHelper.listSelectionDialogWithAutoCompleteBar(context,
                          accessControlStore.accessControlledSiteNameList, onClickFunction, willPop: true));

                  // _showSiteSelectionDialog(context, accessControlStore.accessControlledSiteNameList);
                }
                },
                child: Container(
                  width: 130,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Observer(
                    builder: (context) {
                      if (loginFormStore.isChangingSite) {
                        return const Text("Loading");
                      }
                      return Text(loginFormStore.siteCode ?? "");
                    },
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Switch your site"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // ...SiteCodeList.getList().map((e){
                ...siteCodeStore.siteCodeNameList.map((e){
                   return GestureDetector(
                     onTap: ()async{
                       if(e != loginFormStore.siteCode){
                          await loginFormStore.changeSite(siteCode: e!);
                       }
                        Navigator.of(context).pop();
                     },
                     child: ListTile(
                      title: Text(e!),
                                     ),
                   );
                }).toList()
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSiteSelectionDialog(BuildContext context, ObservableList<String?> siteNameList) async {
    print("called");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text("Choose the site"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  // ...SiteCodeList.getList().map((e
                  //...siteCodeStore.siteCodeNameList.map((e)
                  ...siteNameList.map((e) {
                    return GestureDetector(
                      onTap: () async {
                        if (e != loginFormStore.siteCode) {
                          await loginFormStore.changeSite(siteCode: e!);
                        }
                        Navigator.of(context).pop();
                      },
                      child: ListTile(
                        title: Text(e!),
                      ),
                    );
                  }).toList()
                ],
              ),
            ),
            actions: <Widget>[],
          ),
        );
      },
    );
  }

  Widget _getTitle(BuildContext context) {
    if (title == null || title!.isEmpty) {
      return const SizedBox(
        width: 1,
        height: 1,
      );
    }
    return Text(
      title!,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 35),
    );
  }
}
