import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_line_item.dart';
import 'package:echo_me_mobile/models/stock_take/stock_take_loc_header.dart';

class StockTakeApi {
  //stock Take
  // Endpoints.listStockTakeHeader = "$activeUrl$listStockTakeHeaderMethod";
  // Endpoints.listStockTakeLine = "$activeUrl$listStockTakeLineMethod";
  // Endpoints.newStocktakeHeader = "$activeUrl$newStockTakeHeaderMethod";
  // Endpoints.updateStocktakeHeader = "$activeUrl$updateStockTakeHeaderMethod";
  // Endpoints.removeStocktakeHeader = "$activeUrl$removeStockTakeHeaderMethod";
  // Endpoints.stockTakeInitiate = "$activeUrl$stockTakeInitiateMethod";
  // Endpoints.stockTakeStart = "$activeUrl$stockTakeStartMethod";
  // Endpoints.stockTakeCheckInItems = "$activeUrl$stockTakeCheckInItemsMethod";
  // Endpoints.stockTakeCancel = "$activeUrl$stockTakeCancelMethod";
  // Endpoints.stockTakeComplete  = "$activeUrl$stockTakeCompleteMethod";
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  StockTakeApi(this._dioClient);

  /// Returns list of post in response
  Future<StockTakeResponse> listStockTakeHeader(
      {int page = 0, int limit = 10, String stNum = ""}) async {
    try {
      print(page * limit);
      print(limit);
      print(stNum);
      List<dynamic> filter = [];
      Map sortInfo = {};

      // public enum STATUS {
      //   DRAFT, INITIATED, STOCKTAKING, CANCEL, COMPLETE
    // }
      filter.add({
        "value": ['INITIATED', 'STOCKTAKING'],
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

      if (stNum.isNotEmpty) {
        filter.add({
          "value": stNum,
          "name": "stNum",
          "operator": "contains",
          "type": "string"
        });

      }


      // if (stNum.isNotEmpty) {
      //   filter = [
      //     {
      //       "value": stNum,
      //       "name": "stNum",
      //       "operator": "contains",
      //       "type": "string"
      //     },
      //     {
      //       "value": ["COMPLETE"],
      //       "name": "status",
      //       "operator": "in",
      //       "type": "select"
      //     }
      //   ];
      // }

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
      final res = await _dioClient.getRegistration(Endpoints.listStockTakeHeader,
          queryParameters: query);
      print("ok");
      print(res);
      return StockTakeResponse(res["itemRow"], res["totalRow"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<StockTakeLineResponse> listStockTakeLine(
      {int page = 0, int limit = 0, String stNum = "", String locCode = ""}) async {
    try {
      print(page * limit);
      print(limit);
      print(stNum);
      List<dynamic> filter = [];
      Map sortInfo = {};

      sortInfo = {
        "id": 1,
        "name": "status",
        "type": "",
        "dir": -1
      };

      if (stNum.isNotEmpty) {
        filter.add({
          "value": stNum,
          "name": "stNum",
          "operator": "eq",
          "type": "string"
        });
        // filter = [
        //   {
        //     "value": stNum,
        //     "name": "stNum",
        //     "operator": "eq",
        //     "type": "string"
        //   },
        //   // {
        //   //   "value": "COMPLETED",
        //   //   "name": "status",
        //   //   "operator": "eq",
        //   //   "type": "string"
        //   // }
        // ];
      }

      if (locCode.isNotEmpty) {
        filter.add({
          "value": locCode,
          "name": "locCode",
          "operator": "eq",
          "type": "string"
        });
        // filter = [
        //   {
        //     "value": stNum,
        //     "name": "stNum",
        //     "operator": "eq",
        //     "type": "string"
        //   },
        //   // {
        //   //   "value": "COMPLETED",
        //   //   "name": "status",
        //   //   "operator": "eq",
        //   //   "type": "string"
        //   // }
        // ];
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
      final res = await _dioClient.getRegistration(Endpoints.listStockTakeLine,
          queryParameters: query);
      print("ok");
      print(res);
      // return res["itemRow"];
      return StockTakeLineResponse(res["itemRow"], res["totalRow"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<StockTakeLocHeaderResponse> listStocktakeLocHeader(
      {int page = 0, int limit = 0, String stNum = "", String locCode = ""}) async {
    try {

      Map<String, dynamic> query = {
        "stNum": stNum
      };

      final res = await _dioClient.getRegistration(Endpoints.listStocktakeLocHeader,
          queryParameters: query);
      print("ok");
      print(res);
      // return res["itemRow"];
      return StockTakeLocHeaderResponse(res["itemRow"], res["totalRow"]);
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
// Endpoints.stockTakeCheckInItems = "$activeUrl$stockTakeCheckInItemsMethod";
  // Endpoints.stockTakeCancel = "$activeUrl$stockTakeCancelMethod";
  // Endpoints.stockTakeComplete  = "$activeUrl$stockTakeCompleteMethod";
  Future<void> completeStockTakeHeader({String stNum = ""}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.stockTakeHeaderComplete, queryParameters: {"stNum": stNum});
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

  Future<void> completeStockTakeLine({String stNum = "", String locCode = ""}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.stockTakeLineComplete, queryParameters: {"stNum": stNum, "locCode": locCode});
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


  Future<void> registerStockTakeItem(
      {String stNum = "",
      String locCode = "",
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
        "stNum": stNum,
        "locCode": locCode,
        "rfids": str
      };
      final res1 = await _dioClient.getRegistration(Endpoints.stockTakeCheckInItems,
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

  Future<void> startStockTake({String stNum = ""}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.stockTakeStart, queryParameters: {"stNum": stNum});
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

  Future<void> stocktakeRecountByLoc({String stNum = "", String locCode = ""}) async {
    try {
      final res = await _dioClient
          .get(Endpoints.stocktakeRecountByLoc, queryParameters: {"stNum": stNum, "locCode": locCode});
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

class StockTakeResponse {
  List<StockTakeItem> itemList = [];
  int rowNumber = 0;

  StockTakeResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => StockTakeItem.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}

class StockTakeLineResponse {
  List<StockTakeLineItem> itemList = [];
  int rowNumber = 0;

  StockTakeLineResponse(dynamic data, int? rowNum) {
    try {
      itemList = (data as List<dynamic>)
          .map((e) => StockTakeLineItem.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}

class StockTakeLocHeaderResponse {
  List<StockTakeLocHeader> locHeaderList = [];
  int rowNumber = 0;

  StockTakeLocHeaderResponse(dynamic data, int? rowNum) {
    try {
      locHeaderList = (data as List<dynamic>)
          .map((e) => StockTakeLocHeader.fromJson(e))
          .toList();
    } catch (e) {
      print(e);
    } finally {
      rowNumber = rowNum ?? 0;
    }
  }
}