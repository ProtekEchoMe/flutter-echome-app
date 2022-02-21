import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';

class LoginApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  LoginApi(this._dioClient);

  final Map<String, List<CancelToken>> _cancelTokenMap = {
    "login":[]
  };
  
  void cancelLogin(){
    _cancelTokenMap["login"]?.forEach((element) { 
      element.cancel();
    });
    _cancelTokenMap["login"]!.clear();
  }

  /// Returns list of post in response
  Future<String> login({String email = "", String password=""}) async {
    CancelToken token = CancelToken();
    _cancelTokenMap["login"]!.add(token);
    try {
      final res = await _dioClient.post(
        Endpoints.login,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"},
        ),
        cancelToken: token,
        data: jsonEncode({
          "email": email,
          "password" : password
        }),
      );
      if (res["access_token"] != null && res["access_token"] is String) {
        return res["access_token"];
      } else {
        throw Exception("access_token not exist");
      }
    } catch (e) {
      throw e;
    } finally {
      _cancelTokenMap["login"]!.remove(token);
    }
  }
}
