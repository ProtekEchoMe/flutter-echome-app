import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/site_code/loc_site_item.dart';

class LocSiteApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  LocSiteApi(this._dioClient);

  /// Returns list of post in response
  Future<LocSiteResponse> listLocSite(
      {int page = 0, int limit = 10, String siteCode = ""}) async {
    try {
      print(page * limit);
      print(limit);
      print(siteCode);
      List<dynamic> filter = [];
      if (siteCode.isNotEmpty) {
        filter = [
          {
            "value": siteCode,
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
      final res = await _dioClient.getRegistration(Endpoints.listLocSite,
          queryParameters: query);
      print("ok");
      print(res);
      return LocSiteResponse(res["itemRow"], res["totalRow"]);
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
      final res = await _dioClient.getRegistration(
          Endpoints.getRfidTagContainer,
          queryParameters: query);
      return {"itemList": res["itemRow"]};
    } catch (e) {
      rethrow;
    }
  }
}

class LocSiteResponse {
  List<LocSiteItem> itemList = [];
  int rowNumber = 0;

  LocSiteResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => LocSiteItem.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}
