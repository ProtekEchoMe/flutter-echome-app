import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_item.dart';
import 'package:echo_me_mobile/models/asset_return/return_item.dart';
import 'package:echo_me_mobile/stores/assest_return/asset_return_item.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';


part 'asset_return_store.g.dart';

class AssetReturnStore = _AssetReturnStore with _$AssetReturnStore;

abstract class _AssetReturnStore with Store {
  final String TAG = "_AssetReturnStore";

  final ErrorStore errorStore = ErrorStore();

  final Repository repository;

  _AssetReturnStore(this.repository);

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
  ObservableList<AssetReturnItem> itemList = ObservableList<AssetReturnItem>();
  
  @observable
  bool isFetching = false;

  @action
  void addItem(AssetReturnItem item){
    itemList.add(item);
  }

  @action
  void addAllItem(List<AssetReturnItem> list){
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
  void updateList(List<AssetReturnItem> newList){
    itemList = ObservableList.of(newList);
  }

  @action
  Future<void> nextPage({String docNum = ""}) async{
    if(totalCount >= limit* (page+1)){
      fetchData(regNum: docNum, requestedPage: page+1);
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
      var data = await repository.getAssetReturn(page: targetPage, limit: limit, regNumber: regNum);
      int totalRow = data.rowNumber;
      List<AssetReturnItem> list = data.itemList.map((ReturnItem e) =>AssetReturnItem(e)).toList();
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