// ignore_for_file: prefer_initializing_formals

import 'package:echo_me_mobile/models/stock_take/stock_take_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_line_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_loc_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_loc_header.dart';


class StockTakeScanPageArguments {
  final String stNum;
  StockTakeItem? item;
  StockTakeLocItem? stockTakeLineItem;
  StockTakeLocHeader? stockTakeLocHeader;
  StockTakeScanPageArguments(this.stNum, {StockTakeItem? item, StockTakeLocItem? stockTakeLineItem,
    StockTakeLocHeader? stockTakeLocHeader}){
    this.item = item;
    this.stockTakeLineItem = stockTakeLineItem;
    this.stockTakeLocHeader = stockTakeLocHeader;
  }
}

class StockTakeScanPageLineArguments {
  final String stNum;
  StockTakeLineItem? item;
  StockTakeScanPageLineArguments(this.stNum, {StockTakeLineItem? item}){
    this.item = item;
  }
}