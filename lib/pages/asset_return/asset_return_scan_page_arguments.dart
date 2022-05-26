// ignore_for_file: prefer_initializing_formals

// import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';
import 'package:echo_me_mobile/models/asset_return/return_item.dart';

class AssetReturnScanPageArguments {
  final String rtnNum;
  ReturnItem? item;
  AssetReturnScanPageArguments(this.rtnNum, {ReturnItem? item}){
    this.item = item;
  }
}