import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';

class AssetScanPageArguments {
  final String docNum;
  RegistrationItem? item;
  AssetScanPageArguments(this.docNum, {RegistrationItem? item}){
    this.item = item;
  }
}