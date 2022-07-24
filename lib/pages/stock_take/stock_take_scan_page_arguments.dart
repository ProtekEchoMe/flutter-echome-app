// ignore_for_file: prefer_initializing_formals

import 'package:echo_me_mobile/models/stock_take/stock_take_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_line_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_loc_item.dart';

class StockTakeScanPageArguments {
  final String stNum;
  StockTakeItem? item;
  StockTakeLocItem? stockTakeLineItem;
  StockTakeScanPageArguments(this.stNum, {StockTakeItem? item, StockTakeLocItem? stockTakeLineItem}){
    this.item = item;
    this.stockTakeLineItem = stockTakeLineItem;
  }
}

class StockTakeScanPageLineArguments {
  final String stNum;
  StockTakeLineItem? item;
  StockTakeScanPageLineArguments(this.stNum, {StockTakeLineItem? item}){
    this.item = item;
  }
}