import 'package:echo_me_mobile/data/network/apis/login/login_api.dart';
import 'package:echo_me_mobile/data/siteCode/siteCodeList.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_scan_page_arguments.dart';
import 'package:echo_me_mobile/pages/sensor_settings/sensor_settings.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/body_title.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:echo_me_mobile/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final loginApi = getIt<LoginApi>();

  int _selectedIndex = 0;
  final LoginFormStore loginFormStore = getIt<LoginFormStore>();

  @override
  void initState() {
    super.initState();
    loginFormStore.setupValidations();
    loginFormStore.changeSite(siteCode: SiteCodeList.getList()[0]);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loginFormStore.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _getPageContent(BuildContext context) {
    return _selectedIndex == 0
        ? Column(
            children: [
              SizedBox(
                height: 75,
                child: ListItem(
                  leading: const Icon(
                    MdiIcons.accessPointPlus,
                    color: Colors.black,
                    size: 50,
                  ),
                  title: "Assets Registration",
                  description: "Add new asset",
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/asset_registration");
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 75,
                child: ListItem(
                  leading: const Icon(
                    MdiIcons.warehouse,
                    color: Colors.black,
                    size: 50,
                  ),
                  title: "Assets Inventory",
                  description: "Check your inventory",
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/asset_inventory");
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 75,
                child: ListItem(
                  leading: const Icon(
                    MdiIcons.inboxArrowDown,
                    color: Colors.black,
                    size: 50,
                  ),
                  title: "Transfer In",
                  description: "Receive from other site",
                  trailing: GestureDetector(
                    onTap: () {
                       Navigator.pushNamed(context, "/transfer_in");
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 75,
                child: ListItem(
                  leading: const Icon(
                    MdiIcons.inboxArrowUp,
                    color: Colors.black,
                    size: 50,
                  ),
                  title: "Transfer Out",
                  description: "Send to other site",
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/transfer_out");
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 75,
                child: ListItem(
                  leading: const Icon(
                    MdiIcons.trashCan,
                    color: Colors.black,
                    size: 50,
                  ),
                  title: "Assets Disposal",
                  description: "Disposal and write-off",
                  trailing: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 75,
                child: ListItem(
                  leading: const Icon(
                    MdiIcons.fileDocumentMultipleOutline,
                    color: Colors.black,
                    size: 50,
                  ),
                  title: "Stock Take",
                  description: "Count your asset",
                  trailing: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 75,
                child: ListItem(
                  leading: const Icon(
                    MdiIcons.logout,
                    color: Colors.black,
                    size: 50,
                  ),
                  title: "Logout",
                  description: "Logout your account",
                  trailing: GestureDetector(
                    onTap: () {
                      loginFormStore.logout();
                    },
                    child: const Icon(
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
