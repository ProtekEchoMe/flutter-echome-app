

import 'package:echo_me_mobile/models/asset_return/return_item.dart';
import 'package:mobx/mobx.dart';


part 'asset_return_item.g.dart';

enum ReturnItemStatus {
  draft,
  pending,
  processing,
  completed
}

class AssetReturnHelper {
  static ReturnItemStatus statusConvertor(String? status){
    if(status == "draft"){
      return ReturnItemStatus.draft;
    }
    if(status == "pending"){
      return ReturnItemStatus.pending;
    }
    if(status == "processing"){
      return ReturnItemStatus.processing;
    }
    return ReturnItemStatus.completed;
  }
}

class AssetReturnItem = _AssetReturnItem with _$AssetReturnItem;

abstract class _AssetReturnItem with Store {
  final String TAG = "_AssetReturnItem";
  final ReturnItem item;

  _AssetReturnItem(this.item){
    orderId = item.rtnNum.toString();
    status = item.status ?? "";
  }

  @observable
  String orderId = "";

  @observable
  String status = "";

}