import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/sharedpref/shared_preference_helper.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class DioBase {
  DioBase._();

  static Dio provideDio(SharedPreferenceHelper sharedPreferenceHelper) {
    final cookieJar = CookieJar();
    final dio = Dio();
    dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(CookieManager(cookieJar))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options,
              RequestInterceptorHandler handler) async {
            // getting token
            var token = await sharedPreferenceHelper.authToken;
            if (token != null) {
              options.headers.putIfAbsent('Authorization', () => token);
            } else {
              print('Auth token is null');
            }
            return handler.next(options);
          },
        ),
      )
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
    return dio;
  }
}
