// import 'package:data_table_2/data_table_2.dart';
// import 'package:echo_me_mobile/data/repository.dart';
// import 'package:flutter/material.dart';
// import 'dart:core';
// class InventoryDataSource extends AsyncDataTableSource {

//   Repository _repository;
  
//   InventoryDataSource(this._repository);

//   String _sortColumn = "skuCode";
//   bool _sortAscending = true;

//   void sort(String columnName, bool ascending) {
//     _sortColumn = columnName;
//     _sortAscending = ascending;
//     refreshDatasource();
//   }

//   @override
//   Future<AsyncRowsResponse> getRows(int startIndex, int limit) async{
//     // TODO: implement getRows
//     int page = startIndex == 0 ? 0 :  (startIndex/limit).floor() ;
//     print("page $page limit $limit");
//     var response = await _repository.getAssetInventory(page: page, limit: limit);
//         var r = AsyncRowsResponse(
//         response. ?? 0,
//         response.rowData!.map((e){
//           return DataRow(
//             key: ValueKey<int>(e.skuCode!),
//             selected: false,
//             cells: [
//               DataCell(Text(e.skuCode.toString())),
//               DataCell(Text(e.itemDescription!)),
//               DataCell(Text(e.styleNumber.toString())),
//               DataCell(Text(e.color.toString())),
//               DataCell(Text(e.size.toString())),
//               DataCell(Text(e.sn.toString())),
//               DataCell(Text(e.upcEan.toString())),
//               DataCell(Text(e.brand.toString())),
//               DataCell(Text(e.coo.toString())),
//               DataCell(Text(e.expDate.toString())),
//               DataCell(Text(e.assetId.toString())),
//               DataCell(Text(e.eqmCode.toString())),
//               DataCell(Text(e.eqmId.toString())),
//               DataCell(Text(e.inboundDate.toString())),
//               DataCell(Text(e.orderNum.toString())),
//               DataCell(Text(e.itemStatus.toString())),
//               DataCell(Text(e.location.toString())),
//               DataCell(Text(e.checkPoint.toString())),
//               DataCell(Text(e.lastLocation.toString())),
//               DataCell(Text(e.lastCheckpoint.toString())),
//               DataCell(Text(e.resOperation.toString()))
//             ]
//           );
//         }).toList());
//     return r;
//   }
  
// }