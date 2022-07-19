// ignore_for_file: prefer_initializing_formals

import 'package:echo_me_mobile/models/stock_take/stock_take_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_line_item.dart';

class StockTakeScanPageArguments {
  final String stNum;
  StockTakeItem? item;
  StockTakeScanPageArguments(this.stNum, {StockTakeItem? item}){
    this.item = item;
  }
}

class StockTakeScanPageLineArguments {
  final String stNum;
  StockTakeLineItem? item;
  StockTakeScanPageLineArguments(this.stNum, {StockTakeLineItem? item}){
    this.item = item;
  }
}