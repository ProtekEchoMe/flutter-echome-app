import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';

class AssetRegistrationApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AssetRegistrationApi(this._dioClient);

  /// Returns list of post in response
  Future<AssetRegistrationResponse> getAssetRegistration(
      {int page = 0, int limit = 10, String regNumber = ""}) async {
    try {
      print(page * limit);
      print(limit);
      print(regNumber);
      List<dynamic> filter = [];
      if (regNumber.isNotEmpty) {
        filter = [
          {
            "value": regNumber,
            "name": "regNum",
            "operator": "eq",
            "type": "string"
          }
        ];
      }
      Map<String, dynamic> query = {
        "skip": page * limit,
        "limit": limit,
      };

      if (filter.isNotEmpty) {
        query = {
          "skip": page * limit,
          "limit": limit,
          "filterBy": jsonEncode(filter)
        };
      }
      final res = await _dioClient.getRegistration(Endpoints.assetRegistration,
          queryParameters: query);
      print("ok");
      print(res);
      return AssetRegistrationResponse(res["itemRow"], res["totalRow"]);
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
      final res = await _dioClient.getRegistration(Endpoints.getContainerCode,
          queryParameters: query);
      return {"itemList": res["itemRow"]};
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeRegister({String regNum = ""}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.registerComplete, queryParameters: {"regNum": regNum});
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
      final res = await _dioClient
          .get(Endpoints.registerToComplete, queryParameters: {"toNum": toNum});
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
      String containerCode = "",
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
        "containerCode": containerCode,
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

  Future<dynamic> registerToItem(
      {String toNum = "",
      String containerCode = "",
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
        "toNum": toNum,
        "containerCode": containerCode,
        "rfids": str
      };
      // final res = await _dioClient.getRegistration(Endpoints.registerItemsValidation,
      //     queryParameters: query);
      // print(res);
      final res1 = await _dioClient.getRegistration(Endpoints.registerToItems,
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

  Future<dynamic> registerToContainer(
      {List<String> rfid = const [], String toNum = ""}) async {
    try {
      var str = "";
      if (rfid != null) {
        for (var element in rfid) {
          str = str + element + ",";
        }
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

  Future<dynamic> bundleContainerProduct(
      {String docNum = "",
      String containerCode = "",
      List<String> rfid = const []}) async {
    return "a";
  }

  // Future<dynamic> getContainerRfidDetails(
  //     {String rfid = "", String containerCode = ""}) async {
  //   try {
  //     var filter = [];
  //     if (rfid.isNotEmpty) {
  //       filter = [
  //         {"value": rfid, "name": "rfid", "operator": "eq", "type": "string"}
  //       ];
  //     } else if (containerCode.isNotEmpty) {
  //       filter = [
  //         {
  //           "value": containerCode,
  //           "name": "containerCode",
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

class AssetRegistrationResponse {
  List<RegistrationItem> itemList = [];
  int rowNumber = 0;

  AssetRegistrationResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => RegistrationItem.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}
