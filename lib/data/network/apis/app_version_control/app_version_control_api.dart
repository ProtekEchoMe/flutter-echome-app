import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';

class AppVersionControlApi {
   // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AppVersionControlApi(this._dioClient);

  Future<String> getLatestAppVersion() async{
     final res = await _dioClient.get(Endpoints.getAppVersion);
     return res["version"];
  }

  Future<String> getAppDownloadLink() async{
     final res = await _dioClient.get(Endpoints.getAppDownloadLink);
     return res["link"];
  }
}
