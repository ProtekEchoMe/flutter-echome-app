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
  Future<AssetRegistrationResponse> getAssetRegistration({int page = 0, int limit = 10}) async {
    try {
      print(page*limit);
      print(limit);
      final res = await _dioClient.getRegistration(
        Endpoints.assetRegistration,
        queryParameters: {
          "skip": page*limit,
          "limit": limit,
        }
      );
      print("ok");
      print(res);
      return AssetRegistrationResponse(res["itemRow"], res["totalRow"]);
    } catch (e) {
      throw e;
    }
  }
}

class AssetRegistrationResponse {
  List<RegistrationItem> itemList = [];
  int rowNumber = 0;

  AssetRegistrationResponse(dynamic data, int? rowNum){
    try{
        itemList = (data as List<dynamic>).map((e)=> RegistrationItem.fromJson(e)).toList();
    }catch(e){
      print(e);
    }finally{
      rowNumber = rowNum ?? 0;
    }
  }
}
