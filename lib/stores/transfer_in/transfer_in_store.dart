import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/models/transfer_in/transfer_in_header_item.dart';
import 'package:echo_me_mobile/models/transfer_out/transfer_out_header_item.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';

part 'transfer_in_store.g.dart';

class TransferInStore = _TransferOutStore with _$TransferInStore;

abstract class _TransferOutStore with Store {
  final String TAG = "_TransferInStore";

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
  ObservableList<TransferInHeaderItem> itemList = ObservableList<TransferInHeaderItem>();
  
  @observable
  bool isFetching = false;

  @action
  void addItem(TransferInHeaderItem item){
    itemList.add(item);
  }

  @action
  void addAllItem(List<TransferInHeaderItem> list){
    itemList.addAll(list);
  }

  @action 
  void removeItem(int id){
    itemList.removeWhere((element) => element.id == id);
  }

  @action
  void updateList(List<TransferInHeaderItem> newList){
    itemList = ObservableList.of(newList);
  }

  @action
  Future<void> nextPage({String tiNum = ""}) async{
    if(totalCount >= limit* (page+1)){
      fetchData(tiNum: tiNum, requestedPage: page+1);
    }
  }

  @action
  Future<void> prevPage({String tiNum = ""}) async{
    if(page>=1){
      fetchData(tiNum: tiNum, requestedPage: page-1);
    }
  }

  @action
  Future<void> fetchData({String tiNum = "", int? requestedPage}) async {
    isFetching = true;
    try{
      var targetPage = requestedPage ?? page;
      var data = await repository.getTransferInHeader(page: targetPage, limit: limit, tiNum: tiNum);
      int totalRow = data.rowNumber;
      List<TransferInHeaderItem> list = data.itemList;
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