// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_inventory_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AssetInventoryStore on _AssetInventoryStore, Store {
  Computed<int>? _$currentPageComputed;

  @override
  int get currentPage =>
      (_$currentPageComputed ??= Computed<int>(() => super.currentPage,
              name: '_AssetInventoryStore.currentPage'))
          .value;
  Computed<int>? _$totalPageComputed;

  @override
  int get totalPage =>
      (_$totalPageComputed ??= Computed<int>(() => super.totalPage,
              name: '_AssetInventoryStore.totalPage'))
          .value;

  final _$pageAtom = Atom(name: '_AssetInventoryStore.page');

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

  final _$limitAtom = Atom(name: '_AssetInventoryStore.limit');

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

  final _$totalCountAtom = Atom(name: '_AssetInventoryStore.totalCount');

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

  final _$itemListAtom = Atom(name: '_AssetInventoryStore.itemList');

  @override
  ObservableList<AssetInventoryItem> get itemList {
    _$itemListAtom.reportRead();
    return super.itemList;
  }

  @override
  set itemList(ObservableList<AssetInventoryItem> value) {
    _$itemListAtom.reportWrite(value, super.itemList, () {
      super.itemList = value;
    });
  }

  final _$isFetchingAtom = Atom(name: '_AssetInventoryStore.isFetching');

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

  final _$nextPageAsyncAction = AsyncAction('_AssetInventoryStore.nextPage');

  @override
  Future<void> nextPage(
      {String assetCode = "", String productCode = "", String siteCode = ""}) {
    return _$nextPageAsyncAction.run(() => super.nextPage(
        assetCode: assetCode, productCode: productCode, siteCode: siteCode));
  }

  final _$prevPageAsyncAction = AsyncAction('_AssetInventoryStore.prevPage');

  @override
  Future<void> prevPage(
      {String assetCode = "", String productCode = "", String siteCode = ""}) {
    return _$prevPageAsyncAction.run(() => super.prevPage(
        assetCode: assetCode, productCode: productCode, siteCode: siteCode));
  }

  final _$fetchDataAsyncAction = AsyncAction('_AssetInventoryStore.fetchData');

  @override
  Future<void> fetchData(
      {int? requestedPage,
      String assetCode = "",
      String productCode = "",
      String siteCode = ""}) {
    return _$fetchDataAsyncAction.run(() => super.fetchData(
        requestedPage: requestedPage,
        assetCode: assetCode,
        productCode: productCode,
        siteCode: siteCode));
  }

  final _$_AssetInventoryStoreActionController =
      ActionController(name: '_AssetInventoryStore');

  @override
  void addItem(AssetInventoryItem item) {
    final _$actionInfo = _$_AssetInventoryStoreActionController.startAction(
        name: '_AssetInventoryStore.addItem');
    try {
      return super.addItem(item);
    } finally {
      _$_AssetInventoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAllItem(List<AssetInventoryItem> list) {
    final _$actionInfo = _$_AssetInventoryStoreActionController.startAction(
        name: '_AssetInventoryStore.addAllItem');
    try {
      return super.addAllItem(list);
    } finally {
      _$_AssetInventoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(String id) {
    final _$actionInfo = _$_AssetInventoryStoreActionController.startAction(
        name: '_AssetInventoryStore.removeItem');
    try {
      return super.removeItem(id);
    } finally {
      _$_AssetInventoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateList(List<AssetInventoryItem> newList) {
    final _$actionInfo = _$_AssetInventoryStoreActionController.startAction(
        name: '_AssetInventoryStore.updateList');
    try {
      return super.updateList(newList);
    } finally {
      _$_AssetInventoryStoreActionController.endAction(_$actionInfo);
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
currentPage: ${currentPage},
totalPage: ${totalPage}
    ''';
  }
}
