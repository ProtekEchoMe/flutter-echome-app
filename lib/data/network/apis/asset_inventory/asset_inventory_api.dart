import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/asset_inventory/asset_inventory_item.dart';
import 'package:echo_me_mobile/models/asset_inventory/asset_inventory_response.dart';
import 'package:echo_me_mobile/models/asset_inventory/inventory_item.dart';

class AssetInventoryApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AssetInventoryApi(this._dioClient);
  

  /// Returns list of post in response
  Future<AssetInventoryResponse> getAssetInventory({int page = 0, int limit = 10, String assetId = "", String itemCode = ""}) async {
    try {
      print(page*limit);
      print(limit);
      List<dynamic> filter = [];
      if (assetId.isNotEmpty) {
        filter = [
          {
            "value": assetId,
            "name": "assetCode",
            "operator": "eq",
            "type": "string"
          }
        ];
      }
      if (itemCode.isNotEmpty) {
        filter = [
          {
            "value": itemCode,
            "name": "itemCode",
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

      final res = await _dioClient.getInventory(
        Endpoints.assetInventory,
        queryParameters: query
      );

      return AssetInventoryResponse(res["itemRow"], res["totalRow"]);
    } catch (e) {
      throw e;
    }
  }
}


class AssetInventoryResponse {
  List<AssetInventoryItem> itemList = [];
  int rowNumber = 0;

  AssetInventoryResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => AssetInventoryItem.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}
