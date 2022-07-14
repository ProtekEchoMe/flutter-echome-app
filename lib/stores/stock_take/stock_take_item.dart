
// import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_line_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_item.dart';
import 'package:mobx/mobx.dart';


part 'stock_take_item.g.dart';

enum StockTakeItemStatus {
  draft,
  pending,
  processing,
  completed
}

class AssetRegistrationHelper {
  static StockTakeItemStatus statusConvertor(String? status){
    if(status == "draft"){
      return StockTakeItemStatus.draft;
    }
    if(status == "pending"){
      return StockTakeItemStatus.pending;
    }
    if(status == "processing"){
      return StockTakeItemStatus.processing;
    }
    return StockTakeItemStatus.completed;
  }
}

class StockTakeItemHolder = _StockTakeItemHolder with _$StockTakeItemHolder;

abstract class _StockTakeItemHolder with Store {
  final String TAG = "_AssetStakeTakeItem";
  final StockTakeItem item;

  _StockTakeItemHolder(this.item){
    orderId = item.stNum.toString();
    status = item.status ?? "";
  }

  @observable
  String orderId = "";

  @observable
  String status = "";

}

class StockTakeLineItemHolder = _StockTakeLineItemHolder with _$StockTakeLineItemHolder;

abstract class _StockTakeLineItemHolder with Store {
  final String TAG = "_AssetStakeTakeItem";
  final StockTakeLineItem item;

  _StockTakeLineItemHolder(this.item){
    orderId = item.stNum.toString();
    status = item.status ?? "";
    locCode = item.locCode.toString();
  }

  @observable
  String orderId = "";

  @observable
  String status = "";

  @observable
  String locCode = "";

}