// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_return_scan_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AssetReturnScanStore on _AssetReturnScanStore, Store {
  final _$itemRfidDataSetAtom =
      Atom(name: '_AssetReturnScanStore.itemRfidDataSet');

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
      Atom(name: '_AssetReturnScanStore.equipmentRfidDataSet');

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

  final _$equipmentDataAtom =
      Atom(name: '_AssetReturnScanStore.equipmentData');

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
      Atom(name: '_AssetReturnScanStore.isFetchingEquData');

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

  final _$checkedItemAtom =
      Atom(name: '_AssetReturnScanStore.checkedItem');

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
      Atom(name: '_AssetReturnScanStore.chosenEquipmentData');

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

  final _$isFetchingAtom = Atom(name: '_AssetReturnScanStore.isFetching');

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
      AsyncAction('_AssetReturnScanStore.validateEquipmentRfid');

  @override
  Future<void> validateEquipmentRfid() {
    return _$validateEquipmentRfidAsyncAction
        .run(() => super.validateEquipmentRfid());
  }

  final _$completeAsyncAction =
      AsyncAction('_AssetReturnScanStore.complete');

  @override
  Future<void> complete({String regNum = ""}) {
    return _$completeAsyncAction.run(() => super.complete(regNum: regNum));
  }

  final _$registerContainerAsyncAction =
      AsyncAction('_AssetReturnScanStore.registerContainer');

  @override
  Future<void> registerContainer(
      {List<String> rfid = const [],
      String regNum = "",
      bool throwError = false}) {
    return _$registerContainerAsyncAction.run(() => super
        .registerContainer(rfid: rfid, regNum: regNum, throwError: throwError));
  }

  final _$registerItemAsyncAction =
      AsyncAction('_AssetReturnScanStore.registerItem');

  @override
  Future<void> registerItem(
      {String regNum = "",
      String containerAssetCode = "",
      List<String> itemRfid = const [],
      bool throwError = false}) {
    return _$registerItemAsyncAction.run(() => super.registerItem(
        regNum: regNum,
        containerAssetCode: containerAssetCode,
        itemRfid: itemRfid,
        throwError: throwError));
  }

  final _$_AssetReturnScanStoreActionController =
      ActionController(name: '_AssetReturnScanStore');

  @override
  void reset() {
    final _$actionInfo = _$_AssetReturnScanStoreActionController
        .startAction(name: '_AssetReturnScanStore.reset');
    try {
      return super.reset();
    } finally {
      _$_AssetReturnScanStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDataSet(
      {List<String> itemList = const [], List<String> equList = const []}) {
    final _$actionInfo = _$_AssetReturnScanStoreActionController
        .startAction(name: '_AssetReturnScanStore.updateDataSet');
    try {
      return super.updateDataSet(itemList: itemList, equList: equList);
    } finally {
      _$_AssetReturnScanStoreActionController.endAction(_$actionInfo);
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
