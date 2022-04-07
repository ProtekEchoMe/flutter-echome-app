import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/asset_inventory/asset_inventory_response.dart';
import 'package:echo_me_mobile/models/asset_inventory/inventory_item.dart';
import 'package:echo_me_mobile/models/asset_registration/registration_item.dart';
import 'package:echo_me_mobile/stores/assest_registration/asset_registration_item.dart';

class AssetRegistrationApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AssetRegistrationApi(this._dioClient);

  /// Returns list of post in response
  Future<AssetRegistrationResponse> getAssetRegistration(
      {int page = 0, int limit = 10, String docNumber = ""}) async {
    try {
      print(page * limit);
      print(limit);
      print(docNumber);
      List<dynamic> filter = [];
      if (docNumber.isNotEmpty) {
        filter = [
          {
            "value": docNumber,
            "name": "docNum",
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
      throw e;
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
      Map<String, dynamic> query = {"rfids": str};
      final res = await _dioClient.getRegistration(Endpoints.getContainerCode,
          queryParameters: query);
      return {"itemList": res["itemRow"]};
    } catch (e) {
      throw e;
    }
  }

  Future<void> completeRegister({String docNum = ""}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.registerComplete, queryParameters: {"docNum": docNum});
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
      throw e;
    }
  }

  
  Future<void> completeToRegister({String shipmentCode = ""}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.registerToComplete, queryParameters: {"shipmentCode": shipmentCode});
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
      throw e;
    }
  }

  Future<dynamic> registerItem(
      {String docNum = "",
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
        "docNum": docNum,
        "containerCode": containerCode,
        "rfids": str
      };
      // final res = await _dioClient.getRegistration(Endpoints.registerItemsValidation,
      //     queryParameters: query);
      // print(res);
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
      throw e;
    }
  }

  Future<dynamic> registerToItem(
      {String shipmentCode = "",
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
        "shipmentCode":shipmentCode,
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
      throw e;
    }
  }

  Future<dynamic> registerContainer({List<String> rfid = const []}) async {
    try {
      var str = "";
      if (rfid != null) {
        for (var element in rfid) {
          str = str + element + ",";
        }
      }
      str = str.substring(0, str.length - 1);
      Map<String, dynamic> query = {"rfids": str};
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
      throw e;
    }
  }

  Future<dynamic> registerToContainer({List<String> rfid = const []}) async {
    try {
      var str = "";
      if (rfid != null) {
        for (var element in rfid) {
          str = str + element + ",";
        }
      }
      str = str.substring(0, str.length - 1);
      Map<String, dynamic> query = {"rfids": str};
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
      throw e;
    }
  }

  Future<dynamic> bundleContainerProduct(
      {String docNum = "",
      String containerCode = "",
      List<String> rfid = const []}) async {
    return "a";
  }

  Future<dynamic> getContainerRfidDetails(
      {String rfid = "", String containerCode = ""}) async {
    try {
      var filter = [];
      if (rfid.isNotEmpty) {
        filter = [
          {"value": rfid, "name": "rfid", "operator": "eq", "type": "string"}
        ];
      } else if (containerCode.isNotEmpty) {
        filter = [
          {
            "value": containerCode,
            "name": "containerCode",
            "operator": "eq",
            "type": "string"
          }
        ];
      }
      Map<String, dynamic> query = {"filterBy": jsonEncode(filter)};
      final res = await _dioClient.getRegistration(Endpoints.listRfidContainer,
          queryParameters: query);
      print("ok");
      print(res);
      return {"itemList": res["itemRow"], "totalRow": res["totalRow"]};
    } catch (e) {
      throw e;
    }
  }
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
