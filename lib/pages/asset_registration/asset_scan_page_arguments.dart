// ignore_for_file: prefer_initializing_formals

import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';

class AssetScanPageArguments {
  final String regNum;
  RegistrationItem? item;
  AssetScanPageArguments(this.regNum, {RegistrationItem? item}){
    this.item = item;
  }
}