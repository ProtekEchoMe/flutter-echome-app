import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/transfer_in/transfer_in_header_item.dart';

class TransferInApi {
  final DioClient _dioClient;

  TransferInApi(this._dioClient);



  Future<TransferInHeaderResponse> getTransferInHeaderItem(
      {int page = 0, int limit = 10, String tiNum = ""}) async {
    try {
      print(page * limit);
      print(limit);
      print(tiNum);
      List<dynamic> filter = [];
      Map sortInfo = {};

      sortInfo = {
        "id": 1,
        "name": "modifiedDate",
        "type": "",
        "dir": -1
      };

      if (tiNum.isNotEmpty) {
        filter = [
          {"value": tiNum, "name": "tiNum", "operator": "contains", "type": "string"}
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
      final res = await _dioClient.getRegistration(
          Endpoints.listTransferInHeader,
          queryParameters: query);
      print("ok");
      print(res);
      return TransferInHeaderResponse(res["itemRow"], res["totalRow"]);
    } catch (e) {
      rethrow;
    }
  }

    Future<dynamic> registerTiContainer(
      {List<String> rfid = const [], String tiNum = ""}) async {
    try {
      var str = "";
      if (rfid != null) {
        for (var element in rfid) {
          str = str + element + ",";
        }
      }
      str = str.substring(0, str.length - 1);
      Map<String, dynamic> query = {"rfids": str, "tiNum": tiNum};
      final res = await _dioClient.getRegistration(
          Endpoints.registerTiContainer,
          queryParameters: query);
      return {"itemList": res["itemRow"]};
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 500) {
          throw Exception("Internal Server Error");
        }
        if (e.response?.data is String) {
          throw Exception(e.response!.data);
        }
      }
      rethrow;
    }
  }

    Future<dynamic> registerTiItem(
      {String tiNum = "",
      String containerAssetCode = "",
      List<String> itemRfid = const []}) async {
    try {
      var str = "";
      if (itemRfid != null) {
        for (var element in itemRfid) {
          str = str + element + ",";
        }
      }
      str = str.substring(0, str.length - 1);
      Map<String, dynamic> query = {
        "tiNum": tiNum,
        "containerAssetCode": containerAssetCode,
        "rfids": str
      };
      // final res = await _dioClient.getRegistration(Endpoints.registerItemsValidation,
      //     queryParameters: query);
      // print(res);
      final res1 = await _dioClient.getRegistration(Endpoints.registerTiItems,
          queryParameters: query);
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 500) {
          throw Exception("Internal Server Error");
        }
        if (e.response?.data is String) {
          if ((e.response!.data is String).toString().isEmpty) {
            throw Exception("Bad Request");
          }
          throw Exception(e.response?.data);
        }
      }
      rethrow;
    }
  }

   Future<void> completeTiRegister({String tiNum = ""}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.registerTiComplete, queryParameters: {"tiNum": tiNum});
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 500) {
          throw Exception("Internal Server Error");
        }
        if (e.response?.data is String) {
          if ((e.response!.data is String).toString().isEmpty) {
            throw Exception("Bad Request");
          }
          throw Exception(e.response?.data);
        }
      }
      rethrow;
    }
  }
}

class TransferInHeaderResponse {
  List<TransferInHeaderItem> itemList = [];
  int rowNumber = 0;

  TransferInHeaderResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => TransferInHeaderItem.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}
