// ignore_for_file: prefer_initializing_formals

import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';

class StockTakeScanPageArguments {
  final String regNum;
  RegistrationItem? item;
  StockTakeScanPageArguments(this.regNum, {RegistrationItem? item}){
    this.item = item;
  }
}