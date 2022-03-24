// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_registration_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AssetRegistrationStore on _AssetRegistrationStore, Store {
  final _$itemListAtom = Atom(name: '_AssetRegistrationStore.itemList');

  @override
  ObservableList<AssetRegistrationItem> get itemList {
    _$itemListAtom.reportRead();
    return super.itemList;
  }

  @override
  set itemList(ObservableList<AssetRegistrationItem> value) {
    _$itemListAtom.reportWrite(value, super.itemList, () {
      super.itemList = value;
    });
  }

  final _$isFetchingAtom = Atom(name: '_AssetRegistrationStore.isFetching');

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

  final _$fetchDataAsyncAction =
      AsyncAction('_AssetRegistrationStore.fetchData');

  @override
  Future<void> fetchData() {
    return _$fetchDataAsyncAction.run(() => super.fetchData());
  }

  final _$_AssetRegistrationStoreActionController =
      ActionController(name: '_AssetRegistrationStore');

  @override
  void addItem(AssetRegistrationItem item) {
    final _$actionInfo = _$_AssetRegistrationStoreActionController.startAction(
        name: '_AssetRegistrationStore.addItem');
    try {
      return super.addItem(item);
    } finally {
      _$_AssetRegistrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAllItem(List<AssetRegistrationItem> list) {
    final _$actionInfo = _$_AssetRegistrationStoreActionController.startAction(
        name: '_AssetRegistrationStore.addAllItem');
    try {
      return super.addAllItem(list);
    } finally {
      _$_AssetRegistrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(String orderId) {
    final _$actionInfo = _$_AssetRegistrationStoreActionController.startAction(
        name: '_AssetRegistrationStore.removeItem');
    try {
      return super.removeItem(orderId);
    } finally {
      _$_AssetRegistrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateList(List<AssetRegistrationItem> newList) {
    final _$actionInfo = _$_AssetRegistrationStoreActionController.startAction(
        name: '_AssetRegistrationStore.updateList');
    try {
      return super.updateList(newList);
    } finally {
      _$_AssetRegistrationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
itemList: ${itemList},
isFetching: ${isFetching}
    ''';
  }
}
