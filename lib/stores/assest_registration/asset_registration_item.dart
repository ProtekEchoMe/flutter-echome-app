
import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';
import 'package:mobx/mobx.dart';


part 'asset_registration_item.g.dart';

enum RegistrationItemStatus {
  draft,
  pending,
  processing,
  completed
}

class AssetRegistrationHelper {
  static RegistrationItemStatus statusConvertor(String? status){
    if(status == "draft"){
      return RegistrationItemStatus.draft;
    }
    if(status == "pending"){
      return RegistrationItemStatus.pending;
    }
    if(status == "processing"){
      return RegistrationItemStatus.processing;
    }
    return RegistrationItemStatus.completed;
  }
}

class AssetRegistrationItem = _AssetRegistrationItem with _$AssetRegistrationItem;

abstract class _AssetRegistrationItem with Store {
  final String TAG = "_AssetRegistrationItem ";
  final RegistrationItem item;

  _AssetRegistrationItem(this.item){
    orderId = item.docNum.toString();
    supplierName ="DocType :" + item.docType.toString();
    status = item.status ?? "";
  }

  @observable
  String orderId = "";

  @observable
  String supplierName = "";

  // @observable
  // RegistrationItemStatus status = RegistrationItemStatus.draft;

  
  @observable
  String status = "";

  // @action
  // void updateStatus(RegistrationItemStatus status){
  //   if(this.status != status){
  //     this.status = status;
  //   }
  // }
}