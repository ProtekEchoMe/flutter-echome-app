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


  // production url


  static const String assetInventory =
      "http://qa-echome.ddns.net/echoMe/inv/listInventory";
  static const String assetRegistration =
      "http://qa-echome.ddns.net/echoMe/reg/listRegisterHeader";
  static const String listRfidContainer =
      "http://qa-echome.ddns.net/echoMe/rfid/listRfidContainer";
  static const String getRfidTagContainer =
      "https://qa-echome.ddns.net/echoMe/rfid/getRfidTagContainer";
  static const String registerItems =
      "http://qa-echome.ddns.net/echoMe/reg/checkInItems";
  static const String registerToItems =
      "http://qa-echome.ddns.net/echoMe/to/checkInItems";
  static const String registerTiItems =
      "http://qa-echome.ddns.net/echoMe/ti/checkInItems";
  static const String registerContainer =
      "http://qa-echome.ddns.net/echoMe/reg/checkInContainer";
  static const String registerToContainer =
      "http://qa-echome.ddns.net/echoMe/to/checkInContainer";
  static const String registerTiContainer =
      "http://qa-echome.ddns.net/echoMe/ti/checkInContainer";
  static const String registerComplete =
      "http://qa-echome.ddns.net/echoMe/reg/registerComplete";
  static const String registerToComplete =
      "http://qa-echome.ddns.net/echoMe/to/transferOutComplete";
  static const String registerTiComplete =
      "http://qa-echome.ddns.net/echoMe/ti/transferInComplete";
  static const String registerItemsValidation =
      "http://qa-echome.ddns.net/echoMe/reg/registerItemsValidation";
  static const String registerItem =
      "http://qa-echome.ddns.net/echoMe/reg/registerItems";
  static const String listTransferOutHeader =
      "http://qa-echome.ddns.net/echoMe/to/listTransferOutHeader";
  static const String listTransferOutLine =
      "http://qa-echome.ddns.net/echoMe/to/listTransferOutLine";
  static const String setSiteCode = "http://qa-echome.ddns.net/echoMe/site";
  static const String listTransferInHeader =
      "http://qa-echome.ddns.net/echoMe/ti/listTransferInHeader";
  static const listTransferInLine =
      "http://qa-echome.ddns.net/echoMe/ti/listTransferInLine";
  static const getAppVersion =
      'https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app/api/v1/appVersion';
  static const getAppDownloadLink =
      "https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app/api/v1/appDownload";
}
