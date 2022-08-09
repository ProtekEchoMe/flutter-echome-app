import 'package:echo_me_mobile/data/repository.dart';

import 'package:echo_me_mobile/models/stock_take/stock_take_line_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_item.dart';

import 'package:echo_me_mobile/stores/stock_take/stock_take_item.dart';

import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';

part 'stock_take_store.g.dart';

class StockTakeStore = _StockTakeStore with _$StockTakeStore;

abstract class _StockTakeStore with Store {
  final String TAG = "_StakeTakeStore";

  final ErrorStore errorStore = ErrorStore();

  final Repository repository;

  _StockTakeStore(this.repository);

  @observable
  int page = 0;

  @observable
  int limit = 10;

  @observable
  int totalCount = 0;

  @computed
  int get currentPage => page + 1;

  @computed
  int get totalPage => (totalCount / limit).ceil();

  @observable
  ObservableList<StockTakeItemHolder> itemList =
      ObservableList<StockTakeItemHolder>();

  @observable
  ObservableList<StockTakeLocItemHolder> locList =
  ObservableList<StockTakeLocItemHolder>();

  @observable
  ObservableList<StockTakeLineItemHolder> itemLineHolderList =
      ObservableList<StockTakeLineItemHolder>();

  @observable
  ObservableList<StockTakeLineItem> itemLineList =
  ObservableList<StockTakeLineItem>();

  @observable
  ObservableList<StockTakeLineItem> filtereditemLineList =
  ObservableList<StockTakeLineItem>();

  @observable
  ObservableMap<String, dynamic> statusMap = ObservableMap<String, dynamic>();
  // @computed
  // ObservableList<StockTakeLineItemHolder> itemLineUniLocList = ObservableList<StockTakeLineItemHolder>();

  @computed
  ObservableList<Map<String, dynamic>> get itemLineUniLocList {
    final ObservableList<Map<String, dynamic>> result =
        ObservableList<Map<String, dynamic>>();
    if (itemLineHolderList.isEmpty) {
      return result;
    }

    StockTakeLineItemHolder firstLineItem = itemLineHolderList.first;
    result.add(
        {"locCode": firstLineItem.locCode, "status": firstLineItem.status});
    itemLineHolderList.forEach((element) {
      var tempLoop = [...result];
      bool unique = true;

      tempLoop.forEach((element2) {
        if (element.locCode == element2["locCode"]) {
          unique = false;
        }
      });

      if (unique) {
        result.add({
          "locCode": element.locCode,
          "status": element.status
        });
      }
    });
    // siteCodeNameList.add("0");
    return result;
  }

  @computed
  ObservableList<StockTakeLineItemHolder> get itemLineUniObjLocList {
    final ObservableList<StockTakeLineItemHolder> result =
    ObservableList<StockTakeLineItemHolder>();
    if (itemLineHolderList.isEmpty) {
      return result;
    }

    StockTakeLineItemHolder firstLineItem = itemLineHolderList.first;
    result.add(firstLineItem);
    itemLineHolderList.forEach((element) {
      var tempLoop = [...result];
      bool unique = true;

      tempLoop.forEach((element2) {
        if (element.locCode == element2.locCode) {
          unique = false;
        }
      });

      if (unique) {
        result.add(element);
      }
    });
    // siteCodeNameList.add("0");
    return result;
  }

  @observable
  bool isFetching = false;

  @action
  void addItem(StockTakeItemHolder item) {
    itemList.add(item);
  }

  @action
  void addAllItem(List<StockTakeItemHolder> list) {
    print("????????");
    print(list);
    print(itemList);
    itemList.addAll(list);
    print(itemList.length);
    print("????????");
  }

  @action
  void addAllLineItem(List<StockTakeLineItemHolder> list) {
    print("????????");
    print(list);
    print(itemList);
    itemLineHolderList.addAll(list);
    print(itemList.length);
    print("????????");
  }

  @action
  void addAllLocItem(List<StockTakeLocItemHolder> list) {
    print("????????");
    print(list);
    // print(itemList);
    locList.addAll(list);
    // print(itemList.length);
    totalCount = locList.length;
    print("????????");
  }

  @action
  void removeItem(String orderId) {
    itemList.removeWhere((element) => element.orderId == orderId);
  }

  @action
  void updateList(List<StockTakeItemHolder> newList) {
    itemList = ObservableList.of(newList);
  }

  @action
  void updateStatusList(){
    List<StockTakeLineItem> lineList = filtereditemLineList;
    // Map<String, int> countMap = new Map<String, int>();
    lineList.forEach((element) {
      String status = element.status ?? "";
      if (statusMap.containsKey(status)){
        if (statusMap[status] != null) {
          statusMap[status]["count"] += 1;
          statusMap[status]["stockTakeLineList"].add(element);
        }
      }else{
        statusMap[status] = {"count": 1, "checkBoxController": true, "stockTakeLineList": [element]};
      }
    });
  }

  @action
  void updateFilteredList(){
    filtereditemLineList.clear();
    statusMap.forEach((status, statusDict) {
      statusDict["checkBoxController"] == true ? filtereditemLineList.addAll(statusDict["stockTakeLineList"]) : null;
    });
  }


  @action
  Future<void> nextPage({String docNum = ""}) async {
    if (totalCount >= limit * (page + 1)) {
      fetchData(
        stNum: docNum,
        requestedPage: page + 1,
      );
    }
  }

  @action
  Future<void> prevPage({String docNum = ""}) async {
    if (page >= 1) {
      fetchData(stNum: docNum, requestedPage: page - 1);
    }
  }

  @action
  Future<void> fetchData({String stNum = "", int? requestedPage}) async {
    isFetching = true;
    try {
      var targetPage = requestedPage ?? page;
      var data = await repository.getStockTake(
          page: targetPage, limit: limit, stNum: stNum);
      int totalRow = data.rowNumber;
      List<StockTakeItemHolder> list = data.itemList
          .map((StockTakeItem e) => StockTakeItemHolder(e))
          .toList();
      totalCount = totalRow;
      page = targetPage;
      itemList.clear();
      addAllItem(list);
    } catch (e) {
      print(e);
      errorStore.setErrorMessage("error in fetching data");
    } finally {
      isFetching = false;
      print("finally");
    }
  }

  Future<void> fetchLineData({String stNum = "", int? requestedPage, String? locCode = ""}) async {
    isFetching = true;
    try {
      var targetPage = requestedPage ?? page;
      // var data = await repository.getStockTakeLine(
      //     page: targetPage, limit: limit, stNum: stNum);
      var data = await repository.getStockTakeLine(
          page: targetPage, limit: 0, stNum: stNum, locCode: locCode ?? "");
      int totalRow = data.rowNumber;
      itemLineList = ObservableList.of(data.itemList);
      filtereditemLineList = itemLineList;
      List<StockTakeLineItemHolder> list = data.itemList
          .map((StockTakeLineItem e) => StockTakeLineItemHolder(e))
          .toList();
      totalCount = totalRow;
      page = targetPage;
      itemList.clear();
      addAllLineItem(list);
    } catch (e) {
      print(e);
      errorStore.setErrorMessage("error in fetching data");
    } finally {
      isFetching = false;
      print("finally");
    }
  }

  @action
  Future<void> completeStockTakeHeader({String stNum = ""}) async {
    try {
      isFetching = true;
      await repository.completeStockTakeHeader(stNum: stNum);
    } catch (e) {
      errorStore.setErrorMessage(e.toString());
    } finally {
      isFetching = false;
    }
  }
}
