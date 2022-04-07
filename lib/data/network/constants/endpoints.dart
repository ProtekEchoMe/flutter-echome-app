class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl =
      "https://qa-proteksso.ddns.net/auth/realms/Protek/protocol/openid-connect/";
  static const String clientSecret = "11e7cb78-8a61-4ca8-a88b-c6c572069fd4";
  static const String client_id = "echoMe";
  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 20000;

  // booking endpoints
  static const String login = baseUrl + "/token";
  static const String logout = baseUrl + "/logout";
  static const String forgetPasswordPageUrl =
      "https://qa-proteksso.ddns.net/auth/realms/Protek/account";
  static const String forgetPassword = baseUrl + "/auth/forgetPassword";

  static const String assetInventory =
      "http://qa-echome.ddns.net/echoMe/inv/listInventory";
  static const String assetRegistration =
      "http://qa-echome.ddns.net/echoMe/doc/listDocument";
  static const String listRfidContainer =
      "http://qa-echome.ddns.net/echoMe/rfid/listRfidContainer";
  static const String getContainerCode =
      "https://qa-echome.ddns.net/echoMe/rfid/getContainerCode";
  static const String registerItems =
      "http://qa-echome.ddns.net/echoMe/reg/registerItems";
  static const String registerContainer =
      "http://qa-echome.ddns.net/echoMe/reg/registerContainers";
  static const String registerComplete = 
      "http://qa-echome.ddns.net/echoMe/reg/registerComplete";
  static const String registerItemsValidation = 
      "http://qa-echome.ddns.net/echoMe/reg/registerItemsValidation";
  static const String registerItem = 
      "http://qa-echome.ddns.net/echoMe/reg/registerItems";
  static const String listTransferOutHeader = 
      "http://qa-echome.ddns.net/echoMe/to/listTransferOutHeader";
  
}
