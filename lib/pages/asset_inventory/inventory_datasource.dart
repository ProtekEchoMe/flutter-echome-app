import 'package:data_table_2/data_table_2.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:flutter/material.dart';
import 'dart:core';
class InventoryDataSource extends AsyncDataTableSource {

  Repository _repository;
  
  InventoryDataSource(this._repository);

  String _sortColumn = "itemCode";
  bool _sortAscending = true;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    refreshDatasource();
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int limit) async{
    // TODO: implement getRows
    int page = startIndex == 0 ? 0 :  (startIndex/limit).floor() ;
    print("page $page limit $limit");
    var response = await _repository.getAssetInventory(page: page, limit: limit);
    if(response.totalRow == null){
      throw "Error! can't get total row";
    }
        var r = AsyncRowsResponse(
        response.totalRow!,
        response.itemRow.map((e){
          return DataRow(
            key: ValueKey<int>(e.invId ?? 0),
            selected: false,
            cells: [
              DataCell(Text(e.invId.toString())),
              DataCell(Text(e.itemCode.toString())),
              DataCell(Text(e.skuCode.toString())),
              DataCell(Text(e.assetCode.toString())),
              DataCell(Text(e.description.toString())),
              DataCell(Text(e.style.toString())),
              DataCell(Text(e.color.toString())),
              DataCell(Text(e.size.toString())),
              DataCell(Text(e.serial.toString())),
              DataCell(Text(e.eanupc.toString())),
              DataCell(Text(e.quantity.toString())),
              DataCell(Text(e.locCode.toString())),
              DataCell(Text(e.lastLocCode.toString())),
              DataCell(Text(e.checkpointCode.toString())),
              DataCell(Text(e.lastCheckpointCode.toString())),
              DataCell(Text(e.status.toString())),
              DataCell(Text(e.docPoId.toString())),
              DataCell(Text(e.docPoNum.toString())),
              DataCell(Text(e.createdDate != null ? DateTime.fromMillisecondsSinceEpoch(e.inboundDate!).toLocal().toString(): "")),
              DataCell(Text(e.expiryDate != null ? DateTime.fromMillisecondsSinceEpoch(e.expiryDate!).toLocal().toString() : "")),
              DataCell(Text(e.modifiedDate != null ? DateTime.fromMillisecondsSinceEpoch(e.modifiedDate!).toLocal().toString(): "")),
              DataCell(Text(e.reason.toString()))
            ]
          );
        }).toList());
    return r;
  }
  
}