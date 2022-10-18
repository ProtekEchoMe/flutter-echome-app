import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/stores/reader_connection/reader_connection_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';
import 'package:echo_me_mobile/data/sharedpref/shared_preference_helper.dart';

class EchoMeAppBar extends StatelessWidget with PreferredSizeWidget {
  String? titleText;
  List<Widget>? actionList;

  EchoMeAppBar({Key? key, this.titleText, this.actionList}) : super(key: key);

  ReaderConnectionStore _readerConnectionStore = getIt<ReaderConnectionStore>();

  final SharedPreferenceHelper sharePreferenceHelper = getIt<SharedPreferenceHelper>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [Text(titleText ?? "EchoMe")],
      ),
      actions: [
        Container(
          child: Center(child: 
          Observer(builder: (context){ //TODO: adding last 4 digits to show string (0421)Connected
            var str = _readerConnectionStore.currentReader != null ? "Connected":"Not Connected";
            return Text(str, style: TextStyle(fontSize: 14));
          },) ),
        ),
        ...actionList?? [IconButton(onPressed: () {
          void onClickFunction(String selectedDomainKey){
            sharePreferenceHelper.changeDefaulServicetDomainName(selectedDomainKey);
            Endpoints.updateFunctionEndPoint(
                Endpoints.domainMap[selectedDomainKey]);
            Endpoints.updateKeyCloakEndPoint(
                Endpoints.keyClockDomainMap[selectedDomainKey]);
          }
          DialogHelper.listSelectionDialogWithAutoCompleteBar(
              context, List<String?>.from(Endpoints.domainMap.keys.toList()), onClickFunction,
              willPop: true);
        }, icon: Icon(Icons.more_vert))]
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}