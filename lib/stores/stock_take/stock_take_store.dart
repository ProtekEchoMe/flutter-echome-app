import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_item.dart';

import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';


part 'stock_take_store.g.dart';

class StakeTakeStore = _StakeTakeStore with _$StakeTakeStore;

abstract class _StakeTakeStore with Store {
  final String TAG = "_StakeTakeStore";

  final ErrorStore errorStore = ErrorStore();

  final Repository repository;

  _StakeTakeStore(this.repository);

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
  ObservableList<StakeTakeItem> itemList = ObservableList<StakeTakeItem>();
  
  @observable
  bool isFetching = false;

  @action
  void addItem(StakeTakeItem item){
    itemList.add(item);
  }

  @action
  void addAllItem(List<StakeTakeItem> list){
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
  void updateList(List<StakeTakeItem> newList){
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
      var data = await repository.getStakeTake(page: targetPage, limit: limit, regNum: regNum);
      int totalRow = data.rowNumber;
      List<StakeTakeItem> list = data.itemList.map((StakeTakeItem e) =>StakeTakeItem(e)).toList();
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