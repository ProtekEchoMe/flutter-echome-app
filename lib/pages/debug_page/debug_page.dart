import 'dart:async';

import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/pages/sensor_settings/sensor_settings.dart';
import 'package:echo_me_mobile/stores/reader_connection/reader_connection_store.dart';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';

class DebugPage extends StatefulWidget {
  DebugPage({Key? key}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  ReaderConnectionStore readerConnectionStore = getIt<ReaderConnectionStore>();
  ReactionDisposer? disposer;

  void _showSnackBar(String msg) {
    var snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    disposer =
        reaction((_) => readerConnectionStore.errorStore.errorMessage, (_) {
      if (readerConnectionStore.errorStore.errorMessage.isNotEmpty) {
        _showSnackBar(readerConnectionStore.errorStore.errorMessage);
      }
    });
    readerConnectionStore
        .getRfidList()
        .then((value) => null)
        .catchError((_) => null);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (disposer != null) disposer!();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scanner Settings"), actions: [
        IconButton(onPressed: (){
          readerConnectionStore.refreshRfidList();
        }, icon: Icon(Icons.refresh))
      ],),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(
              "Current Reader In Use",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Observer(builder: (context) {
              return GestureDetector(
                onTap: () {},
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: ListTile(
                    title: Text(readerConnectionStore.currentReader ??
                        "Didn't Connect To Any Scanner"),
                  ),
                ),
              );
            }),
            Text(
              "Available Readers List:",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _getReaderList(context),
          ]),
        ),
      ),
    );
  }

  Widget _getReaderList(BuildContext context) {
    return Observer(builder: (context) {
      if (readerConnectionStore.readerList.isEmpty) {
        return const Card(
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: ListTile(
            title: Text("No Data"),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: readerConnectionStore.readerList
            .map((e) => GestureDetector(
                  onTap: () {
                     readerConnectionStore.connectScannerWithName(e);
                    DialogHelper.showCustomDialog(context, widgetList: [
                      Text("Connecting to Scanner", style: Theme.of(context).textTheme.titleLarge,),
                      Container(height: 10,),
                      Text(e),
                      Observer(builder: (_){
                        print("builder");
                        print(readerConnectionStore.isConnecting);
                        if(readerConnectionStore.isConnecting == false){
                          Timer(Duration(milliseconds: 800),(){Navigator.pop(context);});
                        }
                        return SizedBox();
                      })
                    ]);
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: ListTile(
                      title: Text(e),
                    ),
                  ),
                ))
            .toList(),
      );
    });
  }
}
