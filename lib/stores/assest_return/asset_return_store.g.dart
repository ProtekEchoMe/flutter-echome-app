// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_return_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AssetReturnStore on _AssetReturnStore, Store {
  Computed<int>? _$currentPageComputed;

  @override
  int get currentPage =>
      (_$currentPageComputed ??= Computed<int>(() => super.currentPage,
              name: '_AssetReturnStore.currentPage'))
          .value;
  Computed<int>? _$totalPageComputed;

  @override
  int get totalPage =>
      (_$totalPageComputed ??= Computed<int>(() => super.totalPage,
              name: '_AssetReturnStore.totalPage'))
          .value;

  final _$pageAtom = Atom(name: '_AssetReturnStore.page');

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

  final _$limitAtom = Atom(name: '_AssetReturnStore.limit');

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

  final _$totalCountAtom = Atom(name: '_AssetReturnStore.totalCount');

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

  final _$itemListAtom = Atom(name: '_AssetReturnStore.itemList');

  @override
  ObservableList<AssetReturnItem> get itemList {
    _$itemListAtom.reportRead();
    return super.itemList;
  }

  @override
  set itemList(ObservableList<AssetReturnItem> value) {
    _$itemListAtom.reportWrite(value, super.itemList, () {
      super.itemList = value;
    });
  }

  final _$isFetchingAtom = Atom(name: '_AssetReturnStore.isFetching');

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

  final _$nextPageAsyncAction = AsyncAction('_AssetReturnStore.nextPage');

  @override
  Future<void> nextPage({String docNum = ""}) {
    return _$nextPageAsyncAction.run(() => super.nextPage(docNum: docNum));
  }

  final _$prevPageAsyncAction = AsyncAction('_AssetReturnStore.prevPage');

  @override
  Future<void> prevPage({String docNum = ""}) {
    return _$prevPageAsyncAction.run(() => super.prevPage(docNum: docNum));
  }

  final _$fetchDataAsyncAction = AsyncAction('_AssetReturnStore.fetchData');

  @override
  Future<void> fetchData({String regNum = "", int? requestedPage}) {
    return _$fetchDataAsyncAction.run(
        () => super.fetchData(regNum: regNum, requestedPage: requestedPage));
  }

  final _$_AssetReturnStoreActionController =
      ActionController(name: '_AssetReturnStore');

  @override
  void addItem(AssetReturnItem item) {
    final _$actionInfo = _$_AssetReturnStoreActionController.startAction(
        name: '_AssetReturnStore.addItem');
    try {
      return super.addItem(item);
    } finally {
      _$_AssetReturnStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAllItem(List<AssetReturnItem> list) {
    final _$actionInfo = _$_AssetReturnStoreActionController.startAction(
        name: '_AssetReturnStore.addAllItem');
    try {
      return super.addAllItem(list);
    } finally {
      _$_AssetReturnStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(String orderId) {
    final _$actionInfo = _$_AssetReturnStoreActionController.startAction(
        name: '_AssetReturnStore.removeItem');
    try {
      return super.removeItem(orderId);
    } finally {
      _$_AssetReturnStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateList(List<AssetReturnItem> newList) {
    final _$actionInfo = _$_AssetReturnStoreActionController.startAction(
        name: '_AssetReturnStore.updateList');
    try {
      return super.updateList(newList);
    } finally {
      _$_AssetReturnStoreActionController.endAction(_$actionInfo);
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
