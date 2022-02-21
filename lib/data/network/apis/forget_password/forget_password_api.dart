import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';

class ForgetPasswordApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  ForgetPasswordApi(this._dioClient);
  

  /// Returns list of post in response
  Future<String> forgetPasswordEmailRequest({String email = ""}) async {
    try {
      final res = await _dioClient.post(
        Endpoints.forgetPassword,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"},
        ),
        data: jsonEncode({
          email = email
        }),
      );
      return res;
    } catch (e) {
      throw e;
    }
  }
}
