import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/transfer_out/rfid_tag_item.dart';
import 'package:echo_me_mobile/models/transfer_out/transfer_out_header_item.dart';
import 'package:echo_me_mobile/models/transfer_out/transfer_out_order_detail.dart';

class TransferOutApi {
  final DioClient _dioClient;

  TransferOutApi(this._dioClient);

  Future<TransferOutHeaderResponse> getTransferOutHeaderItem(
      {int page = 0, int limit = 10, String toNum = ""}) async {
    try {
      print(page * limit);
      print(limit);
      print(toNum);
      List<dynamic> filter = [];
      Map sortInfo = {};

      // public enum STATUS {
      //   IMPORTED, RFID_TAG_PRINTED, TRANSFER_OUT_WIP, COMPLETED, ONHOLD, CANCELLED
    // }


    filter.add({
        "value": ['IMPORTED', 'RFID_TAG_PRINTED', 'TRANSFER_OUT_WIP', 'ONHOLD'],
        "name": "status",
        "operator": "in",
        "type": "select"
      });

      sortInfo = {"id": 1, "name": "modifiedDate", "type": "", "dir": -1};

      if (toNum.isNotEmpty) {
        filter.add(
          {
            "value": toNum,
            "name": "toNum",
            "operator": "contains",
            "type": "string"
          }
        );
      }else{
        // filter = [
        //   {
        //     "value": "RFID_TAG_PRINTED",
        //     "name": "status",
        //     "operator": "eq",
        //     "type": "select"
        //   }
        // ];
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
          Endpoints.listTransferOutHeader,
          queryParameters: query);
      print("ok");
      print(res);
      return TransferOutHeaderResponse(res["itemRow"], res["totalRow"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<TransferOutHeaderItem> createTransferOutHeaderItem(
      {int? toSite}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.createDirectTo, queryParameters: {"toSite": toSite});
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
      {String toNum = "",
      String containerAssetCode = "",
      List<String> itemRfid = const [],
      bool directTO = false}) async {
    try {
      var str = "";
      for (var element in itemRfid) {
        str = str + element + ",";
      }

      str = str.substring(0, str.length - 1);
      Map<String, dynamic> query = {
        "toNum": toNum,
        "containerAssetCode": containerAssetCode,
        "rfids": str
      };

      if (!directTO) {
        await _dioClient.getRegistration(Endpoints.registerToItems,
            queryParameters: query);
      } else {
        await _dioClient.getRegistration(Endpoints.registerToItemsDirect,
            queryParameters: query);
      }
    }
    // final res1 = await _dioClient.getRegistration(Endpoints.registerToItems,
    //     queryParameters: query);
    // print(res1); // debug
    catch (e) {
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
      await _dioClient
          .get(Endpoints.registerToComplete, queryParameters: {"toNum": toNum});
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

  Future<dynamic> getTransferOutLine(
      {int page = 0, int limit = 0, String toNum = ""}) async {
    try {
      print(page * limit);
      print(limit);
      print(toNum);
      List<dynamic> filter = [];
      Map sortInfo = {};

      sortInfo = {
        "id": 1,
        "name": "checkinQty",
        "type": "",
        "dir": -1
      };

      if (toNum.isNotEmpty) {
        filter = [
          {
            "value": toNum,
            "name": "toNum",
            "operator": "eq",
            "type": "string"
          },
          // {
          //   "value": "COMPLETED",
          //   "name": "status",
          //   "operator": "eq",
          //   "type": "string"
          // }
        ];
      }

      Map<String, dynamic> query = {
        "skip": page * limit,
        "limit": limit,
        "sortInfo": jsonEncode(sortInfo)
      };

      if (filter.isNotEmpty) {
        query = {
          "skip": page * limit,
          "limit": limit,
          "filterBy": jsonEncode(filter),
          "sortInfo": jsonEncode(sortInfo)
        };
      }
      final res = await _dioClient.getRegistration(Endpoints.listTransferOutLine,
          queryParameters: query);
      print("ok");
      print(res);
      return res["itemRow"];
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getOrderDetail({String toNum = "", site = 2}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.getORderDetailTO, queryParameters: {"toNum": toNum, "site": site});
      var result = TransferOutOrderDetailResponse(res, res.length);
      return result;
    } catch (e) {
      if (e is DioError) {
        // if (e.response?.statusCode == 500) {
        //   throw Exception("Internal Server Error");
        // }
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

  Future<dynamic> getRfidTagItem(
      {
        List<String> itemRfid = const [],
        }) async {
    try {
      var str = "";
      for (var element in itemRfid) {
        str = str + element + ",";
      }

      str = str.substring(0, str.length - 1);
      Map<String, dynamic> query = {
        "rfids": str
      };

      final res = await _dioClient.get(Endpoints.getRfidTagItem,
          queryParameters: query);

      var result = RfidTagItemResponse(res, res.length);
      return result;

    }
    // final res1 = await _dioClient.getRegistration(Endpoints.registerToItems,
    //     queryParameters: query);
    // print(res1); // debug
    catch (e) {
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

class TransferOutOrderDetailResponse {
  List<TransferOutOrderDetail> itemList = [];
  int rowNumber = 0;

  TransferOutOrderDetailResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => TransferOutOrderDetail.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}

class RfidTagItemResponse {
  List<RfidTagItem> itemList = [];
  int rowNumber = 0;

  RfidTagItemResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => RfidTagItem.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}
