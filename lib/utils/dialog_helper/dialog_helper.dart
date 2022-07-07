import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:echo_me_mobile/utils/dialog_helper/auto_complete_searchbar.dart';

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

  static Future<void> listSelectionDialogWithAutoCompleteBar(BuildContext context, List<String?> inputList, Function onTapFunction, {bool willPop = false, text = "Choose the site"}) async {
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
                      children: <Widget>[Text("Total: ${inputList.length}")])
                ]
            ),
                        actions: <Widget>[],
          ),
        );
      },
    );
  }
}


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

