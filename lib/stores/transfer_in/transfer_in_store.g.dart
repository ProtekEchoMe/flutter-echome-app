// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_in_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TransferInStore on _TransferOutStore, Store {
  Computed<int>? _$currentPageComputed;

  @override
  int get currentPage =>
      (_$currentPageComputed ??= Computed<int>(() => super.currentPage,
              name: '_TransferOutStore.currentPage'))
          .value;
  Computed<int>? _$totalPageComputed;

  @override
  int get totalPage =>
      (_$totalPageComputed ??= Computed<int>(() => super.totalPage,
              name: '_TransferOutStore.totalPage'))
          .value;

  final _$pageAtom = Atom(name: '_TransferOutStore.page');

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

  final _$limitAtom = Atom(name: '_TransferOutStore.limit');

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

  final _$totalCountAtom = Atom(name: '_TransferOutStore.totalCount');

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

  final _$itemListAtom = Atom(name: '_TransferOutStore.itemList');

  @override
  ObservableList<TransferOutHeaderItem> get itemList {
    _$itemListAtom.reportRead();
    return super.itemList;
  }

  @override
  set itemList(ObservableList<TransferOutHeaderItem> value) {
    _$itemListAtom.reportWrite(value, super.itemList, () {
      super.itemList = value;
    });
  }

  final _$isFetchingAtom = Atom(name: '_TransferOutStore.isFetching');

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

  final _$nextPageAsyncAction = AsyncAction('_TransferOutStore.nextPage');

  @override
  Future<void> nextPage({String toNum = ""}) {
    return _$nextPageAsyncAction.run(() => super.nextPage(toNum: toNum));
  }

  final _$prevPageAsyncAction = AsyncAction('_TransferOutStore.prevPage');

  @override
  Future<void> prevPage({String toNum = ""}) {
    return _$prevPageAsyncAction.run(() => super.prevPage(toNum: toNum));
  }

  final _$fetchDataAsyncAction = AsyncAction('_TransferOutStore.fetchData');

  @override
  Future<void> fetchData({String toNum = "", int? requestedPage}) {
    return _$fetchDataAsyncAction
        .run(() => super.fetchData(toNum: toNum, requestedPage: requestedPage));
  }

  final _$_TransferOutStoreActionController =
      ActionController(name: '_TransferOutStore');

  @override
  void addItem(TransferOutHeaderItem item) {
    final _$actionInfo = _$_TransferOutStoreActionController.startAction(
        name: '_TransferOutStore.addItem');
    try {
      return super.addItem(item);
    } finally {
      _$_TransferOutStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAllItem(List<TransferOutHeaderItem> list) {
    final _$actionInfo = _$_TransferOutStoreActionController.startAction(
        name: '_TransferOutStore.addAllItem');
    try {
      return super.addAllItem(list);
    } finally {
      _$_TransferOutStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(int id) {
    final _$actionInfo = _$_TransferOutStoreActionController.startAction(
        name: '_TransferOutStore.removeItem');
    try {
      return super.removeItem(id);
    } finally {
      _$_TransferOutStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateList(List<TransferOutHeaderItem> newList) {
    final _$actionInfo = _$_TransferOutStoreActionController.startAction(
        name: '_TransferOutStore.updateList');
    try {
      return super.updateList(newList);
    } finally {
      _$_TransferOutStoreActionController.endAction(_$actionInfo);
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
