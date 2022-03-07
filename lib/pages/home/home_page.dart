import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LoginFormStore loginFormStore = getIt<LoginFormStore>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home Page")),
        body: Center(
            child: RaisedButton(
          onPressed: () {
            loginFormStore.logout();
          },
          child: Text("logout"),
        )));
  }
}
