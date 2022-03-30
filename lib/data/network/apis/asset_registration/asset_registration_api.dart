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
      if (docNumber != null) {
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

  static final List<String> placeholderList = [];

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
