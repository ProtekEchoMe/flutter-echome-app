import 'dart:async';

import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/stores/app_version_control/app_version_control_store.dart';
import 'package:echo_me_mobile/utils/permission_helper/permission_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PermissionHelper permissionHelper = PermissionHelper();

  final AppVersionControlStore _appVersionControlStore =
      getIt<AppVersionControlStore>();

  @override
  void initState() {
    super.initState();
    init();
  }

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
          Observer(
            builder: (context) {
              return Text(_appVersionControlStore.message);
            },
          ),
          Observer(
            builder: (context) {
              var x = _appVersionControlStore.versionCheckSuccess;
              if (x == true) {
                Timer(Duration(milliseconds: 100),()=>Navigator.pushReplacementNamed(context, "/home"));
              }
              return SizedBox();
            },
          )
        ],
      )),
    );
  }
}
