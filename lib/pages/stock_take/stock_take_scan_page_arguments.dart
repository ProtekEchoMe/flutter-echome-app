// ignore_for_file: prefer_initializing_formals

import 'package:echo_me_mobile/models/stock_take/stock_take_item.dart';

class StockTakeScanPageArguments {
  final String regNum;
  StockTakeItem? item;
  StockTakeScanPageArguments(this.regNum, {StockTakeItem? item}){
    this.item = item;
  }
}