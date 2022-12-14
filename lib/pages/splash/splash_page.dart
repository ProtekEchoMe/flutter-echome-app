import 'dart:async';

import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/sharedpref/constants/preferences.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/stock_take/stock_take_scan_page_arguments.dart';
import 'package:echo_me_mobile/stores/app_version_control/app_version_control_store.dart';
import 'package:echo_me_mobile/stores/reader_connection/reader_connection_store.dart';
import 'package:echo_me_mobile/utils/permission_helper/permission_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

//testing
import 'package:echo_me_mobile/data/sharedpref/shared_preference_helper.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';

import '../../models/asset_registration/registration_item.dart';
import '../asset_registration/asset_scan_page_arguments.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PermissionHelper permissionHelper = PermissionHelper();

  final AppVersionControlStore _appVersionControlStore =
      getIt<AppVersionControlStore>();

  final SharedPreferenceHelper _sharedPreferenceHelper =
      getIt<SharedPreferenceHelper>();

  final ReaderConnectionStore readerConnectionStore = getIt<ReaderConnectionStore>();

  @override
  void initState() {
    super.initState();

    init();
    readerConnectionStore.connectAIReader();
  }

  void initVersionControlServer() {}

  Future<void> init() async {
    var result = await _appVersionControlStore.getAppPermission();
    if (result) await _appVersionControlStore.updateIfNeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Splash Page"),
          Text("App Version ${_appVersionControlStore.appVerion}"),
          Text(
              "${_sharedPreferenceHelper.defaultVersionControlDomainName}"),
          Observer(
            builder: (context) {
              return Text(_appVersionControlStore.message);
            },
          ),
          Observer(
            builder: (context) {
              var x = _appVersionControlStore.versionCheckSuccess;
              if (x == true) { // login Page entry
                Timer(Duration(milliseconds: 100),()=>Navigator.pushReplacementNamed(context, "/login"));
              }
              return SizedBox();
            },
          ),
          TextButton(
            onPressed: () => DialogHelper.listSelectionDialogWithAutoCompleteBar(
                context, [...Endpoints.versionControlDomainMap.keys.toList()],
                (key) async {
              String domainName = Endpoints.versionControlDomainMap[key];
              _sharedPreferenceHelper
                  .changeDefaultVersionControlDomainName(key);
              await _appVersionControlStore.updateIfNeed();
            }),
            child: const Text(''),
          ),
          // TextButton(
          //   onPressed: () {
          //     print("1");
          //           var fx = () => Navigator.pushNamed(
          //               context, "/asset_scan_extend",
          //               arguments: AssetScanPageArguments(
          //                   "Mixson_AR3",
          //                   item: RegistrationItem()));
          //           fx();
          //
          //     }
          //       ,
          //   child: const Text(''),
          // ),
          // TextButton(
          //   onPressed: () {
          //     print("1");
          //     var fx = () => Navigator.pushNamed(
          //         context, "/stock_take_scan",
          //         arguments: StockTakeScanPageArguments(
          //             "Mixson_AR3",
          //             ));
          //     fx();
          //
          //   }
          //   ,
          //   child: const Text('stockTake'),
          // ),
        ],
      )),
    );
  }
}
