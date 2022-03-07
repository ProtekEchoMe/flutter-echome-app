import 'package:echo_me_mobile/pages/home/home_page.dart';
import 'package:echo_me_mobile/pages/login/forget_password_page.dart';
import 'package:echo_me_mobile/pages/login/login_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> getMap() {
    return {
      "/login": (_) => LoginPage(),
      "/forget_password": (_) => ForgetPasswordPage(),
      "/home":(_)=> HomePage()
    };
  }
}
