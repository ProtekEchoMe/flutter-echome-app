import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
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
  double _currentSliderValue = 20;

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
      appBar: AppBar(
        title: Text("setting".tr(gender: "setting_page_title")),
        actions: [
          IconButton(
              onPressed: () {
                readerConnectionStore.refreshRfidList();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(
              "setting".tr(gender: "setting_reader_in_use_text"),
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge,
            ),
            Observer(builder: (context) {
              return GestureDetector(
                onTap: () {},
                child: Card(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: ListTile(
                    title: Text(readerConnectionStore.currentReader ??
                        "setting".tr(gender: "setting_no_connected_reader_msg")),
                  ),
                ),
              );
            }),
            Text(
              "setting".tr(gender: "setting_available_reader_text"),
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge,
            ),
            _getReaderList(context),
            const SizedBox(height: 100),

            Text(
              "setting".tr(gender: "setting_power_setting_text"),
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge,
            ),
            // Center(
            //
            //   child: Observer(builder: (context) {
            //     return Text("Current Power: " + (readerConnectionStore.antennaPower ?? "No data"));
            //   }),
            // ),
            Observer(builder: (context) {
              return GestureDetector(
                  onTap: ()
              {
                print("hello");
                readerConnectionStore.getAntennaPower();
              },
              child: Observer(builder: (context){ return Card(
              margin:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: ListTile(
              title: Text("setting".tr(gender: "setting_current_power") + ": " + (readerConnectionStore.antennaPower ?? "No data")),
              ),
              );},
              ));
            }),
            Slider(
              value: _currentSliderValue,
              max: readerConnectionStore.maxPower,
              divisions: 10,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
            Center(

              child: Observer(builder: (context) {
                return Text(_currentSliderValue.toString());
              }),
            ),
            Center(
              child: RaisedButton(
                onPressed: () async {
                  await ZebraRfd8500.setAntennaPower(_currentSliderValue.toInt());

                  setState(() {
                    readerConnectionStore.getAntennaPower();
                  });
                },
                child: Text("setting".tr(gender: "setting_set_power")),
              ),
            ),
          ]
          ),
        ),
      ),
    );
  }

  Widget _getReaderList(BuildContext context) {
    return Observer(builder: (context) {
      if (readerConnectionStore.readerList.isEmpty) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: ListTile(
            title: Text("setting".tr(gender: "setting_power_no_data")),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: readerConnectionStore.readerList
            .map((e) =>
            GestureDetector(
              onTap: () {
                readerConnectionStore.connectScannerWithName(e);
                DialogHelper.showCustomDialog(context, widgetList: [
                  Text(
                    "setting".tr(gender: "setting_reader_connecting"),
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(e),
                  Observer(builder: (_) {
                    print("builder");
                    print(readerConnectionStore.isConnecting);
                    if (readerConnectionStore.isConnecting == false) {
                      Timer(Duration(milliseconds: 800), () {
                        Navigator.pop(context);
                      });
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
