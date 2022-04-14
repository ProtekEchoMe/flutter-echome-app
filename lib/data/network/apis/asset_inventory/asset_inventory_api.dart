import 'dart:convert';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/asset_inventory/asset_inventory_item.dart';


class AssetInventoryApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AssetInventoryApi(this._dioClient);
  

  /// Returns list of post in response
  Future<AssetInventoryResponse> getAssetInventory({int page = 0, int limit = 10, String assetCode = "", String itemCode = "", String siteCode = ""}) async {
    try {
      print(page*limit);
      print(limit);
      List<dynamic> filter = [];
      if (assetCode.isNotEmpty) {
        filter = [
          {
            "value": assetCode,
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
      query["siteCode"]=siteCode;
      final res = await _dioClient.getInventory(
        Endpoints.assetInventory,
        queryParameters: query
      );

      return AssetInventoryResponse(res["itemRow"], res["totalRow"]);
    } catch (e) {
      rethrow;
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
