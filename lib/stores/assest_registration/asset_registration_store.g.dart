// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_registration_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AssetRegistrationStore on _AssetRegistrationStore, Store {
  Computed<int>? _$totalPageComputed;

  @override
  int get totalPage =>
      (_$totalPageComputed ??= Computed<int>(() => super.totalPage,
              name: '_AssetRegistrationStore.totalPage'))
          .value;

  final _$pageAtom = Atom(name: '_AssetRegistrationStore.page');

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  final _$limitAtom = Atom(name: '_AssetRegistrationStore.limit');

  @override
  int get limit {
    _$limitAtom.reportRead();
    return super.limit;
  }

  @override
  set limit(int value) {
    _$limitAtom.reportWrite(value, super.limit, () {
      super.limit = value;
    });
  }

  final _$totalCountAtom = Atom(name: '_AssetRegistrationStore.totalCount');

  @override
  int get totalCount {
    _$totalCountAtom.reportRead();
    return super.totalCount;
  }

  @override
  set totalCount(int value) {
    _$totalCountAtom.reportWrite(value, super.totalCount, () {
      super.totalCount = value;
    });
  }

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
  Future<void> fetchData({String docNum = ""}) {
    return _$fetchDataAsyncAction.run(() => super.fetchData(docNum: docNum));
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
page: ${page},
limit: ${limit},
totalCount: ${totalCount},
itemList: ${itemList},
isFetching: ${isFetching},
totalPage: ${totalPage}
    ''';
  }
}
