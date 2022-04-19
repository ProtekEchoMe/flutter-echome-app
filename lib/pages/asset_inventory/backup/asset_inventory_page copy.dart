// import 'package:data_table_2/data_table_2.dart';
// import 'package:echo_me_mobile/data/repository.dart';
// import 'package:echo_me_mobile/di/service_locator.dart';
// import 'package:echo_me_mobile/pages/asset_inventory/backup/datasource.dart';
// import 'package:echo_me_mobile/pages/asset_inventory/inventory_datasource.dart';
// import 'package:flutter/material.dart';

// class AssetInventoryPage extends StatefulWidget {
//   const AssetInventoryPage({Key? key}) : super(key: key);

//   @override
//   State<AssetInventoryPage> createState() => _AssetInventoryPageState();
// }

// class _AssetInventoryPageState extends State<AssetInventoryPage> {
//   int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
//   bool _sortAscending = true;
//   int? _sortColumnIndex;
//   InventoryDataSource _dessertsDataSource = InventoryDataSource(getIt<Repository>());
//   PaginatorController _controller = PaginatorController();

//   bool _dataSourceLoading = false;
//   int _initialRow = 0;

//   void sort(
//     int columnIndex,
//     bool ascending,
//   ) {
//     var columnName = "name";
//     switch (columnIndex) {
//       case 1:
//         columnName = "calories";
//         break;
//       case 2:
//         columnName = "fat";
//         break;
//       case 3:
//         columnName = "carbs";
//         break;
//       case 4:
//         columnName = "protein";
//         break;
//       case 5:
//         columnName = "sodium";
//         break;
//       case 6:
//         columnName = "calcium";
//         break;
//       case 7:
//         columnName = "iron";
//         break;
//     }
//     _dessertsDataSource.sort(columnName, ascending);
//     setState(() {
//       _sortColumnIndex = columnIndex;
//       _sortAscending = ascending;
//     });
//   }

//   @override
//   void dispose() {
//     _dessertsDataSource.dispose();
//     super.dispose();
//   }

//   List<DataColumn> get _columns {
//     return [
//       DataColumn(
//         label: FittedBox(child: Text('Item Code'),),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//       DataColumn(
//         label: Text('Item Description'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//       DataColumn(
//         label: Text('Style Number'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//       DataColumn(
//         label: Text('Color'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//       DataColumn(
//         label: Text('Size'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//       DataColumn(
//         label: Text('Serial Number'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//       DataColumn(
//         label: Text('UPC/EAN'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//       DataColumn(
//         label: Text('Brand'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Country of Origin'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Expiry Date'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Asset Code'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Equipment Code'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Equipment ID'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Inbound Date'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Order Number'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Item Status'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Location'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ), DataColumn(
//         label: Text('Checkpoint'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ), DataColumn(
//         label: Text('Last Location'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Last Checkpoint'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//        DataColumn(
//         label: Text('Reserved Operation'),
//         onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Asset Inventory")),
//       body: Stack(alignment: Alignment.bottomCenter, children: [
//         AsyncPaginatedDataTable2(
//             availableRowsPerPage: [10,20],
//             dataRowHeight: 100,
//             showCheckboxColumn: false,
//             horizontalMargin: 20,
//             checkboxHorizontalMargin: 12,
//             minWidth: 3000,
//             columnSpacing: 0,
//             wrapInCard: false,
//             header: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Text("Assets Inventory")
//               ],
//             ),
//             rowsPerPage: _rowsPerPage,
//             autoRowsToHeight: false,
//             pageSyncApproach: PageSyncApproach.goToFirst,
//             fit: FlexFit.tight,
//             onRowsPerPageChanged: (value) {
//               print('Row per page changed to $value');
//               _rowsPerPage = value!;
//             },
//             initialFirstRowIndex: _initialRow,
//             onPageChanged: (rowIndex) {
//               //print(rowIndex / _rowsPerPage);
//             },
//             sortColumnIndex: _sortColumnIndex,
//             sortAscending: _sortAscending,
//             // onSelectAll: (select) => select == true
//             //     ? _dessertsDataSource.selectAllOnThePage()
//             //     : _dessertsDataSource.deselectAllOnThePage(),
//             controller: _controller,
//             columns: _columns,
//             empty: Center(
//                 child: Container(
//                     padding: EdgeInsets.all(20),
//                     color: Colors.grey[200],
//                     child: Text('No data'))),
//             // errorBuilder: (e) => _ErrorAndRetry(
//             //     e.toString(), () => _dessertsDataSource!.refreshDatasource()),
//             source: _dessertsDataSource),
//       ]),
//     );
//   }
// }
