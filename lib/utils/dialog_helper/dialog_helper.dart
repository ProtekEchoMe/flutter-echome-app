import 'package:flutter/material.dart';

class DialogHelper {
  static Future<void> showCustomDialog(BuildContext context,
      {
        List<Widget> widgetList = const [],
        List<Widget> actionList = const [],
      }) async {
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
                children: widgetList,
              ),
            ),
            actions: actionList,
          ),
        );
      },
    );
  }
}
