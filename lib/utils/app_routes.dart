import 'package:echo_me_mobile/pages/asset_inventory/asset_inventory_page.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_registration_page.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_scan_page.dart';
import 'package:echo_me_mobile/pages/asset_return/asset_return_page.dart';
import 'package:echo_me_mobile/pages/asset_return/asset_return_scan_page.dart';
import 'package:echo_me_mobile/pages/debug_page/debug_page.dart';
import 'package:echo_me_mobile/pages/home/home_page.dart';
import 'package:echo_me_mobile/pages/login/forget_password_page.dart';
import 'package:echo_me_mobile/pages/login/login_page.dart';
import 'package:echo_me_mobile/pages/sensor_settings/sensor_settings.dart';
import 'package:echo_me_mobile/pages/splash/splash_page.dart';
import 'package:echo_me_mobile/pages/transfer_in/transfer_in_page.dart';
import 'package:echo_me_mobile/pages/transfer_in/transfer_in_scan_page.dart';
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_page.dart';
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_scan_page.dart';
import 'package:echo_me_mobile/pages/stock_take/stock_take_page.dart';
// import 'package:echo_me_mobile/pages/stock_take/stock_take_page_locNew.dart';
import 'package:echo_me_mobile/pages/stock_take/stock_take_page_locNewFetch.dart';
import 'package:echo_me_mobile/pages/stock_take/stock_take_scan_page.dart';
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
      "/asset_scan":(_) => AssetScanPage(),
      "/asset_inventory_detail":(_) => AssetInventoryPage(),
      "/asset_return": (_) => AssetReturnPage(),
      "/asset_return_scan": (_) => AssetReturnScanPage(),
      "/transfer_out":(_) => TransferOutPage(),
      "/transfer_out_scan": (_) => TransferOutScanPage(),
      "/transfer_in":(_)=> TransferInPage(),
      "/transfer_in_scan":(_)=> TransferInScanPage(),
      "/stock_take": (_) =>StockTakePage(),
      "/stock_take_loc": (_) =>StockTakeLocNewPage(),
      // "/stock_take_loc_fetch": (_) =>StockTakeLocNew(),
      "/stock_take_scan": (_) =>StockTakeScanPage(),
      "/splash":(_)=>SplashPage(),
      "/debug":(_)=>DebugPage(),

    };
  }
}
