// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_registration_scan_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AssetRegistrationScanStore on _AssetRegistrationScanStore, Store {
  final _$itemRfidDataSetAtom =
      Atom(name: '_AssetRegistrationScanStore.itemRfidDataSet');

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
      Atom(name: '_AssetRegistrationScanStore.equipmentRfidDataSet');

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
      Atom(name: '_AssetRegistrationScanStore.equipmentData');

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
      Atom(name: '_AssetRegistrationScanStore.isFetchingEquData');

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
      Atom(name: '_AssetRegistrationScanStore.checkedItem');

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
      Atom(name: '_AssetRegistrationScanStore.chosenEquipmentData');

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

  final _$validateEquipmentRfidAsyncAction =
      AsyncAction('_AssetRegistrationScanStore.validateEquipmentRfid');

  @override
  Future<void> validateEquipmentRfid() {
    return _$validateEquipmentRfidAsyncAction
        .run(() => super.validateEquipmentRfid());
  }

  final _$_AssetRegistrationScanStoreActionController =
      ActionController(name: '_AssetRegistrationScanStore');

  @override
  void updateDataSet(
      {List<String> itemList = const [], List<String> equList = const []}) {
    final _$actionInfo = _$_AssetRegistrationScanStoreActionController
        .startAction(name: '_AssetRegistrationScanStore.updateDataSet');
    try {
      return super.updateDataSet(itemList: itemList, equList: equList);
    } finally {
      _$_AssetRegistrationScanStoreActionController.endAction(_$actionInfo);
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
chosenEquipmentData: ${chosenEquipmentData}
    ''';
  }
}
