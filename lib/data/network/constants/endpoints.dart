class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://localhost:8000";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 20000;

  // booking endpoints
  static const String login = baseUrl + "/auth/login";
  static const String forgetPassword = baseUrl + "/auth/forgetPassword";
}