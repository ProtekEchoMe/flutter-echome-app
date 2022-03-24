import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/asset_inventory/asset_inventory_response.dart';
import 'package:echo_me_mobile/models/asset_inventory/inventory_item.dart';

class AssetInventoryApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AssetInventoryApi(this._dioClient);
  

  /// Returns list of post in response
  Future<InventoryResponse> getAssetInventory({int page = 0, int limit = 10}) async {
    try {
      print(page*limit);
      print(limit);
      final res = await _dioClient.getInventory(
        Endpoints.assetInventory,
        queryParameters: {
          "skip": page*limit,
          "limit": limit,
        }
      );
      return res;
    } catch (e) {
      throw e;
    }
  }
}
