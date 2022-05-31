import 'dart:convert';

import 'package:dio/dio.dart';
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

  Future<TransferOutHeaderItem> createTransferOutHeaderItem({int? toSite})async{
    try{
      final res = await _dioClient.get(Endpoints.createDirectTo,
          queryParameters: {"toSite": toSite});
      print("ok");
      print(res);
      return TransferOutHeaderItem.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> registerToContainer(
      {List<String> rfid = const [], String toNum = ""}) async {
    try {
      var str = "";

      for (var element in rfid) {
        str = str + element + ",";
      }
      str = str.substring(0, str.length - 1);
      Map<String, dynamic> query = {"rfids": str, "toNum": toNum};
      final res = await _dioClient.getRegistration(
          Endpoints.registerToContainer,
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

  Future<dynamic> registerToItem(
      {String tiNum = "",
        String containerAssetCode = "",
        List<String> itemRfid = const []}) async {
    try {
      var str = "";
      for (var element in itemRfid) {
        str = str + element + ",";
      }

      str = str.substring(0, str.length - 1);
      Map<String, dynamic> query = {
        "tiNum": tiNum,
        "containerAssetCode": containerAssetCode,
        "rfids": str
      };

      await _dioClient.getRegistration(Endpoints.registerToItems,
          queryParameters: query);

      // final res1 = await _dioClient.getRegistration(Endpoints.registerToItems,
      //     queryParameters: query);
      // print(res1); // debug
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

  Future<void> completeToRegister({String toNum = ""}) async {
    try {
      await _dioClient.get(Endpoints.registerToComplete, queryParameters: {"toNum": toNum});
      // final res = await _dioClient
      //     .get(Endpoints.registerToComplete, queryParameters: {"toNum": toNum});
      // print(res); // debug
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
