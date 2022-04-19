// // ignore_for_file: unnecessary_new, prefer_collection_literals

// import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
// import 'package:echo_me_mobile/data/network/dio_client.dart';
// import 'package:echo_me_mobile/di/service_locator.dart';
// import 'package:echo_me_mobile/models/transfer_out/transfer_out_header_item.dart';
// import 'package:echo_me_mobile/widgets/app_content_box.dart';
// import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:intl/intl.dart';

// class TransferOutDetailPage extends StatefulWidget {
//   final TransferOutHeaderItem arg;
//   const TransferOutDetailPage({Key? key, required this.arg}) : super(key: key);

//   @override
//   State<TransferOutDetailPage> createState() => _TransferOutDetailPageState();
// }

// class _TransferOutDetailPageState extends State<TransferOutDetailPage> {
//   final inputFormat = DateFormat('dd/MM/yyyy');
//   String totalProduct = "";
//   String totalQuantity = "";
//   String totalTracker = "";

//   bool isFetching = false;
//   DioClient repository = getIt<DioClient>();
//   List<ListTransferOutLineItem> dataList = [];

//   Future<void> fetchData() async {
//     var result = await repository.get(
//         '${Endpoints.listTransferOutLine}?toNum=${widget.arg.toNum}');
//     var newTotalProduct = (result as List).length.toString();
//     int newTotalQuantity = 0;
//     int totalRegQuantity = 0;
//     var newDataList = (result as List).map((e) {
//       try {
//         newTotalQuantity += e["quantity"] as int;
//         totalRegQuantity += e["regQty"] as int;
//       } catch (e) {
//         print(e);
//       }
//       return ListTransferOutLineItem.fromJson(e);
//     }).toList();

//     setState(() {
//       dataList = newDataList;
//       totalProduct = newTotalProduct;
//       totalQuantity = newTotalQuantity.toString();
//       totalTracker = "$totalRegQuantity/$newTotalQuantity";
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(widget.arg.createdDate);
//     return Scaffold(
//       appBar: EchoMeAppBar(titleText: "Transfer Out Details"),
//       body: SizedBox.expand(
//         child:
//             Column(children: [_getDocumentInfo(context), _getListBox(context)]),
//       ),
//     );
//   }

//   Widget _getListBox(BuildContext ctx) {
//     print(isFetching);
//     return Expanded(
//       child: Builder(builder: (context) {
//         return isFetching
//             ? const Center(
//                 child: SpinKitChasingDots(
//                 color: Colors.grey,
//                 size: 50.0,
//               ))
//             : _getListBoxList(context);
//       }),
//     );
//   }

//   Widget _getListBoxList(BuildContext ctx) {
//     return AppContentBox(
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Builder(
//             builder: (context) => ListView.builder(
//                 itemCount: dataList.length,
//                 itemBuilder: ((context, index) {
//                   final listItem = dataList[index];
//                   return Builder(builder: (context) {
//                     var listItemJson = listItem.toJson();
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Card(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: listItemJson.keys.map((e) {
//                             var key = e;
//                             var data = listItemJson[e];
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("${e}: ${data}"),
//                                 const SizedBox(width: double.maxFinite, height: 5,)
//                               ],
//                             );
//                           }).toList(),
//                         ),
//                       )),
//                     );
//                   });
//                 }))),
//       ),
//     );
//   }

//   Widget _getDocumentInfo(BuildContext ctx) {
//     String dataString = widget.arg.createdDate != null
//         ? widget.arg.createdDate!.toString()
//         : "";
//     return AppContentBox(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text("Transfer Out Number: " + widget.arg.toNum.toString()),
//             SizedBox(height: 5),
//             // ignore: unnecessary_null_comparison
//             Text(
//                 "Transfer Out Date : ${dataString.isNotEmpty ? inputFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataString))) : ""}"),
//             const SizedBox(height: 5),
//             Text("Ship Type: ${widget.arg.shipType.toString()}"),
//             const SizedBox(height: 5),
//             Text("Total Product : $totalProduct"),
//             const SizedBox(height: 5),
//             Text("Total Quantity : $totalQuantity"),
//             const SizedBox(height: 5),
//             Text("Total Tracker : $totalTracker")
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ListTransferOutLineItem {
//   int? id;
//   int? site;
//   String? toNum;
//   String? containerAssetCode;
//   String? shipToDivision;
//   String? shipToLocation;
//   String? shipType;
//   String? deliveryOrderNum;
//   String? department;
//   String? skuCode;
//   String? skuCode;
//   String? description;
//   String? style;
//   String? color;
//   String? coo;
//   String? rsku;
//   int? quantity;
//   int? regQty;
//   int? containerQty;
//   String? status;
//   String? maker;
//   int? createdDate;
//   int? modifiedDate;

//   ListTransferOutLineItem(
//       {this.id,
//       this.site,
//       this.toNum,
//       this.containerAssetCode,
//       this.shipToDivision,
//       this.shipToLocation,
//       this.shipType,
//       this.deliveryOrderNum,
//       this.department,
//       this.skuCode,
//       this.skuCode,
//       this.description,
//       this.style,
//       this.color,
//       this.coo,
//       this.rsku,
//       this.quantity,
//       this.regQty,
//       this.containerQty,
//       this.status,
//       this.maker,
//       this.createdDate,
//       this.modifiedDate});

//   ListTransferOutLineItem.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     site = json['site'];
//     toNum = json['toNum'];
//     containerAssetCode = json['containerAssetCode'];
//     shipToDivision = json['shipToDivision'];
//     shipToLocation = json['shipToLocation'];
//     shipType = json['shipType'];
//     deliveryOrderNum = json['deliveryOrderNum'];
//     department = json['department'];
//     skuCode = json['skuCode'];
//     skuCode = json['skuCode'];
//     description = json['description'];
//     style = json['style'];
//     color = json['color'];
//     coo = json['coo'];
//     rsku = json['rsku'];
//     quantity = json['quantity'];
//     regQty = json['regQty'];
//     containerQty = json['containerQty'];
//     status = json['status'];
//     maker = json['maker'];
//     createdDate = json['createdDate'];
//     modifiedDate = json['modifiedDate'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['site'] = site;
//     data['toNum'] = toNum;
//     data['containerAssetCode'] = containerAssetCode;
//     data['shipToDivision'] = shipToDivision;
//     data['shipToLocation'] = shipToLocation;
//     data['shipType'] = shipType;
//     data['deliveryOrderNum'] = deliveryOrderNum;
//     data['department'] = department;
//     data['skuCode'] = skuCode;
//     data['skuCode'] = skuCode;
//     data['description'] = description;
//     data['style'] = style;
//     data['color'] = color;
//     data['coo'] = coo;
//     data['rsku'] = rsku;
//     data['quantity'] = quantity;
//     data['regQty'] = regQty;
//     data['containerQty'] = containerQty;
//     data['status'] = status;
//     data['maker'] = maker;
//     data['createdDate'] = createdDate;
//     data['modifiedDate'] = modifiedDate;
//     return data;
//   }
// }
