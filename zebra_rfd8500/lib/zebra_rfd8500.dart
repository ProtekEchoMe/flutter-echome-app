
import 'dart:async';

import 'package:flutter/services.dart';

enum ReaderStatus {
  connected,
  disconnected
}

enum ScannerEventType {
  read,
  test,
  readEvent
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
  static const MethodChannel _channel = MethodChannel(CHANNEL_NAME+"/plugin");
  static const EventChannel _eventChannel = EventChannel(CHANNEL_NAME+"/event_channel");

  static final StreamController<ConnectionStatus> _connectController = StreamController.broadcast();
  static Stream<ConnectionStatus> get connectStream => _connectController.stream;

  static final StreamController<ScannerEvent> _eventController = StreamController.broadcast();
  static Stream<ScannerEvent> get eventStream => _eventController.stream;

  static StreamSubscription<dynamic>? _sink;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> connectScannerWithName (String name) async {
     try{
       String hostName = await _channel.invokeMethod('connectRFIDReader', name);
       print("Connected! $hostName");
       _connectController.sink.add(ConnectionStatus(hostName, ReaderStatus.connected));
     }catch(e){

     }
  }

  static Future<void> setAntennaPower (int power) async {
     try{
       await _channel.invokeMethod('setAntennaPower', power);
       print("setAntennaPower");

     }catch(e){

     }
  }

  static Future<ModelInfo> getConnectedScannerInfo () async {
       var map = await _channel.invokeMethod('getConnectedScannerInfo');
       print(map.runtimeType);
       ModelInfo modelInfo = ModelInfo.fromJson(Map<String, dynamic>.from(map));
       return modelInfo;
  }

  static Future<List<String>> getAvailableRFIDReaderList () async {
    List list = await _channel.invokeMethod('getAvailableRFIDReaderList');
    List<String> result = [];
    for(var i =0; i< list.length; i++){
      String str = list[i].toString();
      result.add(str);
    }
    return result;
  }

  static void addEventChannelHandler(){
    _sink = _eventChannel.receiveBroadcastStream().listen((event) { 
      print("on event call from native");
      print(event);
      print(event.runtimeType);
      print(event is List);
      if(event is List){
        var list = List<String>.from(event);
        _eventController.sink.add(ScannerEvent(ScannerEventType.readEvent, list));
        return;
      }
        _eventController.sink.add(ScannerEvent(ScannerEventType.test, "onResume"));
    });
  }

  static void dispose(){
    _sink?.cancel();
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
    data['modelName'] = this.modelName;
    data['isTagLocationingSupported'] = this.isTagLocationingSupported;
    data['isTagEvenReportingSupported'] = this.isTagEvenReportingSupported;
    data['countryCode'] = this.countryCode;
    data['numAntennaSupported'] = this.numAntennaSupported;
    data['isNXPCommandSupported'] = this.isNXPCommandSupported;
    data['rssiFilter'] = this.rssiFilter;
    data['communicationStandard'] = this.communicationStandard;
    data['readerId'] = this.readerId;
    data['antennaPower'] = this.antennaPower;
    return data;
  }
}