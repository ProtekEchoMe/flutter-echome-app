// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_take_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StockTakeStore on _StockTakeStore, Store {
  Computed<int>? _$currentPageComputed;

  @override
  int get currentPage =>
      (_$currentPageComputed ??= Computed<int>(() => super.currentPage,
              name: '_StockTakeStore.currentPage'))
          .value;
  Computed<int>? _$totalPageComputed;

  @override
  int get totalPage =>
      (_$totalPageComputed ??= Computed<int>(() => super.totalPage,
              name: '_StockTakeStore.totalPage'))
          .value;
  Computed<ObservableList<Map<String, dynamic>>>? _$itemLineUniLocListComputed;

  @override
  ObservableList<Map<String, dynamic>> get itemLineUniLocList =>
      (_$itemLineUniLocListComputed ??=
              Computed<ObservableList<Map<String, dynamic>>>(
                  () => super.itemLineUniLocList,
                  name: '_StockTakeStore.itemLineUniLocList'))
          .value;
  Computed<ObservableList<StockTakeLineItemHolder>>?
      _$itemLineUniObjLocListComputed;

  @override
  ObservableList<StockTakeLineItemHolder> get itemLineUniObjLocList =>
      (_$itemLineUniObjLocListComputed ??=
              Computed<ObservableList<StockTakeLineItemHolder>>(
                  () => super.itemLineUniObjLocList,
                  name: '_StockTakeStore.itemLineUniObjLocList'))
          .value;

  final _$pageAtom = Atom(name: '_StockTakeStore.page');

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

  final _$limitAtom = Atom(name: '_StockTakeStore.limit');

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

  final _$totalCountAtom = Atom(name: '_StockTakeStore.totalCount');

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

  final _$itemListAtom = Atom(name: '_StockTakeStore.itemList');

  @override
  ObservableList<StockTakeItemHolder> get itemList {
    _$itemListAtom.reportRead();
    return super.itemList;
  }

  @override
  set itemList(ObservableList<StockTakeItemHolder> value) {
    _$itemListAtom.reportWrite(value, super.itemList, () {
      super.itemList = value;
    });
  }

  final _$itemLineListAtom = Atom(name: '_StockTakeStore.itemLineList');

  @override
  ObservableList<StockTakeLineItemHolder> get itemLineList {
    _$itemLineListAtom.reportRead();
    return super.itemLineList;
  }

  @override
  set itemLineList(ObservableList<StockTakeLineItemHolder> value) {
    _$itemLineListAtom.reportWrite(value, super.itemLineList, () {
      super.itemLineList = value;
    });
  }

  final _$isFetchingAtom = Atom(name: '_StockTakeStore.isFetching');

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

  final _$nextPageAsyncAction = AsyncAction('_StockTakeStore.nextPage');

  @override
  Future<void> nextPage({String docNum = ""}) {
    return _$nextPageAsyncAction.run(() => super.nextPage(docNum: docNum));
  }

  final _$prevPageAsyncAction = AsyncAction('_StockTakeStore.prevPage');

  @override
  Future<void> prevPage({String docNum = ""}) {
    return _$prevPageAsyncAction.run(() => super.prevPage(docNum: docNum));
  }

  final _$fetchDataAsyncAction = AsyncAction('_StockTakeStore.fetchData');

  @override
  Future<void> fetchData({String stNum = "", int? requestedPage}) {
    return _$fetchDataAsyncAction
        .run(() => super.fetchData(stNum: stNum, requestedPage: requestedPage));
  }

  final _$_StockTakeStoreActionController =
      ActionController(name: '_StockTakeStore');

  @override
  void addItem(StockTakeItemHolder item) {
    final _$actionInfo = _$_StockTakeStoreActionController.startAction(
        name: '_StockTakeStore.addItem');
    try {
      return super.addItem(item);
    } finally {
      _$_StockTakeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAllItem(List<StockTakeItemHolder> list) {
    final _$actionInfo = _$_StockTakeStoreActionController.startAction(
        name: '_StockTakeStore.addAllItem');
    try {
      return super.addAllItem(list);
    } finally {
      _$_StockTakeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAllLineItem(List<StockTakeLineItemHolder> list) {
    final _$actionInfo = _$_StockTakeStoreActionController.startAction(
        name: '_StockTakeStore.addAllLineItem');
    try {
      return super.addAllLineItem(list);
    } finally {
      _$_StockTakeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(String orderId) {
    final _$actionInfo = _$_StockTakeStoreActionController.startAction(
        name: '_StockTakeStore.removeItem');
    try {
      return super.removeItem(orderId);
    } finally {
      _$_StockTakeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateList(List<StockTakeItemHolder> newList) {
    final _$actionInfo = _$_StockTakeStoreActionController.startAction(
        name: '_StockTakeStore.updateList');
    try {
      return super.updateList(newList);
    } finally {
      _$_StockTakeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
page: ${page},
limit: ${limit},
totalCount: ${totalCount},
itemList: ${itemList},
itemLineList: ${itemLineList},
isFetching: ${isFetching},
currentPage: ${currentPage},
totalPage: ${totalPage},
itemLineUniLocList: ${itemLineUniLocList},
itemLineUniObjLocList: ${itemLineUniObjLocList}
    ''';
  }
}
