import 'package:easy_debounce/easy_debounce.dart';
import 'package:echo_me_mobile/models/reader/scanner_data.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:zebra_rfd8500/zebra_rfd8500.dart';

import '../error/error_store.dart';

part 'reader_connection_store.g.dart';

class ReaderConnectionStore = _ReaderConnectionStore
    with _$ReaderConnectionStore;

abstract class _ReaderConnectionStore with Store {
  final String TAG = "_ReaderConnectionStore";

  final ErrorStore errorStore = ErrorStore();

  List<dynamic> disposer = [];

  bool hasGetList = false;

  _ReaderConnectionStore() {
    init();

    var readerConnectionStatusStrean =
        ZebraRfd8500.readerConnectionStatusStream.listen((event) {
      print(event.isConnect);
      if (event.isConnect) {
        updateCurrentReader(event.readerName, true);
      } else {
        updateCurrentReader(event.readerName, false);
      }
    });

    var readerListStream = ZebraRfd8500.readerListChannelStream.listen((event) {
      if (event.isAppear && !readerList.contains(event.readerName)) {
        updateRfidList([...readerList, event.readerName]);
      } else if (!event.isAppear) {
        var newList = [...readerList];
        newList.remove(event.readerName);
        updateRfidList(newList);
        if (event.readerName == currentReader) {
          updateCurrentReader(event.readerName, false);
        }
      }
    });

    disposer.add(() => readerConnectionStatusStrean.cancel());
    disposer.add(() => readerListStream);
  }

  void dispose() {
    for (var element in disposer) {
      element();
    }
  }

  void init() {
    ZebraRfd8500.initSDK();
  }

  String connectingReaderName = "";

  @observable
  bool isConnecting = false;

  @observable
  List<String> readerList = [];

  @observable
  ScannerData? currentReaderData;

  @observable
  String? currentReader;

  @observable
  String? antennaPower;

  @computed
  bool get isConnectedToScanner => currentReader != null;

  @computed
  String? get currentScanner {
    if (readerList.isNotEmpty && currentReader != null) {
      return currentReader;
    }
    return null;
  }

  void updateCurrentReader(String scannerData, bool isConncet) {
    print("updateCurrentPeader");
    print(isConnecting);
    EasyDebounce.debounce(
        "UPDATE_CURRENT_READE", const Duration(milliseconds: 1500), () {
      updateCurrentReaderRoot(scannerData, isConncet);
    });
  }

  @action
  void connectScannerWithName(String name){
    connectingReaderName = name;
    print("connectScannerWithName");
    print(isConnecting);
     isConnecting = true;
     print("after");
     print(isConnecting);
    Future.delayed(Duration(milliseconds: 0), ()=>ZebraRfd8500.connectScannerWithName(name));
  }
  
  @action
  updateCurrentReaderRoot(String scannerData, isConnect) {
    if(isConnect){
      currentReader = scannerData;
    }else{
      currentReader = null;
    }

    if(isConnecting == true) isConnecting = false;
  }

  @action
  void updateRfidList(List<String> list) {
    readerList = list;
  }

  void refreshRfidList(){
    hasGetList = false;
    getRfidList();
  }

  Future<void> getRfidList() async {
    // Dont call readers.GetAvailableRFIDReaderList() on android native side when scanner has be connected to phone.
    // During testing, this action will "LOCK" the gun, the gun will become unresponsive
    // BUT the bluetooth light show blue lights, which confuse users
    // UNKNOW bug for zebra RFD8500, this bug also shown in Official Demo
    if (hasGetList) {
      return;
    }

    try {
      List<String> list = await ZebraRfd8500.getAvailableRFIDReaderList();
      updateRfidList(list);
      hasGetList = true;
    } catch (e) {
      var errorMsg = "Can't Get Scanner List";
      if (e is PlatformException) {}
      errorStore.setErrorMessage(errorMsg);
    }
  }

  void setAntennaPower(int power){
    print("flutter setAntennaPower: $power");
    ZebraRfd8500.setAntennaPower(power);
  }

  Future<String?> getAntennaPower() async {
    print("flutter getAntennaPower:");
    ModelInfo modelInfo = await ZebraRfd8500.getConnectedScannerInfo();
    antennaPower = modelInfo.antennaPower;
    return modelInfo.antennaPower;
  }

}
