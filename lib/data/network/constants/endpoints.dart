class Endpoints {
  Endpoints._();

  // server domain map
  static Map domainMap = {"DFS": "http://echome.dfs.com",
    "AWS": "http://qa-echome.ddns.net",
                          };

  static List domainList = domainMap.keys.toList();
  static String activeServerStr = domainList[0];

  static Map keyClockDomainMap = {"AWS": "https://qa-proteksso.ddns.net",
                                  "DFS": "https://atlrfid.dfs.com"};

  static Map versionControlDomainMap = {"vercal": "https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app"};

  // base url
  static String authMethod = "/auth/realms/Protek/protocol/openid-connect";
  static String forgetPasswordPageMethod = "/auth/realms/Protek/account";
  static String forgetPasswordMethod = "/auth/forgetPassword";

  static String keyCloakActiveDomain = keyClockDomainMap[activeServerStr];
  static  String baseUrl = "$keyCloakActiveDomain$authMethod";
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
  static  String forgetPasswordPageUrl = "$keyCloakActiveDomain$forgetPasswordPageMethod";
  static  String forgetPassword = "$keyCloakActiveDomain$forgetPasswordMethod";


  // apps function apis
  static String awsDomain = domainMap["AWS"];
  static String dfsDomain = domainMap["DFS"];
  static String appDir = "/echoMe";
  static String activeDomain = domainMap[activeServerStr];
  static String activeUrl = "$activeDomain$appDir";

  static const String assetInventoryMethod = "/inv/listInventory";
  static const String assetRegistrationMethod = "/reg/listRegisterHeader";
  static const String listRfidContainerMethod = "/rfid/listRfidContainer";
  static const String getRfidTagContainerMethod = "/rfid/getRfidTagContainer";
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

  static String assetInventory = "$activeUrl$assetInventoryMethod";
  static String assetRegistration = "$activeUrl$assetRegistrationMethod";
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


  static String activeVersionControlDomain = versionControlDomainMap["vercal"];
  static String getAppVersionMethod = "/api/v1/appVersion";
  static String getAppDownloadLinkMethod = "/api/v1/appDownload";
  static String getAppVersion =
      '$activeVersionControlDomain$getAppVersionMethod';
  static String getAppDownloadLink =
      "$activeVersionControlDomain$getAppDownloadLinkMethod";

  // static String getAppVersion =
  //     'https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app/api/v1/appVersion';
  // static String getAppDownloadLink =
  //     "https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app/api/v1/appDownload";

  static updateVersionControlEndPoint(activeDomain){
    Endpoints.activeVersionControlDomain = activeDomain;
    Endpoints.getAppVersion = '$activeVersionControlDomain$getAppVersionMethod';
    Endpoints.getAppDownloadLink = '$activeVersionControlDomain$getAppDownloadLinkMethod';
  }

  static updateKeyCloakEndPoint(activeDomain){
    Endpoints.keyCloakActiveDomain = activeDomain;
    Endpoints.baseUrl = "$keyCloakActiveDomain$authMethod";
    Endpoints.forgetPassword = "$keyCloakActiveDomain$forgetPasswordMethod";
    Endpoints.forgetPasswordPageUrl = "$keyCloakActiveDomain$forgetPasswordPageMethod";
    Endpoints.login = baseUrl + "/token";
    Endpoints.logout = baseUrl + "/logout";
  }

  static updateFunctionEndPoint(activeDomain){
    Endpoints.activeDomain = activeDomain;
    Endpoints.activeUrl = "$activeDomain$appDir";
    Endpoints.assetInventory = "$activeUrl$assetInventoryMethod";
    Endpoints.assetRegistration = "$activeUrl$assetRegistrationMethod";
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
    print("Function URL:\n");
    print(Endpoints.activeDomain );
    print(Endpoints.assetInventory);
    print(Endpoints.assetRegistration);
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

    print("KeyCloak URL\n");
    print(Endpoints.forgetPassword);
    print(Endpoints.forgetPasswordPageUrl);

    print("Version Conttrol URL\n");
    print(Endpoints.getAppVersion);
    print(Endpoints.getAppDownloadLink);
  }

}