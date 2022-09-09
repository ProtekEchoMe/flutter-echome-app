// ignore_for_file: unnecessary_new, prefer_collection_literals

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zebra_rfd8500/channel_constant.dart';
import 'package:zebra_rfd8500/reader_connection_event.dart';
import 'package:zebra_rfd8500/reader_list_change_event.dart';

enum ReaderStatus { connected, disconnected }

enum ScannerEventType { read, test, readEvent, locatingEvent }

enum ErrorStatus {
  // ignore: constant_identifier_names
  READER_LIST_NOT_AVAILABLE
}

extension ErrorStatusExtension on ErrorStatus {
  String get name {
    switch (this) {
      case ErrorStatus.READER_LIST_NOT_AVAILABLE:
        return '1001';
      default:
        return "1000"; //General Error
    }
  }

  String get errorMessage {
    switch (this) {
      case ErrorStatus.READER_LIST_NOT_AVAILABLE:
        return 'Reader list is not available';
      default:
        return 'General RFID SDK error';
    }
  }
}

class ConnectionStatus {
  ReaderStatus status;
  String RFIDReaderHostName;
  ConnectionStatus(this.RFIDReaderHostName, this.status);
}

class ScannerEvent {
  ScannerEventType type;
  dynamic data;
  ScannerEvent(this.type, this.data);
}

class ZebraRfd8500 {
  static const CHANNEL_NAME = "zebra_rfd8500";
  static const MethodChannel _channel = MethodChannel(CHANNEL_NAME + "/plugin");
  static const EventChannel _eventChannel =
      EventChannel(CHANNEL_NAME + "/event_channel");

  static List<StreamSubscription<dynamic>?> sinkDispose = [];

  //channel for new RFID channels
  static const EventChannel _readerListChannel =
      EventChannel(ChannelConstant.READER_LIST_CHANNEL_NAME);
  static const EventChannel _readerConnectionStatusChannel =
      EventChannel(ChannelConstant.READER_CONNECTION_STATUS_CHANNEL);
  static const EventChannel _readerRfidDataChannel =
      EventChannel(ChannelConstant.READER_RFID_DATA_CHANNEL);
  static const EventChannel _readerRfidLocatingDataChannel =
    EventChannel(ChannelConstant.READER_RFID_LOCATING_DATA_CHANNEL);

  static final StreamController<ReaderListChangeEvent>
      _readerListChannelStreamController = StreamController.broadcast();
  static Stream<ReaderListChangeEvent> get readerListChannelStream =>
      _readerListChannelStreamController.stream;

  static final StreamController<ReaderConncetionEvent>
      _readerConnectionStatusStreamController = StreamController.broadcast();
  static Stream<ReaderConncetionEvent> get readerConnectionStatusStream =>
      _readerConnectionStatusStreamController.stream;

  static final StreamController<ConnectionStatus>
      _readerRfidDataStreamController = StreamController.broadcast();
  static Stream<ConnectionStatus> get readerRfidDataStream =>
      _readerRfidDataStreamController.stream;

  static final StreamController<ConnectionStatus> _connectController =
      StreamController.broadcast();
  static Stream<ConnectionStatus> get connectStream =>
      _connectController.stream;

  static final StreamController<ScannerEvent> _eventController =
      StreamController.broadcast();
  static Stream<ScannerEvent> get eventStream => _eventController.stream;

  static StreamSubscription<dynamic>? _sink;

  static bool isInit = false;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> getPlatformVersion() async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> connectScannerWithName(String name) async {
    try {
      String hostName = await _channel.invokeMethod('connectRFIDReader', name);
      print("Connected! $hostName");
      _connectController.sink
          .add(ConnectionStatus(hostName, ReaderStatus.connected));

    } catch (e) {}
  }

  static Future<void> setAntennaPower(int power) async {
    try {
      await _channel.invokeMethod('setAntennaPower', power);
      print("setAntennaPower");
    } catch (e) {}
  }

  static Future<List<String>> getAntennaPower() async {
    try {
      List list = await _channel.invokeMethod('getAntennaPower');
      print("getAntennaPower");

      List<String> result = [];
      for (var i = 0; i < list.length; i++) {
        String str = list[i].toString();
        result.add(str);
      }
      print(result);
      return result;

    } on PlatformException catch (_, e) {
      print("Error!!");
      print(e);
      rethrow;
    }
  }

  static Future<int> getAntennaPower2() async {
    try {
      int power = await _channel.invokeMethod('getAntennaPower');
      return power;

    } on PlatformException catch (_, e) {
      print("Error!!");
      print(e);
      rethrow;
    }
  }

  static Future<ModelInfo> getConnectedScannerInfo() async {
    var map = await _channel.invokeMethod('getConnectedScannerInfo');
    print(map.runtimeType);
    ModelInfo modelInfo = ModelInfo.fromJson(Map<String, dynamic>.from(map));
    return modelInfo;
  }

  static Future<List<String>> debug() async {
    var result = await _channel.invokeMethod('debug');
    // print(map.runtimeType);
    // ModelInfo modelInfo = ModelInfo.fromJson(Map<String, dynamic>.from(map));
    return result;
  }

  static Future<List<String>> connectAIReader() async {
    var result = await _channel.invokeMethod('aiReaderConnect');
    // print(map.runtimeType);
    // ModelInfo modelInfo = ModelInfo.fromJson(Map<String, dynamic>.from(map));
    return result;
  }

  static Future<List<String>> startInventory() async {
    var result = await _channel.invokeMethod('startInventory');
    // print(map.runtimeType);
    // ModelInfo modelInfo = ModelInfo.fromJson(Map<String, dynamic>.from(map));
    return result;
  }

  static Future<List<String>> stopInventory() async {
    var result = await _channel.invokeMethod('stopInventory');
    // print(map.runtimeType);
    // ModelInfo modelInfo = ModelInfo.fromJson(Map<String, dynamic>.from(map));
    return result;
  }

  static Future<List<String>> disconnectAIReader() async {
    var result = await _channel.invokeMethod('aiReaderDisconnect');
    // print(map.runtimeType);
    // ModelInfo modelInfo = ModelInfo.fromJson(Map<String, dynamic>.from(map));
    return result;
  }




  static Future<List<String>> getAvailableRFIDReaderList() async {
    try {
      print("Called !");
      List list = await _channel.invokeMethod('getAvailableRFIDReaderList');
      print("Get Success");
      print(list);
      List<String> result = [];
      for (var i = 0; i < list.length; i++) {
        String str = list[i].toString();
        result.add(str);
      }
      return result;
    } on PlatformException catch (_, e) {
      print("Error!!");
      print(e);
      rethrow;
    }
  }

  static Future<String> performTagLocating(String? rfid) async {
    try {
      print("performTagLocating Called !");
      String result = await _channel.invokeMethod('performTagLocating', {"rfid": rfid});
      print("Get Success");
      return result;
    } on PlatformException catch (_, e) {
      print("Error!!");
      print(e);
      rethrow;
    }
  }

  static Future<String> stopTagLocating() async {
    try {
      print("stopTagLocating Called !");
      String result = await _channel.invokeMethod('stopTagLocating');
      print("Get Success");
      return result;
    } on PlatformException catch (_, e) {
      print("Error!!");
      print(e);
      rethrow;
    }
  }


  static void initSDK() {
    addEventChannelHandler();
  }

  static void addEventChannelHandler() {
    var _sink1 = _eventChannel.receiveBroadcastStream().listen((event) {
      print("on event call from native");
      if (event is List) {
        var list = List<String>.from(event);
        _eventController.sink
            .add(ScannerEvent(ScannerEventType.readEvent, list));
        return;
      }
      // _eventController.sink
      //     .add(ScannerEvent(ScannerEventType.test, "onResume"));
    });
    var _sink2 = _readerListChannel.receiveBroadcastStream().listen((event) {
      print("readerListChannel in flutter is being called");
      print(event);
      print(event.runtimeType);
      _readerListChannelStreamController.sink.add(ReaderListChangeEvent(event[0] == "1", event[1]));
    });
    var _sink3 =
        _readerConnectionStatusChannel.receiveBroadcastStream().listen((event) {
      print("readerConnectionStatusChannel in flutter is being called");
      print(event);
      print(event.runtimeType);
      _readerConnectionStatusStreamController.sink.add(ReaderConncetionEvent(event[0] == "1", event[1]));
    });
    var _sink4 =
        _readerRfidDataChannel.receiveBroadcastStream().listen((event) {
      print("readerRfidDataChannel in flutter is being called");
      print(event);
      print(event.runtimeType);
      if (event is List) {
        var list = List<String>.from(event);
        _eventController.sink
            .add(ScannerEvent(ScannerEventType.readEvent, list));
        return;
      }
    });

    var _sink5 =
    _readerRfidLocatingDataChannel.receiveBroadcastStream().listen((event) {
      print("_readerRfidLocatingDataChannel in flutter is being called");
      print(event);
      print(event.runtimeType);
      if (event is List) {
        var list = List<String>.from(event);
        _eventController.sink
            .add(ScannerEvent(ScannerEventType.locatingEvent, list));
        return;
      }
    });

    sinkDispose.addAll([_sink1, _sink2, _sink3, _sink4, _sink5]);
  }

  static void dispose() {
    for (var sink in sinkDispose) {
      sink?.cancel();
    }
  }

  static Stream<dynamic> getStream() {
    return _eventChannel.receiveBroadcastStream();
  }
}

class ModelInfo {
  String? modelName;
  String? isTagLocationingSupported;
  String? isTagEvenReportingSupported;
  String? countryCode;
  String? numAntennaSupported;
  String? isNXPCommandSupported;
  String? rssiFilter;
  String? communicationStandard;
  String? readerId;
  String? antennaPower;

  ModelInfo(
      {this.modelName,
      this.isTagLocationingSupported,
      this.isTagEvenReportingSupported,
      this.countryCode,
      this.numAntennaSupported,
      this.isNXPCommandSupported,
      this.rssiFilter,
      this.communicationStandard,
      this.readerId,
      this.antennaPower});

  ModelInfo.fromJson(Map<String, dynamic> json) {
    modelName = json['modelName'];
    isTagLocationingSupported = json['isTagLocationingSupported'];
    isTagEvenReportingSupported = json['isTagEvenReportingSupported'];
    countryCode = json['countryCode'];
    numAntennaSupported = json['numAntennaSupported'];
    isNXPCommandSupported = json['isNXPCommandSupported'];
    rssiFilter = json['rssiFilter'];
    communicationStandard = json['communicationStandard'];
    readerId = json['readerId'];
    antennaPower = json['antennaPower'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modelName'] = modelName;
    data['isTagLocationingSupported'] = isTagLocationingSupported;
    data['isTagEvenReportingSupported'] = isTagEvenReportingSupported;
    data['countryCode'] = countryCode;
    data['numAntennaSupported'] = numAntennaSupported;
    data['isNXPCommandSupported'] = isNXPCommandSupported;
    data['rssiFilter'] = rssiFilter;
    data['communicationStandard'] = communicationStandard;
    data['readerId'] = readerId;
    data['antennaPower'] = antennaPower;
    return data;
  }
}
