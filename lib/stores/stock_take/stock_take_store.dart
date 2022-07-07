import 'package:echo_me_mobile/data/repository.dart';
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
  int get totalPage => (totalCount/limit).ceil();

  @observable 
  ObservableList<StockTakeItemHolder> itemList = ObservableList<StockTakeItemHolder>();
  
  @observable
  bool isFetching = false;

  @action
  void addItem(StockTakeItemHolder item){
    itemList.add(item);
  }

  @action
  void addAllItem(List<StockTakeItemHolder> list){
    print("????????");
    print(list);
    print(itemList);
    itemList.addAll(list);
    print(itemList.length);
      print("????????");
  }

  @action 
  void removeItem(String orderId){
    itemList.removeWhere((element) => element.orderId == orderId);
  }

  @action
  void updateList(List<StockTakeItemHolder> newList){
    itemList = ObservableList.of(newList);
  }

  @action
  Future<void> nextPage({String docNum = ""}) async{
    if(totalCount >= limit* (page+1)){
      fetchData(regNum: docNum, requestedPage: page+1, );
    }
  }

  @action
  Future<void> prevPage({String docNum = ""}) async{
    if(page>=1){
      fetchData(regNum: docNum, requestedPage: page-1);
    }
  }

  @action
  Future<void> fetchData({String regNum = "", int? requestedPage}) async {
    isFetching = true;
    try{
      var targetPage = requestedPage ?? page;
      var data = await repository.getStockTake(page: targetPage, limit: limit, regNum: regNum);
      int totalRow = data.rowNumber;
      List<StockTakeItemHolder> list = data.itemList.map((StockTakeItem e) =>StockTakeItemHolder(e)).toList();
      totalCount = totalRow;
      page = targetPage;
      itemList.clear();
      addAllItem(list);
    }catch(e){
      print(e);
      errorStore.setErrorMessage("error in fetching data");
    }finally{
      isFetching = false;
      print("finally");
    }
  }

}