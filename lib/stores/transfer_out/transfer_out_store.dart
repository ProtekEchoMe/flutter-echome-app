import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';
import 'package:echo_me_mobile/models/transfer_out/transfer_out_header_item.dart';
import 'package:echo_me_mobile/stores/assest_registration/asset_registration_item.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';


part 'transfer_out_store.g.dart';

class TransferOutStore = _TransferOutStore with _$TransferOutStore;

abstract class _TransferOutStore with Store {
  final String TAG = "_TransferOutStore";

  final ErrorStore errorStore = ErrorStore();

  final Repository repository;

  _TransferOutStore(this.repository);

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
  ObservableList<TransferOutHeaderItem> itemList = ObservableList<TransferOutHeaderItem>();
  
  @observable
  bool isFetching = false;

  @action
  void addItem(TransferOutHeaderItem item){
    itemList.add(item);
  }

  @action
  void addAllItem(List<TransferOutHeaderItem> list){
    print("????????");
    print(list);
    print(itemList);
    itemList.addAll(list);
    print(itemList.length);
      print("????????");
  }

  @action 
  void removeItem(int id){
    itemList.removeWhere((element) => element.id == id);
  }

  @action
  void updateList(List<TransferOutHeaderItem> newList){
    itemList = ObservableList.of(newList);
  }

  @action
  Future<void> nextPage({String docNum = ""}) async{
    if(totalCount >= limit* (page+1)){
      fetchData(shipmentCode: docNum, requestedPage: page+1);
    }
  }

  @action
  Future<void> prevPage({String docNum = ""}) async{
    if(page>=1){
      fetchData(shipmentCode: docNum, requestedPage: page-1);
    }
  }

  @action
  Future<void> fetchData({String shipmentCode = "", int? requestedPage}) async {
    isFetching = true;
    try{
      var targetPage = requestedPage ?? page;
      var data = await repository.getTransferOutHeader(page: targetPage, limit: limit, shipmentCode: shipmentCode);
      int totalRow = data.rowNumber;
      List<TransferOutHeaderItem> list = data.itemList;
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