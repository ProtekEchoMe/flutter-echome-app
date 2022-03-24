import 'package:echo_me_mobile/pages/asset_inventory/asset_inventory_page.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_registration_page.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_scan_page.dart';
import 'package:echo_me_mobile/pages/home/home_page.dart';
import 'package:echo_me_mobile/pages/login/forget_password_page.dart';
import 'package:echo_me_mobile/pages/login/login_page.dart';
import 'package:echo_me_mobile/pages/sensor_settings/sensor_settings.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> getMap() {
    return {
      "/login": (_) => LoginPage(),
      "/forget_password": (_) => ForgetPasswordPage(),
      "/home":(_)=> HomePage(),
      "/asset_inventory": (_) => AssetInventoryPage(),
      "/sensor_settings":(_) => SensorSettings(),
      "/asset_registration":(_) => AssetRegistrationPage(),
      "/asset_scan":(_) => AssetScanPage()
    };
  }
}
