import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/models/asset_inventory/asset_inventory_item.dart';
import 'package:echo_me_mobile/models/asset_inventory/inventory_item.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';


part 'asset_inventory_store.g.dart';

class AssetInventoryStore = _AssetInventoryStore with _$AssetInventoryStore;

abstract class _AssetInventoryStore with Store {
  final String TAG = "_AssetInventoryStore";

  final ErrorStore errorStore = ErrorStore();

  final Repository repository;

  _AssetInventoryStore(this.repository);

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
  ObservableList<AssetInventoryItem> itemList = ObservableList<AssetInventoryItem>();
  
  @observable
  bool isFetching = false;

  @action
  void addItem(AssetInventoryItem item){
    itemList.add(item);
  }

  @action
  void addAllItem(List<AssetInventoryItem> list){
    itemList.addAll(list);
  }

  @action 
  void removeItem(String id){
    itemList.removeWhere((element) => element.id == id);
  }

  @action
  void updateList(List<AssetInventoryItem> newList){
    itemList = ObservableList.of(newList);
  }

  @action
  Future<void> nextPage({String assetId = "", String itemCode = ""}) async{
    if(totalCount >= limit* (page+1)){
      fetchData(requestedPage: page+1, assetId: assetId, itemCode: itemCode);
    }
  }

  @action
  Future<void> prevPage({String assetId = "", String itemCode = ""}) async{
    if(page>=1){
      fetchData( requestedPage: page-1, assetId: assetId, itemCode: itemCode);
    }
  }

  @action
  Future<void> fetchData({int? requestedPage,String assetId = "", String itemCode = "" }) async {
    isFetching = true;
    try{
      var targetPage = requestedPage ?? page;
      var data = await repository.getAssetInventory(page: targetPage, limit: limit, assetId: assetId, itemCode: itemCode);
      int totalRow = data.rowNumber;
      List<AssetInventoryItem> list = data.itemList;
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