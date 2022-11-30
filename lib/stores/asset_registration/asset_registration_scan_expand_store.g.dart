// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_registration_scan_expand_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ARScanExpandStore on _ARScanExpandStore, Store {
  final _$totalCheckedSKUAtom =
      Atom(name: '_ARScanExpandStore.totalCheckedSKU');

  @override
  int get totalCheckedSKU {
    _$totalCheckedSKUAtom.reportRead();
    return super.totalCheckedSKU;
  }

  @override
  set totalCheckedSKU(int value) {
    _$totalCheckedSKUAtom.reportWrite(value, super.totalCheckedSKU, () {
      super.totalCheckedSKU = value;
    });
  }

  final _$totalSKUAtom = Atom(name: '_ARScanExpandStore.totalSKU');

  @override
  int get totalSKU {
    _$totalSKUAtom.reportRead();
    return super.totalSKU;
  }

  @override
  set totalSKU(int value) {
    _$totalSKUAtom.reportWrite(value, super.totalSKU, () {
      super.totalSKU = value;
    });
  }

  final _$totalCheckedQtyAtom =
      Atom(name: '_ARScanExpandStore.totalCheckedQty');

  @override
  int get totalCheckedQty {
    _$totalCheckedQtyAtom.reportRead();
    return super.totalCheckedQty;
  }

  @override
  set totalCheckedQty(int value) {
    _$totalCheckedQtyAtom.reportWrite(value, super.totalCheckedQty, () {
      super.totalCheckedQty = value;
    });
  }

  final _$totalQtyAtom = Atom(name: '_ARScanExpandStore.totalQty');

  @override
  int get totalQty {
    _$totalQtyAtom.reportRead();
    return super.totalQty;
  }

  @override
  set totalQty(int value) {
    _$totalQtyAtom.reportWrite(value, super.totalQty, () {
      super.totalQty = value;
    });
  }

  final _$totalContainerAtom = Atom(name: '_ARScanExpandStore.totalContainer');

  @override
  int get totalContainer {
    _$totalContainerAtom.reportRead();
    return super.totalContainer;
  }

  @override
  set totalContainer(int value) {
    _$totalContainerAtom.reportWrite(value, super.totalContainer, () {
      super.totalContainer = value;
    });
  }

  final _$activeContainerAtom =
      Atom(name: '_ARScanExpandStore.activeContainer');

  @override
  String get activeContainer {
    _$activeContainerAtom.reportRead();
    return super.activeContainer;
  }

  @override
  set activeContainer(String value) {
    _$activeContainerAtom.reportWrite(value, super.activeContainer, () {
      super.activeContainer = value;
    });
  }

  final _$itemRfidDataSetAtom =
      Atom(name: '_ARScanExpandStore.itemRfidDataSet');

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
      Atom(name: '_ARScanExpandStore.equipmentRfidDataSet');

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

  final _$equipmentDataAtom = Atom(name: '_ARScanExpandStore.equipmentData');

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
      Atom(name: '_ARScanExpandStore.isFetchingEquData');

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

  final _$checkedItemAtom = Atom(name: '_ARScanExpandStore.checkedItem');

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
      Atom(name: '_ARScanExpandStore.chosenEquipmentData');

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

  final _$isFetchingAtom = Atom(name: '_ARScanExpandStore.isFetching');

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
      AsyncAction('_ARScanExpandStore.validateEquipmentRfid');

  @override
  Future<void> validateEquipmentRfid() {
    return _$validateEquipmentRfidAsyncAction
        .run(() => super.validateEquipmentRfid());
  }

  final _$completeAsyncAction = AsyncAction('_ARScanExpandStore.complete');

  @override
  Future<void> complete({String regNum = ""}) {
    return _$completeAsyncAction.run(() => super.complete(regNum: regNum));
  }

  final _$registerContainerAsyncAction =
      AsyncAction('_ARScanExpandStore.registerContainer');

  @override
  Future<void> registerContainer(
      {List<String> rfid = const [],
      String regNum = "",
      bool throwError = false}) {
    return _$registerContainerAsyncAction.run(() => super
        .registerContainer(rfid: rfid, regNum: regNum, throwError: throwError));
  }

  final _$registerItemAsyncAction =
      AsyncAction('_ARScanExpandStore.registerItem');

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

  final _$_ARScanExpandStoreActionController =
      ActionController(name: '_ARScanExpandStore');

  @override
  void reset() {
    final _$actionInfo = _$_ARScanExpandStoreActionController.startAction(
        name: '_ARScanExpandStore.reset');
    try {
      return super.reset();
    } finally {
      _$_ARScanExpandStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetContainer() {
    final _$actionInfo = _$_ARScanExpandStoreActionController.startAction(
        name: '_ARScanExpandStore.resetContainer');
    try {
      return super.resetContainer();
    } finally {
      _$_ARScanExpandStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDataSet(
      {List<String> itemList = const [], List<String> equList = const []}) {
    final _$actionInfo = _$_ARScanExpandStoreActionController.startAction(
        name: '_ARScanExpandStore.updateDataSet');
    try {
      return super.updateDataSet(itemList: itemList, equList: equList);
    } finally {
      _$_ARScanExpandStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
totalCheckedSKU: ${totalCheckedSKU},
totalSKU: ${totalSKU},
totalCheckedQty: ${totalCheckedQty},
totalQty: ${totalQty},
totalContainer: ${totalContainer},
activeContainer: ${activeContainer},
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
