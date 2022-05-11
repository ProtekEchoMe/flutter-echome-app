// ignore_for_file: prefer_initializing_formals

import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';

class AssetReturnScanPageArguments {
  final String regNum;
  RegistrationItem? item;
  AssetReturnScanPageArguments(this.regNum, {RegistrationItem? item}){
    this.item = item;
  }
}