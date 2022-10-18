// ignore_for_file: unnecessary_new, prefer_collection_literals
import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/models/transfer_out/transfer_out_header_item.dart';
import 'package:echo_me_mobile/models/transfer_out/transfer_out_line_item.dart';
import 'package:echo_me_mobile/pages/transfer_out/transfer_out_scan_page_arguments.dart';
import 'package:echo_me_mobile/widgets/app_content_box.dart';
import 'package:echo_me_mobile/widgets/app_loader.dart';
import 'package:echo_me_mobile/widgets/echo_me_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TransferOutDetailPage extends HookWidget {
  final TransferOutScanPageArguments arg;
  final dioClient = getIt<DioClient>();
  final inputFormat = DateFormat('dd/MM/yyyy');
  // TransferOutDetailPage({Key? key, required this.arg}) : super(key: key);
  TransferOutDetailPage({Key? key, required this.arg}) : super(key: key);

  Widget _getListBox(bool isFetching, List<ListTransferOutLineItem> dataList) {
    return Expanded(
      child: Builder(builder: (context) {
        return isFetching
            ? const AppLoader()
            : AppContentBox(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: ((context, index) {
                        final listItemJson = dataList[index].toJson();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: listItemJson.keys.map((e) {
                                var data = listItemJson[e];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${e}: ${data}"),
                                    const SizedBox(
                                      width: double.maxFinite,
                                      height: 5,
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          )),
                        );
                      })),
                ),
              );
      }),
    );
  }

  Widget _getDocumentInfo(
      String totalProduct, String totalQuantity, String totalTracker) {
    String? dataString =
        arg.item?.createdDate != null ? arg.item?.createdDate!.toString() : "";
    return AppContentBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text( "transferOut".tr(gender: "detail_page_ti_num")
                + ": " + arg.toNum.toString()),
            const SizedBox(height: 5),
            Text(
                "transferOut".tr(gender: "detail_page_ti_date")
                    +": ${dataString!.isNotEmpty ? inputFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataString))) : ""}"),
            const SizedBox(height: 5),
            Text("transferOut".tr(gender: "detail_ship_type")
                +": ${arg.item?.shipType.toString()}"),
            const SizedBox(height: 5),
            Text("transferOut".tr(gender: "detail_page_total_product")
                +" : $totalProduct"),
            const SizedBox(height: 5),
            Text("transferOut".tr(gender: "detail_page_total_quantity")
                +" : $totalQuantity"),
            const SizedBox(height: 5),
            Text("transferOut".tr(gender: "detail_page_tracker")
                +" : $totalTracker")
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalProduct = useState<String>("");
    final totalQuantity = useState<String>("");
    final totalTracker = useState<String>("");
    final isFetching = useState<bool>(false);

    final dataList = useState<List<ListTransferOutLineItem>>([]);

    Future<void> fetchData() async {
      isFetching.value = true;
      try {
        var result = await dioClient
            .get('${Endpoints.listTransferOutLine}?toNum=${arg.toNum}');
        var newTotalProduct = (result as List).length.toString();
        int newTotalQuantity = 0;
        int totalRegQuantity = 0;
        var newDataList = result.map((e) {
          try {
            newTotalQuantity += e["quantity"] as int;
            totalRegQuantity += e["checkinQty"] as int;
          } catch (e) {
            print(e);
          }
          return ListTransferOutLineItem.fromJson(e);
        }).toList();
        dataList.value = newDataList;
        totalProduct.value = newTotalProduct;
        totalQuantity.value = newTotalQuantity.toString();
        totalTracker.value = "$totalRegQuantity/$newTotalQuantity";
      } catch (e) {
        print(e);
      } finally {
        isFetching.value = false;
      }
    }

    useEffect(() {
      fetchData();
      return null;
    }, []);

    return Scaffold(
      appBar: EchoMeAppBar(titleText: "transferOut".tr(gender: "detail_page_title")),
      body: SizedBox.expand(
        child: Column(children: [
          _getDocumentInfo(
              totalProduct.value, totalQuantity.value, totalTracker.value),
          _getListBox(isFetching.value, dataList.value)
        ]),
      ),
    );
  }
}