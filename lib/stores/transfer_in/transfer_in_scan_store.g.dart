// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_in_scan_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TransferInScanStore on _TransferInScanStore, Store {
  final _$itemRfidDataSetAtom =
      Atom(name: '_TransferInScanStore.itemRfidDataSet');

  @override
  ObservableSet<String> get itemRfidDataSet {
    _$itemRfidDataSetAtom.reportRead();
    return super.itemRfidDataSet;
  }

  @override
  set itemRfidDataSet(ObservableSet<String> value) {
    _$itemRfidDataSetAtom.reportWrite(value, super.itemRfidDataSet, () {
      super.itemRfidDataSet = value;
    });
  }

  final _$equipmentRfidDataSetAtom =
      Atom(name: '_TransferInScanStore.equipmentRfidDataSet');

  @override
  ObservableSet<String> get equipmentRfidDataSet {
    _$equipmentRfidDataSetAtom.reportRead();
    return super.equipmentRfidDataSet;
  }

  @override
  set equipmentRfidDataSet(ObservableSet<String> value) {
    _$equipmentRfidDataSetAtom.reportWrite(value, super.equipmentRfidDataSet,
        () {
      super.equipmentRfidDataSet = value;
    });
  }

  final _$equipmentDataAtom = Atom(name: '_TransferInScanStore.equipmentData');

  @override
  ObservableList<EquipmentData> get equipmentData {
    _$equipmentDataAtom.reportRead();
    return super.equipmentData;
  }

  @override
  set equipmentData(ObservableList<EquipmentData> value) {
    _$equipmentDataAtom.reportWrite(value, super.equipmentData, () {
      super.equipmentData = value;
    });
  }

  final _$isFetchingEquDataAtom =
      Atom(name: '_TransferInScanStore.isFetchingEquData');

  @override
  bool get isFetchingEquData {
    _$isFetchingEquDataAtom.reportRead();
    return super.isFetchingEquData;
  }

  @override
  set isFetchingEquData(bool value) {
    _$isFetchingEquDataAtom.reportWrite(value, super.isFetchingEquData, () {
      super.isFetchingEquData = value;
    });
  }

  final _$checkedItemAtom = Atom(name: '_TransferInScanStore.checkedItem');

  @override
  ObservableSet<String> get checkedItem {
    _$checkedItemAtom.reportRead();
    return super.checkedItem;
  }

  @override
  set checkedItem(ObservableSet<String> value) {
    _$checkedItemAtom.reportWrite(value, super.checkedItem, () {
      super.checkedItem = value;
    });
  }

  final _$chosenEquipmentDataAtom =
      Atom(name: '_TransferInScanStore.chosenEquipmentData');

  @override
  ObservableList<EquipmentData> get chosenEquipmentData {
    _$chosenEquipmentDataAtom.reportRead();
    return super.chosenEquipmentData;
  }

  @override
  set chosenEquipmentData(ObservableList<EquipmentData> value) {
    _$chosenEquipmentDataAtom.reportWrite(value, super.chosenEquipmentData, () {
      super.chosenEquipmentData = value;
    });
  }

  final _$isFetchingAtom = Atom(name: '_TransferInScanStore.isFetching');

  @override
  bool get isFetching {
    _$isFetchingAtom.reportRead();
    return super.isFetching;
  }

  @override
  set isFetching(bool value) {
    _$isFetchingAtom.reportWrite(value, super.isFetching, () {
      super.isFetching = value;
    });
  }

  final _$validateEquipmentRfidAsyncAction =
      AsyncAction('_TransferInScanStore.validateEquipmentRfid');

  @override
  Future<void> validateEquipmentRfid() {
    return _$validateEquipmentRfidAsyncAction
        .run(() => super.validateEquipmentRfid());
  }

  final _$completeAsyncAction = AsyncAction('_TransferInScanStore.complete');

  @override
  Future<void> complete({String tiNum = ""}) {
    return _$completeAsyncAction.run(() => super.complete(tiNum: tiNum));
  }

  final _$checkInContainerAsyncAction =
      AsyncAction('_TransferInScanStore.checkInContainer');

  @override
  Future<void> checkInContainer(
      {List<String> rfid = const [],
      String tiNum = "",
      bool throwError = false}) {
    return _$checkInContainerAsyncAction.run(() => super
        .checkInContainer(rfid: rfid, tiNum: tiNum, throwError: throwError));
  }

  final _$checkInItemAsyncAction =
      AsyncAction('_TransferInScanStore.checkInItem');

  @override
  Future<void> checkInItem(
      {String tiNum = "",
      String containerAssetCode = "",
      List<String> itemRfid = const [],
      bool throwError = false}) {
    return _$checkInItemAsyncAction.run(() => super.checkInItem(
        tiNum: tiNum,
        containerAssetCode: containerAssetCode,
        itemRfid: itemRfid,
        throwError: throwError));
  }

  final _$_TransferInScanStoreActionController =
      ActionController(name: '_TransferInScanStore');

  @override
  void reset() {
    final _$actionInfo = _$_TransferInScanStoreActionController.startAction(
        name: '_TransferInScanStore.reset');
    try {
      return super.reset();
    } finally {
      _$_TransferInScanStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDataSet(
      {List<String> itemList = const [], List<String> equList = const []}) {
    final _$actionInfo = _$_TransferInScanStoreActionController.startAction(
        name: '_TransferInScanStore.updateDataSet');
    try {
      return super.updateDataSet(itemList: itemList, equList: equList);
    } finally {
      _$_TransferInScanStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
itemRfidDataSet: ${itemRfidDataSet},
equipmentRfidDataSet: ${equipmentRfidDataSet},
equipmentData: ${equipmentData},
isFetchingEquData: ${isFetchingEquData},
checkedItem: ${checkedItem},
chosenEquipmentData: ${chosenEquipmentData},
isFetching: ${isFetching}
    ''';
  }
}
