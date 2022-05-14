class Endpoints {
  Endpoints._();

  // base url
  static  String baseUrl =
      "https://qa-proteksso.ddns.net/auth/realms/Protek/protocol/openid-connect/";
  static  String clientSecret = "11e7cb78-8a61-4ca8-a88b-c6c572069fd4";
  static  String client_id = "echoMe";
  // receiveTimeout
  static  int receiveTimeout = 15000;

  // connectTimeout
  static  int connectionTimeout = 20000;

  //apps update apis
  // booking endpoints
  static  String login = baseUrl + "/token";
  static  String logout = baseUrl + "/logout";
  static  String forgetPasswordPageUrl =
      "https://qa-proteksso.ddns.net/auth/realms/Protek/account";
  static  String forgetPassword = baseUrl + "/auth/forgetPassword";


  // apps function apis
  static String awsDomain = "http://qa-echome.ddns.net";
  static String dfsDomain = "";
  static String appDir = "/echoMe";
  static String activeDomain = awsDomain;
  static String activeUrl = "$activeDomain$appDir";

  static const String assetInventoryMethod = "/inv/listInventory";
  static const String assetRegistrationMethod = "/reg/listRegisterHeader";
  static const String listRfidContainerMethod = "/rfid/listRfidContainer";
  static const String getRfidTagContainerMethod = "https://qa-echome.ddns.net/echoMe/rfid/getRfidTagContainer";
  static const String registerItemsMethod = "/reg/checkInItems";
  static const String registerToItemsMethod = "/to/checkInItems";
  static const String registerTiItemsMethod = "/ti/checkInItems";
  static const String registerContainerMethod = "/reg/checkInContainer";
  static const String registerToContainerMethod = "/to/checkInContainer";
  static const String registerTiContainerMethod = "/ti/checkInContainer";
  static const String registerCompleteMethod = "/reg/registerComplete";
  static const String registerToCompleteMethod = "/to/transferOutComplete";
  static const String registerTiCompleteMethod = "/ti/transferInComplete";
  static const String registerItemsValidationMethod = "/reg/registerItemsValidation";
  static const String registerItemMethod = "/reg/registerItems";
  static const String listTransferOutHeaderMethod = "/to/listTransferOutHeader";
  static const String listTransferOutLineMethod = "/to/listTransferOutLine";
  static const String setSiteCodeMethod = "/site";
  static const String listTransferInHeaderMethod = "/ti/listTransferInHeader";
  static const String listTransferInLineMethod = "/ti/listTransferInLine";

  static String listRfidContainer = "$activeUrl$listRfidContainerMethod";
  static String getRfidTagContainer = "$activeUrl$getRfidTagContainerMethod";
  static String registerItems = "$activeUrl$registerItemsMethod";
  static String registerToItems = "$activeUrl$registerToItemsMethod";
  static String registerTiItems = "$activeUrl$registerTiItemsMethod";
  static String registerContainer = "$activeUrl$registerContainerMethod";
  static String registerToContainer = "$activeUrl$registerToContainerMethod";
  static String registerTiContainer = "$activeUrl$registerTiContainerMethod";
  static String registerComplete = "$activeUrl$registerCompleteMethod";
  static String registerToComplete = "$activeUrl$registerToCompleteMethod";
  static String registerTiComplete = "$activeUrl$registerTiCompleteMethod";
  static String registerItemsValidation = "$activeUrl$registerItemsValidationMethod";
  static String registerItem = "$activeUrl$registerItemMethod";
  static String listTransferOutHeader = "$activeUrl$listTransferOutHeaderMethod";
  static String listTransferOutLine = "$activeUrl$listTransferOutLineMethod";
  static String setSiteCode =  "$activeUrl$setSiteCodeMethod";
  static String listTransferInHeader = "$activeUrl$listTransferInHeaderMethod";
  static String listTransferInLine = "$activeUrl$listTransferInLineMethod";


  static String getAppVersion =
      'https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app/api/v1/appVersion';
  static String getAppDownloadLink =
      "https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app/api/v1/appDownload";

  static updateEndPoint(activeDomain){
    Endpoints.activeDomain = activeDomain;
    Endpoints.activeUrl = "$activeDomain$appDir";
    Endpoints.listRfidContainer = "$activeUrl$listRfidContainerMethod";
    Endpoints.getRfidTagContainer = "$activeUrl$getRfidTagContainerMethod";
    Endpoints.registerItems = "$activeUrl$registerItemsMethod";
    Endpoints.registerToItems = "$activeUrl$registerToItemsMethod";
    Endpoints.registerTiItems = "$activeUrl$registerTiItemsMethod";
    Endpoints.registerContainer = "$activeUrl$registerContainerMethod";
    Endpoints.registerToContainer = "$activeUrl$registerToContainerMethod";
    Endpoints.registerTiContainer = "$activeUrl$registerTiContainerMethod";
    Endpoints.registerComplete = "$activeUrl$registerCompleteMethod";
    Endpoints.registerToComplete = "$activeUrl$registerToCompleteMethod";
    Endpoints.registerTiComplete = "$activeUrl$registerTiCompleteMethod";
    Endpoints.registerItemsValidation = "$activeUrl$registerItemsValidationMethod";
    Endpoints.registerItem = "$activeUrl$registerItemMethod";
    Endpoints.listTransferOutHeader = "$activeUrl$listTransferOutHeaderMethod";
    Endpoints.listTransferOutLine = "$activeUrl$listTransferOutLineMethod";
    Endpoints.setSiteCode =  "$activeUrl$setSiteCodeMethod";
    Endpoints.listTransferInHeader = "$activeUrl$listTransferInHeaderMethod";
    Endpoints.listTransferInLine = "$activeUrl$listTransferInLineMethod";
  }

  // testing
  static printEndPoint(){
    print(Endpoints.activeDomain );
    print(Endpoints.listRfidContainer);
    print(Endpoints.getRfidTagContainer);
    print(Endpoints.registerItems);
    print(Endpoints.registerToItems);
    print(Endpoints.registerTiItems);
    print(Endpoints.registerContainer );
    print(Endpoints.registerToContainer);
    print(Endpoints.registerTiContainer );
    print(Endpoints.registerComplete );
    print(Endpoints.registerToComplete);
    print(Endpoints.registerTiComplete );
    print(Endpoints.registerItemsValidation);
    print(Endpoints.registerItem );
    print(Endpoints.listTransferOutHeader);
    print(Endpoints.listTransferOutLine);
    print(Endpoints.setSiteCode);
    print(Endpoints.listTransferInHeader);
    print(Endpoints.listTransferInLine);
  }

}