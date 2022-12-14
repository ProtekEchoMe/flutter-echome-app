import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/asset_return/return_item.dart';
import 'package:echo_me_mobile/models/asset_return/return_order_detail.dart';

class AssetReturnApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AssetReturnApi(this._dioClient);

  /// Returns list of post in response
  Future<AssetReturnResponse> getAssetReturn(
      {int page = 0, int limit = 10, String rtnNum = ""}) async {
    try {
      print(page * limit);
      print(limit);
      print(rtnNum);
      List<dynamic> filter = [];
      Map sortInfo = {};

      // public enum STATUS {
      //   IMPORTED, RFID_TAG_PRINTED, REGISTERING, COMPLETED, ONHOLD, CANCELLED
    // }

      filter.add({
        "value": ['IMPORTED', 'RFID_TAG_PRINTED', 'REGISTERING', 'ONHOLD'],
        "name": "status",
        "operator": "in",
        "type": "select"
      });

      sortInfo = {
        "id": 1,
        "name": "modifiedDate",
        "type": "",
        "dir": -1
      };

      if (rtnNum.isNotEmpty) {
        filter.add(
          {
            "value": rtnNum,
            "name": "rtnNum",
            "operator": "contains",
            "type": "string"
          }
          );
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
      final res = await _dioClient.getRegistration(Endpoints.assetReturnHeader,
          queryParameters: query);
      print("ok");
      print(res);
      return AssetReturnResponse(res["itemRow"], res["totalRow"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getAssetReturnLine(
      {int page = 0, int limit = 0, String rtnNum = ""}) async {
    try {
      print(page * limit);
      print(limit);
      print(rtnNum);
      List<dynamic> filter = [];
      Map sortInfo = {};

      sortInfo = {
        "id": 1,
        "name": "checkinQty",
        "type": "",
        "dir": -1
      };

      if (rtnNum.isNotEmpty) {
        filter = [
          {
            "value": rtnNum,
            "name": "rtnNum",
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
      final res = await _dioClient.getRegistration(Endpoints.listAssetReturnLine,
          queryParameters: query);
      print("ok");
      print(res);
      return res["itemRow"];
      return AssetReturnResponse(res["itemRow"], res["totalRow"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getContainerDetails({List<String>? rfid}) async {
    try {
      var str = "";
      if (rfid != null) {
        for (var element in rfid) {
          str = str + element + ",";
        }
      }
      Map<String, dynamic> query = {"rfids": str.substring(0, str.length - 1)};
      final res = await _dioClient.getRegistration(Endpoints.getRfidTagContainer,
          queryParameters: query);
      return {"itemList": res["itemRow"]};
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeRegister({String regNum = ""}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.registerItems, queryParameters: {"regNum": regNum});
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

  Future<void> completeArRegister({String rtnNum = ""}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.assetReturnComplete, queryParameters: {"rtnNum": rtnNum});
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

  Future<void> registerItem(
      {String regNum = "",
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
        "regNum": regNum,
        "containerAssetCode": containerAssetCode,
        "rfids": str
      };
      final res1 = await _dioClient.getRegistration(Endpoints.registerItems,
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

  Future<dynamic> registerArItem(
      {String rtnNum = "",
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
        "rtnNum": rtnNum,
        "containerAssetCode": containerAssetCode,
        "rfids": str
      };
      // final res = await _dioClient.getRegistration(Endpoints.registerItemsValidation,
      //     queryParameters: query);
      // print(res);
      final res1 = await _dioClient.getRegistration(Endpoints.assetReturnItems,
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

  Future<dynamic> registerContainer(
      {List<String> rfid = const [], String regNum = ""}) async {
    try {
      var str = "";
      if (rfid != null) {
        for (var element in rfid) {
          str = str + element + ",";
        }
      }
      str = str.substring(0, str.length - 1);
      Map<String, dynamic> query = {"rfids": str, "regNum": regNum};
      final res = await _dioClient.getRegistration(Endpoints.registerContainer,
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

  Future<dynamic> registerArContainer(
      {List<String> rfid = const [], String rtnNum = ""}) async {
    try {
      var str = "";
      if (rfid != null) {
        for (var element in rfid) {
          str = str + element + ",";
        }
      }
      str = str.substring(0, str.length - 1);
      Map<String, dynamic> query = {"rfids": str, "rtnNum": rtnNum};
      final res = await _dioClient.getRegistration(
          Endpoints.assetReturnContainer,
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

  Future<dynamic> getOrderDetail({String rtnNum = "", site = 2}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.getORderDetailAssetReturn, queryParameters: {"rtnNum": rtnNum, "site": site});
      var result = AssetReturnOrderDetailResponse(res, res.length);
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

  // Future<dynamic> getContainerRfidDetails(
  //     {String rfid = "", String containerAssetCode = ""}) async {
  //   try {
  //     var filter = [];
  //     if (rfid.isNotEmpty) {
  //       filter = [
  //         {"value": rfid, "name": "rfid", "operator": "eq", "type": "string"}
  //       ];
  //     } else if (containerAssetCode.isNotEmpty) {
  //       filter = [
  //         {
  //           "value": containerAssetCode,
  //           "name": "containerAssetCode",
  //           "operator": "eq",
  //           "type": "string"
  //         }
  //       ];
  //     }
  //     Map<String, dynamic> query = {"filterBy": jsonEncode(filter)};
  //     final res = await _dioClient.getRegistration(Endpoints.listRfidContainer,
  //         queryParameters: query);
  //     print("ok");
  //     print(res);
  //     return {"itemList": res["itemRow"], "totalRow": res["totalRow"]};
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}

class AssetReturnResponse {
  List<ReturnItem> itemList = [];
  int rowNumber = 0;

  AssetReturnResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => ReturnItem.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}

class AssetReturnOrderDetailResponse {
  List<ReturnOrderDetail> itemList = [];
  int rowNumber = 0;

  AssetReturnOrderDetailResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => ReturnOrderDetail.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}
