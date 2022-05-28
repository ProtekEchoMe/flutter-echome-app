import 'dart:convert';

import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/transfer_out/transfer_out_header_item.dart';

class TransferOutApi {
  final DioClient _dioClient;

  TransferOutApi(this._dioClient);

  Future<TransferOutHeaderResponse> getTransferOutHeaderItem({int page = 0, int limit = 10, String toNum=""})async{
      try {
      print(page * limit);
      print(limit);
      print(toNum);
      List<dynamic> filter = [];
      Map sortInfo = {};

      sortInfo = {
        "id": 1,
        "name": "modifiedDate",
        "type": "",
        "dir": -1
      };

      if (toNum.isNotEmpty) {
        filter = [
          {
            "value": toNum,
            "name": "toNum",
            "operator": "contains",
            "type": "string"
          }
        ];
      }
      Map<String, dynamic> query = {
        "skip": page * limit,
        "limit": limit,
        "sortInfo": jsonEncode(sortInfo),
      };

      if (filter.isNotEmpty) {
        query = {
          "skip": page * limit,
          "limit": limit,
          "filterBy": jsonEncode(filter),
          "sortInfo": jsonEncode(sortInfo),
        };
      }
      final res = await _dioClient.getRegistration(Endpoints.listTransferOutHeader,
          queryParameters: query);
      print("ok");
      print(res);
      return TransferOutHeaderResponse(res["itemRow"], res["totalRow"]);
    } catch (e) {
      rethrow;
    }
  }

}

class TransferOutHeaderResponse {
  List<TransferOutHeaderItem> itemList = [];
  int rowNumber = 0;

 TransferOutHeaderResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => TransferOutHeaderItem.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}
