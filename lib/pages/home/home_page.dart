import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/apis/login/login_api.dart';
import 'package:echo_me_mobile/data/network/dio_base.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/data/sharedpref/shared_preference_helper.dart';
import 'package:echo_me_mobile/data/siteCode/site_code_list.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_scan_page_arguments.dart';
import 'package:echo_me_mobile/pages/home/route_constant.dart';
import 'package:echo_me_mobile/pages/sensor_settings/sensor_settings.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:echo_me_mobile/stores/site_code/site_code_item_store.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:echo_me_mobile/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:ota_update/ota_update.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final loginApi = getIt<LoginApi>();


  int _selectedIndex = 0;
  final LoginFormStore loginFormStore = getIt<LoginFormStore>();
  final SiteCodeItemStore siteCodeStore = getIt<SiteCodeItemStore>();
  final AccessControlStore accessControlStore = getIt<AccessControlStore>();

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

  @override
  void initState() {
    super.initState();
    loginFormStore.setupValidations();
    siteCodeStore.fetchData().then(
            (value) => _showSiteSelectionDialog(context, accessControlStore.accessControlledSiteNameList));
        // .then(
        //     (value) => loginFormStore.changeSite(siteCode: siteCodeStore.siteCodeNameList[0]!));
    
    // loginFormStore.changeSite(siteCode: SiteCodeList.getList()[0]);
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   _showMyDialog(context);
    // });
    // tryUpdate();
    // print("");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loginFormStore.dispose();
  }

  void _onItemTapped(int index) {
    Navigator.pushNamed(context, "/debug");
    // setState(() {
    //   _selectedIndex = index;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: EchoMeAppBar(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
        ),
        body: Column(
          children: [
            BodyTitle(
              title: "EchoMe Main Page",
              clipTitle: "Hong Kong-DC",
              allowSwitchSite: true,
            ),
            Expanded(
              child: AppContentBox(
                child: SingleChildScrollView(
                  child: _getPageContent(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getRouteButtonList(BuildContext context) {
    // return RouteConstant.getRouteList.map((e) {
    return accessControlStore.modulesObjectViewList.map((e) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, e.routeName),
        child: SizedBox(
          height: 75,
          width: double.maxFinite,
          child: ListItem(
            leading: Icon(
              e.icons,
              color: Colors.black,
              size: 50,
            ),
            title: e.title,
            description: e.description,
            trailing: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _getPageContent(BuildContext context) {
    return _selectedIndex == 0
        ? Column(
            children: [
              ..._getRouteButtonList(context),
              GestureDetector(
                onTap: () => loginFormStore.logout(),
                child: SizedBox(
                  height: 75,
                  child: ListItem(
                    leading: const Icon(
                      MdiIcons.logout,
                      color: Colors.black,
                      size: 50,
                    ),
                    title: "Logout",
                    description: "Logout your account",
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          )
        : SensorSettings();
  }
}
