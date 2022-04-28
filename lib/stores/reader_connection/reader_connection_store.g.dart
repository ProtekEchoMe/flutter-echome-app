// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_connection_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ReaderConnectionStore on _ReaderConnectionStore, Store {
  Computed<bool>? _$isConnectedToScannerComputed;

  @override
  bool get isConnectedToScanner => (_$isConnectedToScannerComputed ??=
          Computed<bool>(() => super.isConnectedToScanner,
              name: '_ReaderConnectionStore.isConnectedToScanner'))
      .value;
  Computed<String?>? _$currentScannerComputed;

  @override
  String? get currentScanner => (_$currentScannerComputed ??= Computed<String?>(
          () => super.currentScanner,
          name: '_ReaderConnectionStore.currentScanner'))
      .value;

  final _$isConnectingAtom = Atom(name: '_ReaderConnectionStore.isConnecting');

  @override
  bool get isConnecting {
    _$isConnectingAtom.reportRead();
    return super.isConnecting;
  }

  @override
  set isConnecting(bool value) {
    _$isConnectingAtom.reportWrite(value, super.isConnecting, () {
      super.isConnecting = value;
    });
  }

  final _$readerListAtom = Atom(name: '_ReaderConnectionStore.readerList');

  @override
  List<String> get readerList {
    _$readerListAtom.reportRead();
    return super.readerList;
  }

  @override
  set readerList(List<String> value) {
    _$readerListAtom.reportWrite(value, super.readerList, () {
      super.readerList = value;
    });
  }

  final _$currentReaderDataAtom =
      Atom(name: '_ReaderConnectionStore.currentReaderData');

  @override
  ScannerData? get currentReaderData {
    _$currentReaderDataAtom.reportRead();
    return super.currentReaderData;
  }

  @override
  set currentReaderData(ScannerData? value) {
    _$currentReaderDataAtom.reportWrite(value, super.currentReaderData, () {
      super.currentReaderData = value;
    });
  }

  final _$currentReaderAtom =
      Atom(name: '_ReaderConnectionStore.currentReader');

  @override
  String? get currentReader {
    _$currentReaderAtom.reportRead();
    return super.currentReader;
  }

  @override
  set currentReader(String? value) {
    _$currentReaderAtom.reportWrite(value, super.currentReader, () {
      super.currentReader = value;
    });
  }

  final _$_ReaderConnectionStoreActionController =
      ActionController(name: '_ReaderConnectionStore');

  @override
  void connectScannerWithName(String name) {
    final _$actionInfo = _$_ReaderConnectionStoreActionController.startAction(
        name: '_ReaderConnectionStore.connectScannerWithName');
    try {
      return super.connectScannerWithName(name);
    } finally {
      _$_ReaderConnectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic updateCurrentReaderRoot(String scannerData, dynamic isConnect) {
    final _$actionInfo = _$_ReaderConnectionStoreActionController.startAction(
        name: '_ReaderConnectionStore.updateCurrentReaderRoot');
    try {
      return super.updateCurrentReaderRoot(scannerData, isConnect);
    } finally {
      _$_ReaderConnectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateRfidList(List<String> list) {
    final _$actionInfo = _$_ReaderConnectionStoreActionController.startAction(
        name: '_ReaderConnectionStore.updateRfidList');
    try {
      return super.updateRfidList(list);
    } finally {
      _$_ReaderConnectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isConnecting: ${isConnecting},
readerList: ${readerList},
currentReaderData: ${currentReaderData},
currentReader: ${currentReader},
isConnectedToScanner: ${isConnectedToScanner},
currentScanner: ${currentScanner}
    ''';
  }
}
