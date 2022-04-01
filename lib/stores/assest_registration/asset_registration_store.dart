import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';
import 'package:echo_me_mobile/stores/assest_registration/asset_registration_item.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';


part 'asset_registration_store.g.dart';

class AssetRegistrationStore = _AssetRegistrationStore with _$AssetRegistrationStore;

abstract class _AssetRegistrationStore with Store {
  final String TAG = "_AssetRegistrationStore";

  final ErrorStore errorStore = ErrorStore();

  final Repository repository;

  _AssetRegistrationStore(this.repository);

  @observable
  int page = 0;

  @observable
  int limit = 10;

  @observable
  int totalCount = 0;

  @computed
  int get totalPage => (totalCount/limit).ceil();

  @observable 
  ObservableList<AssetRegistrationItem> itemList = ObservableList<AssetRegistrationItem>();
  
  @observable
  bool isFetching = false;

  @action
  void addItem(AssetRegistrationItem item){
    itemList.add(item);
  }

  @action
  void addAllItem(List<AssetRegistrationItem> list){
    itemList.addAll(list);
  }

  @action 
  void removeItem(String orderId){
    itemList.removeWhere((element) => element.orderId == orderId);
  }

  @action
  void updateList(List<AssetRegistrationItem> newList){
    itemList = ObservableList.of(newList);
  }

  @action
  Future<void> fetchData({String docNum = ""}) async {
    isFetching = true;
    try{
      var data = await repository.getAssetRegistration(page: page, limit: limit, docNumber: docNum);
      List<RegistrationItem> itemList = data.itemList;
      List<AssetRegistrationItem> list = itemList.map((RegistrationItem e) =>AssetRegistrationItem(e)).toList();
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