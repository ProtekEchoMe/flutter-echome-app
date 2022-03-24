import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';

class SensorSettings extends StatefulWidget {
  SensorSettings({Key? key}) : super(key: key);

  @override
  State<SensorSettings> createState() => _SensorSettingsState();
}

class _SensorSettingsState extends State<SensorSettings> {
  List<StreamSubscription> disposer = [];
  String? connectedReader;
  ModelInfo? modelInfo;
  dynamic? testData;

  @override
  void initState() {
    super.initState();
    ZebraRfd8500.addEventChannelHandler();
    var connectionSubscription = ZebraRfd8500.connectStream.listen((event) {
      if (event.status == ReaderStatus.connected) {
        setState(() {
          connectedReader = event.RFIDReaderHostName;
        });
      }
    });
    var eventSubscription = ZebraRfd8500.eventStream.listen((event) {
      if (event.type == ScannerEventType.test) {
        setState(() {
          testData = event.data;
        });
      }
    });
    disposer.add(connectionSubscription);
    disposer.add(eventSubscription);
  }

  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < disposer.length; i++) {
      disposer[i].cancel();
    }
  }

  List<String> readerList = [];

  List<Widget> _getAvailableReaderList() {
    if (readerList.length == 0) {
      return [
        Text("Current Empty, please press the button to get the reader list")
      ];
    }
    return readerList
        .map((e) => SizedBox(
              width: double.maxFinite,
              height: 100,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Reader Name"),
                    subtitle: Text(e),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        var hostName = e;
                        ZebraRfd8500.connectScannerWithName(e);
                      },
                    ),
                  ),
                ),
              ),
            ))
        .toList();
  }

  List<Widget> _getModelInfo() {
    if (modelInfo == null) {
      return [];
    }
    List<Widget> info = [];
    modelInfo!.toJson().forEach((key, value) {
      info.add(Text("$key = $value"));
    });
    return info;
  }

  List<Widget> _getConnectedReaderList() {
    if (connectedReader == null) {
      return [Text("No Connected Reader")];
    }
    return [
      SizedBox(
        width: double.maxFinite,
        height: 100,
        child: Card(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: ListTile(
                title: Text("Reader Name"),
                subtitle: Text(connectedReader!),
              )),
        ),
      ),
      ..._getModelInfo(),
      RaisedButton(
        onPressed: () {
          ZebraRfd8500.getConnectedScannerInfo()
              .then((value) => setState(() => modelInfo = value));
        },
        child: Text("Get Detail information about connected reader"),
      ),
      SizedBox(
        width: double.maxFinite,
        height: 20,
      ),
      Center(
        child: RaisedButton(
          onPressed: () {
            ZebraRfd8500.setAntennaPower(100);
          },
          child: Text("Set Power to 100"),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sensor Settings")),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            width: double.maxFinite,
            height: 15,
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available Readers List:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ..._getAvailableReaderList()
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              ZebraRfd8500.platformVersion;
              ZebraRfd8500.getAvailableRFIDReaderList().then((value) {
                setState(() {
                  readerList = value;
                });
              });
            },
            child: Text("Get Available Readers List"),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Connected Readers List:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ..._getConnectedReaderList()
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Message from test listener",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  child: Text(testData != null ? testData : "No data"),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
