import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';

class LogoutApi {
   // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  LogoutApi(this._dioClient);

    final Map<String, List<CancelToken>> _cancelTokenMap = {
    "logout":[]
  };
  
  void cancelLogin(){
    _cancelTokenMap["logout"]?.forEach((element) { 
      element.cancel();
    });
    _cancelTokenMap["logout"]!.clear();
  }

  /// Returns list of post in response
  Future<void> logout(String refreshToken) async {
    CancelToken token = CancelToken();
    _cancelTokenMap["logout"]!.add(token);
    try {
      final res = await _dioClient.post(
        Endpoints.logout,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: Headers.formUrlEncodedContentType},
        ),
        cancelToken: token,
        data: {
          "client_id":Endpoints.client_id,
          "client_secret":Endpoints.clientSecret,
          "refresh_token": refreshToken
        },
      );
      return ;
      // if (res["access_token"] != null && res["access_token"] is String) {
      //   return res["access_token"];
      // } else {
      //   throw Exception("access_token not exist");
      // }
    } catch (e) {
      throw e;
    } finally {
      _cancelTokenMap["logout"]!.remove(token);
    }
  }
}
