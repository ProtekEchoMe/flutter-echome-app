import 'package:flutter/material.dart';

class DialogHelper {
  static Future<bool?> showCustomDialog(BuildContext context,
      {
        List<Widget> widgetList = const [],
        List<Widget> actionList = const [],
        String title = ""
      }) async {
    print("called");
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
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

  static Future<bool?> showTwoOptionsDialog(BuildContext context,
      {
        String title = "",
        String trueOptionText = "",
        String falseOptionText = ""
      }) async {
    print("called");
    List<Widget> widgetList = [Text(title)];
    List<Widget> actionList = [
      TextButton(
        child: Text(trueOptionText),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      )
      ,
      TextButton(
        child: Text(falseOptionText),
        onPressed: () {
          Navigator.of(context).pop(false);
        },
      )
    ];

    return showDialog<bool?>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
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

  static Future<void> showSnackBar(BuildContext context,
  {
    String str = "",
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str ?? ""),
      ),
    );
  }
}
