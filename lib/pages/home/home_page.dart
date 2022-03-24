import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/asset_registration/asset_scan_page_arguments.dart';
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
        body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text("Assets Inventory", style: Theme.of(context).textTheme.titleLarge,),
                     IconButton(onPressed: (){
                       Navigator.pushNamed(context, "/asset_inventory");
                     }, icon: Icon(Icons.arrow_forward))
                  ]),
                ),
              ),
            ),
          ),
            SizedBox(
            width: double.maxFinite,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text("Asset Registration", style: Theme.of(context).textTheme.titleLarge,),
                     IconButton(onPressed: (){
                       Navigator.pushNamed(context, "/asset_registration");
                     }, icon: Icon(Icons.arrow_forward))
                  ]),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text("Reader Connection", style: Theme.of(context).textTheme.titleLarge,),
                     IconButton(onPressed: (){
                       Navigator.pushNamed(context, "/sensor_settings");
                     }, icon: Icon(Icons.arrow_forward))
                  ]),
                ),
              ),
            ),
          ),
           SizedBox(
            width: double.maxFinite,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text("Asset Scan", style: Theme.of(context).textTheme.titleLarge,),
                     IconButton(onPressed: (){
                       Navigator.pushNamed(context, "/asset_scan",arguments: AssetScanPageArguments("551358"));
                     }, icon: Icon(Icons.arrow_forward))
                  ]),
                ),
              ),
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                loginFormStore.logout();
              },
              child: Text("logout"),
            ),
          )
        ],
          ),
        ));
  }
}
