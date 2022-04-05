// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class DessertDataSourceAsync extends AsyncDataTableSource {
//   DessertDataSourceAsync() {
//     print('DessertDataSourceAsync created');
//   }

//   DessertDataSourceAsync.empty() {
//     _empty = true;
//     print('DessertDataSourceAsync.empty created');
//   }

//   DessertDataSourceAsync.error() {
//     _errorCounter = 0;
//     print('DessertDataSourceAsync.error created');
//   }

//   bool _empty = false;
//   int? _errorCounter;

//   RangeValues? _caloriesFilter;

//   RangeValues? get caloriesFilter => _caloriesFilter;
//   set caloriesFilter(RangeValues? calories) {
//     _caloriesFilter = calories;
//     refreshDatasource();
//   }

//   final DesertsFakeWebService _repo = DesertsFakeWebService();

//   String _sortColumn = "name";
//   bool _sortAscending = true;

//   void sort(String columnName, bool ascending) {
//     _sortColumn = columnName;
//     _sortAscending = ascending;
//     refreshDatasource();
//   }

//   Future<int> getTotalRecords() {
//     return Future<int>.delayed(
//         Duration(milliseconds: 0), () => _empty ? 0 : _dessertsX3.length);
//   }

//   @override
//   Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
//     print('getRows($startIndex, $count)');
//     if (_errorCounter != null) {
//       _errorCounter = _errorCounter! + 1;

//       if (_errorCounter! % 2 == 1) {
//         await Future.delayed(Duration(milliseconds: 1000));
//         throw 'Error #${((_errorCounter! - 1) / 2).round() + 1} has occured';
//       }
//     }

//     var index = startIndex;
//     final format = NumberFormat.decimalPercentPattern(
//       locale: 'en',
//       decimalDigits: 0,
//     );
//     assert(index >= 0);

//     // List returned will be empty is there're fewer items than startingAt
//     var x = _empty
//         ? await Future.delayed(Duration(milliseconds: 2000),
//             () => DesertsFakeWebServiceResponse(0, []))
//         : await _repo.getData(
//             startIndex, count, _caloriesFilter, _sortColumn, _sortAscending);

//     var r = AsyncRowsResponse(
//         x.totalRecords,
//         x.data.map((dessert) {
//           return DataRow(
//             key: ValueKey<int>(dessert.id),
//             selected: dessert.selected,
//             onSelectChanged: (value) {
//               // if (value != null)
//               //   setRowSelection(ValueKey<int>(dessert.id), value);
//             },
//             cells: [
//               DataCell(Text(dessert.name)),
//               DataCell(Text('${dessert.calories}')),
//               DataCell(Text(dessert.fat.toStringAsFixed(1))),
//               DataCell(Text('${dessert.carbs}')),
//               DataCell(Text(dessert.protein.toStringAsFixed(1))),
//               DataCell(Text('${dessert.sodium}')),
//               DataCell(Text('${format.format(dessert.calcium / 100)}')),
//               DataCell(Text('${format.format(dessert.iron / 100)}')),
//             ],
//           );
//         }).toList());

//     return r;
//   }
// }

// class DesertsFakeWebServiceResponse {
//   DesertsFakeWebServiceResponse(this.totalRecords, this.data);

//   /// THe total ammount of records on the server, e.g. 100
//   final int totalRecords;

//   /// One page, e.g. 10 reocrds
//   final List<Dessert> data;
// }

// class DesertsFakeWebService {
//   int Function(Dessert, Dessert)? _getComparisonFunction(
//       String column, bool ascending) {
//     var coef = ascending ? 1 : -1;
//     switch (column) {
//       case 'name':
//         return (Dessert d1, Dessert d2) => coef * d1.name.compareTo(d2.name);
//       case 'calories':
//         return (Dessert d1, Dessert d2) => coef * (d1.calories - d2.calories);
//       case 'fat':
//         return (Dessert d1, Dessert d2) => coef * (d1.fat - d2.fat).round();
//       case 'carbs':
//         return (Dessert d1, Dessert d2) => coef * (d1.carbs - d2.carbs);
//       case 'protein':
//         return (Dessert d1, Dessert d2) =>
//             coef * (d1.protein - d2.protein).round();
//       case 'sodium':
//         return (Dessert d1, Dessert d2) => coef * (d1.sodium - d2.sodium);
//       case 'calcium':
//         return (Dessert d1, Dessert d2) => coef * (d1.calcium - d2.calcium);
//       case 'iron':
//         return (Dessert d1, Dessert d2) => coef * (d1.iron - d2.iron);
//     }

//     return null;
//   }

//   Future<DesertsFakeWebServiceResponse> getData(int startingAt, int count,
//       RangeValues? caloriesFilter, String sortedBy, bool sortedAsc) async {
//     return Future.delayed(
//         Duration(
//             milliseconds: startingAt == 0
//                 ? 2650
//                 : startingAt < 20
//                     ? 2000
//                     : 400), () {
//       var result = _dessertsX3;

//       if (caloriesFilter != null) {
//         result = result
//             .where((e) =>
//                 e.calories >= caloriesFilter.start &&
//                 e.calories <= caloriesFilter.end)
//             .toList();
//       }

//       result.sort(_getComparisonFunction(sortedBy, sortedAsc));
//       return DesertsFakeWebServiceResponse(
//           result.length, result.skip(startingAt).take(count).toList());
//     });
//   }
// }

// List<Dessert> _desserts = <Dessert>[
//   Dessert(
//     'Frozen Yogurt',
//     159,
//     6.0,
//     24,
//     4.0,
//     87,
//     14,
//     1,
//   ),
//   Dessert(
//     'Ice Cream Sandwich',
//     237,
//     9.0,
//     37,
//     4.3,
//     129,
//     8,
//     1,
//   ),
//   Dessert(
//     'Eclair',
//     262,
//     16.0,
//     24,
//     6.0,
//     337,
//     6,
//     7,
//   ),
//   Dessert(
//     'Cupcake',
//     305,
//     3.7,
//     67,
//     4.3,
//     413,
//     3,
//     8,
//   ),
//   Dessert(
//     'Gingerbread',
//     356,
//     16.0,
//     49,
//     3.9,
//     327,
//     7,
//     16,
//   ),
//   Dessert(
//     'Jelly Bean',
//     375,
//     0.0,
//     94,
//     0.0,
//     50,
//     0,
//     0,
//   ),
//   Dessert(
//     'Lollipop',
//     392,
//     0.2,
//     98,
//     0.0,
//     38,
//     0,
//     2,
//   ),
//   Dessert(
//     'Honeycomb',
//     408,
//     3.2,
//     87,
//     6.5,
//     562,
//     0,
//     45,
//   ),
//   Dessert(
//     'Donut',
//     452,
//     25.0,
//     51,
//     4.9,
//     326,
//     2,
//     22,
//   ),
//   Dessert(
//     'Apple Pie',
//     518,
//     26.0,
//     65,
//     7.0,
//     54,
//     12,
//     6,
//   ),
//   Dessert(
//     'Frozen Yougurt with sugar',
//     168,
//     6.0,
//     26,
//     4.0,
//     87,
//     14,
//     1,
//   ),
//   Dessert(
//     'Ice Cream Sandich with sugar',
//     246,
//     9.0,
//     39,
//     4.3,
//     129,
//     8,
//     1,
//   ),
//   Dessert(
//     'Eclair with sugar',
//     271,
//     16.0,
//     26,
//     6.0,
//     337,
//     6,
//     7,
//   ),
//   Dessert(
//     'Cupcake with sugar',
//     314,
//     3.7,
//     69,
//     4.3,
//     413,
//     3,
//     8,
//   ),
//   Dessert(
//     'Gingerbread with sugar',
//     345,
//     16.0,
//     51,
//     3.9,
//     327,
//     7,
//     16,
//   ),
//   Dessert(
//     'Jelly Bean with sugar',
//     364,
//     0.0,
//     96,
//     0.0,
//     50,
//     0,
//     0,
//   ),
//   Dessert(
//     'Lollipop with sugar',
//     401,
//     0.2,
//     100,
//     0.0,
//     38,
//     0,
//     2,
//   ),
//   Dessert(
//     'Honeycomd with sugar',
//     417,
//     3.2,
//     89,
//     6.5,
//     562,
//     0,
//     45,
//   ),
//   Dessert(
//     'Donut with sugar',
//     461,
//     25.0,
//     53,
//     4.9,
//     326,
//     2,
//     22,
//   ),
//   Dessert(
//     'Apple pie with sugar',
//     527,
//     26.0,
//     67,
//     7.0,
//     54,
//     12,
//     6,
//   ),
//   Dessert(
//     'Forzen yougurt with honey',
//     223,
//     6.0,
//     36,
//     4.0,
//     87,
//     14,
//     1,
//   ),
//   Dessert(
//     'Ice Cream Sandwich with honey',
//     301,
//     9.0,
//     49,
//     4.3,
//     129,
//     8,
//     1,
//   ),
//   Dessert(
//     'Eclair with honey',
//     326,
//     16.0,
//     36,
//     6.0,
//     337,
//     6,
//     7,
//   ),
//   Dessert(
//     'Cupcake with honey',
//     369,
//     3.7,
//     79,
//     4.3,
//     413,
//     3,
//     8,
//   ),
//   Dessert(
//     'Gignerbread with hone',
//     420,
//     16.0,
//     61,
//     3.9,
//     327,
//     7,
//     16,
//   ),
//   Dessert(
//     'Jelly Bean with honey',
//     439,
//     0.0,
//     106,
//     0.0,
//     50,
//     0,
//     0,
//   ),
//   Dessert(
//     'Lollipop with honey',
//     456,
//     0.2,
//     110,
//     0.0,
//     38,
//     0,
//     2,
//   ),
//   Dessert(
//     'Honeycomd with honey',
//     472,
//     3.2,
//     99,
//     6.5,
//     562,
//     0,
//     45,
//   ),
//   Dessert(
//     'Donut with honey',
//     516,
//     25.0,
//     63,
//     4.9,
//     326,
//     2,
//     22,
//   ),
//   Dessert(
//     'Apple pie with honey',
//     582,
//     26.0,
//     77,
//     7.0,
//     54,
//     12,
//     6,
//   ),
// ];

// List<Dessert> _dessertsX3 = _desserts.toList()
//   ..addAll(_desserts.map((i) => Dessert(i.name + ' x2', i.calories, i.fat,
//       i.carbs, i.protein, i.sodium, i.calcium, i.iron)))
//   ..addAll(_desserts.map((i) => Dessert(i.name + ' x3', i.calories, i.fat,
//       i.carbs, i.protein, i.sodium, i.calcium, i.iron)));

// class Dessert {
//   Dessert(
//     this.name,
//     this.calories,
//     this.fat,
//     this.carbs,
//     this.protein,
//     this.sodium,
//     this.calcium,
//     this.iron,
//   );

//   final int id = _idCounter++;

//   final String name;
//   final int calories;
//   final double fat;
//   final int carbs;
//   final double protein;
//   final int sodium;
//   final int calcium;
//   final int iron;
//   bool selected = false;
// }

// int _idCounter = 0;