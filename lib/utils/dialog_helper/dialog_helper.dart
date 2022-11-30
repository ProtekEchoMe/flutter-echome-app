import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:echo_me_mobile/utils/dialog_helper/auto_complete_searchbar.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';


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

  static Future<bool?> showErrorDialogBox(BuildContext context,
      {
        String errorMsg = "",
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
                children: [Text(errorMsg),]
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  // _addMockEquipmentIdCaseOne();
                  Navigator.of(context).pop();
                },
              )
              ,
            ],
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

  static Future<bool?> showTwoOptionsFilterDialog(BuildContext context, Function onTrueFunction,
      {
        List<Widget> widgetList = const [],
        String trueOptionText = "",
        String falseOptionText = "",
      }) async {
    print("called");
    // List<Widget> widgetList = inputWidgetList;
    List<Widget> actionList = [
      TextButton(
        child: Text(trueOptionText),
        onPressed: () {
          onTrueFunction();
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

  static Future<bool?> showTwoOptionsCompleteWarningDialog(BuildContext context,
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
    String? str = "",
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str ?? ""),
      ),
    );
  }

  static Future<void> listSelectionDialogWithAutoCompleteBar(BuildContext context, List<String?> inputList, Function onTapFunction, {bool willPop = false, text = "Choose the site", String totalText = "Total"}) async {
    print("called");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => willPop,
          child: AlertDialog(
            title: Text(text),
            content:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children:[
                  AutocompleteBasicExample(inputList: List<String>.from(inputList), onClickFunction: onTapFunction,),
                  ConstrainedBox(
                      constraints: const BoxConstraints( maxHeight: 200.0),
                        child: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              // ...SiteCodeList.getList().map((e
                              //...siteCodeStore.siteCodeNameList.map((e)
                              ...inputList.map((e) {
                                return GestureDetector(
                                  onTap: () async {
                                      onTapFunction(e);
                                    Navigator.of(context).pop();
                                  },
                                  child: ListTile(
                                    title: Text(e!),
                                  ),
                                );
                              }).toList()
                            ],
                          ),
                        )),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment : CrossAxisAlignment.center,
                      textDirection: TextDirection.rtl,
                      children: <Widget>[Text(totalText + ": ${inputList.length}")])
                ]
            ),
                        actions: <Widget>[],
          ),
        );
      },
    );
  }

  static void stackDialog({
    required AlignmentGeometry alignment,
    required String tag,
    required List<String> rfidList,
    double width = double.infinity,
    double height = double.infinity,
  }) async {
    SmartDialog.show(
        tag: tag,
        alignment: alignment,
        builder: (_) {

          return Container(
              width: width,
              height: height,
              color: Colors.orange,
              alignment: Alignment.center,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...rfidList.map((rfid) => Container(
                      width: width,
                      height: 50,
                      // height: height/rfidList.length,
                      color: Colors.white,
                      // alignment: Alignment.centerRight,
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(onPressed: () => print(rfid.toString()), child: Text(rfid.toString())),
                        ],
                      ),
                    )).toList(),
                  ]));
        }
    );
    await Future.delayed(Duration(milliseconds: 500));
  }

  static void showStackDialog({
    required AlignmentGeometry alignment,
    required String tag,
    required List<String> rfidList,
    double width = double.infinity,
    double height = double.infinity,
  }) async {
    SmartDialog.show(
        tag: tag,
        alignment: alignment,
        builder: (_) {

          return ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 0, maxHeight: 350),
            child: AppContentBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("a")
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("b")
                        ]),
                  ),
                ],
              ),
            ),
          );

    }
    );
  }
}



  // await stackDialog2(
  //     tag: "",
  //     rfidList: ["SATL1000032","SATL1000032","SATL1000032","SATL1000032","SATL1000032"],
  //     height: 400,
  //     alignment: Alignment.topCenter);
  //
  // await stackDialog2(
  //     tag: "",
  //     rfidList: ["SATL1000032","SATL1000032","SATL1000032","SATL1000032","SATL1000032"],
  //     height: 400,
  //     alignment: Alignment.bottomCenter);


// Widget _buildCupertinoPicker(List<String?> items){
//   return Container(
//     child: CupertinoPicker(
//       magnification: 1.5,
//       backgroundColor: Colors.white,
//       itemExtent: 50, //height of each item
//       looping: true,
//       children: items.map((item)=> Center(
//         child: Text(item!,
//           style: TextStyle(fontSize: 32),),
//       )).toList(),
//       onSelectedItemChanged: (index) {
//         value= index);
//         selectItem= items[index];
//         print("Selected Iem: $index");
//         // setState(() {
//         //   selectItem=value.toString();
//         // });
//       },
//     ),
//   );

