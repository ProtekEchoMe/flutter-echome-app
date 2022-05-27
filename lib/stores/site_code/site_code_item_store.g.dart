// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_code_item_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SiteCodeItemStore on _SiteCodeItemStore, Store {
  Computed<ObservableList<String?>>? _$siteCodeNameListComputed;

  @override
  ObservableList<String?> get siteCodeNameList =>
      (_$siteCodeNameListComputed ??= Computed<ObservableList<String?>>(
              () => super.siteCodeNameList,
              name: '_SiteCodeItemStore.siteCodeNameList'))
          .value;
  Computed<ObservableList<String?>>? _$filteredSiteCodeNameListComputed;

  @override
  ObservableList<String?> get filteredSiteCodeNameList =>
      (_$filteredSiteCodeNameListComputed ??= Computed<ObservableList<String?>>(
              () => super.filteredSiteCodeNameList,
              name: '_SiteCodeItemStore.filteredSiteCodeNameList'))
          .value;

  final _$pageAtom = Atom(name: '_SiteCodeItemStore.page');

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

  final _$limitAtom = Atom(name: '_SiteCodeItemStore.limit');

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

  final _$totalCountAtom = Atom(name: '_SiteCodeItemStore.totalCount');

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

  final _$siteCodeDataListAtom =
      Atom(name: '_SiteCodeItemStore.siteCodeDataList');

  @override
  ObservableList<LocSiteItem> get siteCodeDataList {
    _$siteCodeDataListAtom.reportRead();
    return super.siteCodeDataList;
  }

  @override
  set siteCodeDataList(ObservableList<LocSiteItem> value) {
    _$siteCodeDataListAtom.reportWrite(value, super.siteCodeDataList, () {
      super.siteCodeDataList = value;
    });
  }

  final _$isFetchingEquDataAtom =
      Atom(name: '_SiteCodeItemStore.isFetchingEquData');

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

  final _$checkedSiteAtom = Atom(name: '_SiteCodeItemStore.checkedSite');

  @override
  ObservableSet<String> get checkedSite {
    _$checkedSiteAtom.reportRead();
    return super.checkedSite;
  }

  @override
  set checkedSite(ObservableSet<String> value) {
    _$checkedSiteAtom.reportWrite(value, super.checkedSite, () {
      super.checkedSite = value;
    });
  }

  final _$chosenSiteAtom = Atom(name: '_SiteCodeItemStore.chosenSite');

  @override
  ObservableList<LocSiteItem> get chosenSite {
    _$chosenSiteAtom.reportRead();
    return super.chosenSite;
  }

  @override
  set chosenSite(ObservableList<LocSiteItem> value) {
    _$chosenSiteAtom.reportWrite(value, super.chosenSite, () {
      super.chosenSite = value;
    });
  }

  final _$isFetchingAtom = Atom(name: '_SiteCodeItemStore.isFetching');

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

  final _$listLocSiteAsyncAction =
      AsyncAction('_SiteCodeItemStore.listLocSite');

  @override
  Future<void> listLocSite(
      {int page = 0,
      int limit = 10,
      String siteCode = "",
      bool throwError = false}) {
    return _$listLocSiteAsyncAction.run(() => super.listLocSite(
        page: page, limit: limit, siteCode: siteCode, throwError: throwError));
  }

  final _$fetchDataAsyncAction = AsyncAction('_SiteCodeItemStore.fetchData');

  @override
  Future<void> fetchData(
      {int page = 0,
      int limit = 10,
      String siteCode = "",
      bool throwError = false}) {
    return _$fetchDataAsyncAction.run(() => super.fetchData(
        page: page, limit: limit, siteCode: siteCode, throwError: throwError));
  }

  final _$_SiteCodeItemStoreActionController =
      ActionController(name: '_SiteCodeItemStore');

  @override
  void addAllItem(List<LocSiteItem> list) {
    final _$actionInfo = _$_SiteCodeItemStoreActionController.startAction(
        name: '_SiteCodeItemStore.addAllItem');
    try {
      return super.addAllItem(list);
    } finally {
      _$_SiteCodeItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
page: ${page},
limit: ${limit},
totalCount: ${totalCount},
siteCodeDataList: ${siteCodeDataList},
isFetchingEquData: ${isFetchingEquData},
checkedSite: ${checkedSite},
chosenSite: ${chosenSite},
isFetching: ${isFetching},
siteCodeNameList: ${siteCodeNameList},
filteredSiteCodeNameList: ${filteredSiteCodeNameList}
    ''';
  }
}
