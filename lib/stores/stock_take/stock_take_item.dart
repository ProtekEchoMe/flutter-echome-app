
// import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_item.dart';
import 'package:mobx/mobx.dart';


part 'stock_take_item.g.dart';

enum StakeTakeItemStatus {
  draft,
  pending,
  processing,
  completed
}

class AssetRegistrationHelper {
  static StakeTakeItemStatus statusConvertor(String? status){
    if(status == "draft"){
      return StakeTakeItemStatus.draft;
    }
    if(status == "pending"){
      return StakeTakeItemStatus.pending;
    }
    if(status == "processing"){
      return StakeTakeItemStatus.processing;
    }
    return StakeTakeItemStatus.completed;
  }
}

class AssetStakeTakeItem = _AssetStakeTakeItem with _$AssetStakeTakeItem;

abstract class _AssetStakeTakeItem with Store {
  final String TAG = "_AssetStakeTakeItem";
  final StakeTakeItem item;

  _AssetStakeTakeItem(this.item){
    orderId = item.regNum.toString();
    status = item.status ?? "";
  }

  @observable
  String orderId = "";

  @observable
  String status = "";

}