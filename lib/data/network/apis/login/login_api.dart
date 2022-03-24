import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/models/login/auth_response.dart';

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
  Future<AuthResponse> login({String email = "", String password=""}) async {
    CancelToken token = CancelToken();
    _cancelTokenMap["login"]!.add(token);
    try {
      final res = await _dioClient.post(
        Endpoints.login,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: Headers.formUrlEncodedContentType},
        ),
        cancelToken: token,
        data: {
          "client_id":Endpoints.client_id,
          // "client_secret":Endpoints.clientSecret,
          "grant_type":"password",
          "username": email,
          "password" : password,
          "scope":"openid"
        },
      );
      return AuthResponse.fromJson(res);
      // if (res["access_token"] != null && res["access_token"] is String) {
      //   return res["access_token"];
      // } else {
      //   throw Exception("access_token not exist");
      // }
    } catch (e) {
      throw e;
    } finally {
      _cancelTokenMap["login"]!.remove(token);
    }
  }
}
