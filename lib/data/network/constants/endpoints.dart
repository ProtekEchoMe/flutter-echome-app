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

  static Map versionControlDomainMap = {"DFS": "http://echome.dfs.com",
                                        "AWS": "http://qa-echome.ddns.net",};

  // static Map versionControlDomainMap = {"DFS": "https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app",
  //   "vercal": "https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app",
  //   "AWS": "https://qa-proteksso.ddns.net"};

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

  static const String assetInventoryMethod = "/inv/listInventory"; // depreciated
  static const String assetInventoryContainerMethod = "/inv/listInventoryContainer";
  static const String assetRegistrationMethod = "/reg/listRegisterHeader";
  static const String assetRegistrationLineMethod = "/reg/listRegisterLine";
  static const String listRfidContainerMethod = "/rfid/listRfidContainer";
  static const String getRfidTagContainerMethod = "/rfid/getRfidTagContainer";
  static const String registerItemsMethod = "/reg/checkInItems";
  static const String registerToItemsMethod = "/to/checkInItems";
  static const String registerToItemsDirectMethod = "/to/newTransferOutLine";
  static const String registerTiItemsMethod = "/ti/checkInItems";
  static const String registerTiItemsDirectMethod = "/to/newTransferInLine";
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
  // static const String listTransferInLineMethod = "/ti/listTransferInLine";
  static const String listTransferInLineMethod = "/ti/listTransferOutLine"; // updated from 4/7/22 -- added remark col

  // asset Return Method
  static const String assetReturnHeaderMethod = "/assetReturn/listAssetReturnHeader";
  static const String assetReturnItemsMethod = "/assetReturn/checkInItems";
  static const String assetReturnContainerMethod = "/assetReturn/checkInContainer";
  static const String assetReturnCompleteMethod = "/assetReturn/returnComplete";
  static const String assetReturnItemsValidationMethod = "/reg/registerItemsValidation";
  static const String assetReturnRegisterItemsMethod = "/reg/registerItems";

  // siteLoc Method
  static const String listLocSiteMethod = "/loc/listLocSite";

  // Direct TransferOut Method
  static const String createDirectToMethod = "/to/newTransferOutHeader";

  // Direct TransferIn Method
  static const String createDirectTiMethod = "/to/newTransferOutHeader";

  // StockTake Method

  static const String listStockTakeHeaderMethod = "/stocktake/listStocktakeHeader";
  static const String listStockTakeLineMethod = "/stocktake/listStocktakeLine";
  static const String newStockTakeHeaderMethod = "/stocktake/newStocktakeHeader";
  static const String updateStockTakeHeaderMethod = "/stocktake/updateStocktakeHeader";
  static const String removeStockTakeHeaderMethod = "/stocktake/removeStocktakeHeader";
  static const String stockTakeInitiateMethod = "/stocktake/stocktakeInitiate";
  static const String stockTakeStartMethod = "/stocktake/stocktakeStart";
  static const String stockTakeCheckInItemsMethod = "/stocktake/checkInItems";
  static const String stockTakeCancelMethod = "/stocktake/stocktakeCancel";
  static const String stockTakeCompleteMethod = "/stocktake/stocktakeComplete";


  //Stock Take
  static String listStockTakeHeader = "$activeUrl$listStockTakeHeaderMethod";
  static String listStockTakeLine = "$activeUrl$listStockTakeLineMethod";
  static String newStocktakeHeader = "$activeUrl$newStockTakeHeaderMethod";
  static String updateStocktakeHeader = "$activeUrl$updateStockTakeHeaderMethod";
  static String removeStocktakeHeader = "$activeUrl$removeStockTakeHeaderMethod";
  static String stockTakeInitiate = "$activeUrl$stockTakeInitiateMethod";
  static String stockTakeStart = "$activeUrl$stockTakeStartMethod";
  static String stockTakeCheckInItems = "$activeUrl$stockTakeCheckInItemsMethod";
  static String stockTakeCancel = "$activeUrl$stockTakeCancelMethod";
  static String stockTakeComplete  = "$activeUrl$stockTakeCompleteMethod";

  static String assetInventory = "$activeUrl$assetInventoryMethod";
  static String assetInventoryContainer = "$activeUrl$assetInventoryContainerMethod";
  static String assetRegistration = "$activeUrl$assetRegistrationMethod";
  static String assetRegistrationLine = "$activeUrl$assetRegistrationLineMethod";
  static String listRfidContainer = "$activeUrl$listRfidContainerMethod";
  static String getRfidTagContainer = "$activeUrl$getRfidTagContainerMethod";
  static String registerItems = "$activeUrl$registerItemsMethod";
  static String registerToItems = "$activeUrl$registerToItemsMethod";
  static String registerToItemsDirect = "$activeUrl$registerToItemsDirectMethod";
  static String registerTiItems = "$activeUrl$registerTiItemsMethod";
  static String registerTiItemsDirect = "$activeUrl$registerTiItemsDirectMethod";
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

  // asset Return URL
  static String assetReturnHeader = "$activeUrl$assetReturnHeaderMethod";
  static String assetReturnItems = "$activeUrl$assetReturnItemsMethod";
  static String assetReturnContainer = "$activeUrl$assetReturnContainerMethod";
  static String assetReturnComplete = "$activeUrl$assetReturnCompleteMethod";
  static String assetReturnItemsValidation = "$activeUrl$assetReturnItemsValidationMethod";
  static String assetReturnRegisterItem = "$activeUrl$assetReturnRegisterItemsMethod";
  // listLocSite URL
  static String listLocSite = "$activeUrl$listLocSiteMethod";

  // Direct Transfer Out
  static String createDirectTo = "$activeUrl$createDirectToMethod";

  // Direct Transfer In
  static String createDirectTi = "$activeUrl$createDirectTiMethod";


  static String activeVersionControlDomain = versionControlDomainMap["AWS"];
  // static String getAppVersionMethod = "/api/v1/appVersion";
  // static String getAppDownloadLinkMethod = "/api/v1/appDownload";

  static String getAppVersionMethod = "/echoMe/apk/version";
  static String getAppDownloadLinkMethod = "/echoMe/apk/download?version=";

  static String getAppVersion =
      '$activeVersionControlDomain$getAppVersionMethod';
  static String getAppDownloadLink =
      "$activeVersionControlDomain$getAppDownloadLinkMethod";



  // static String getAppVersion =
  //     'https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app/api/v1/appVersion';
  // static String getAppDownloadLink =
  //     "https://express-apk-update-server-d4tab1aw1-protekechome.vercel.app/api/v1/appDownload";

  static updateVersionControlEndPointUrl(String activeDomain){
    print("update Version Control End Point: " + activeDomain);
    Endpoints.activeVersionControlDomain = activeDomain;
    Endpoints.getAppVersion = '$activeVersionControlDomain$getAppVersionMethod';
    Endpoints.getAppDownloadLink = '$activeVersionControlDomain$getAppDownloadLinkMethod';
  }

  static updateKeyCloakEndPoint(String activeDomain){
    print("update KeyCloak End Point: " + activeDomain);
    Endpoints.keyCloakActiveDomain = activeDomain;
    Endpoints.baseUrl = "$keyCloakActiveDomain$authMethod";
    Endpoints.forgetPassword = "$keyCloakActiveDomain$forgetPasswordMethod";
    Endpoints.forgetPasswordPageUrl = "$keyCloakActiveDomain$forgetPasswordPageMethod";
    Endpoints.login = baseUrl + "/token";
    Endpoints.logout = baseUrl + "/logout";
  }

  static updateFunctionEndPoint(String activeDomain){
    print("update Server End Point: " + activeDomain);
    Endpoints.activeDomain = activeDomain;
    Endpoints.activeUrl = "$activeDomain$appDir";
    Endpoints.assetInventory = "$activeUrl$assetInventoryMethod";
    Endpoints.assetRegistration = "$activeUrl$assetRegistrationMethod";
    Endpoints.assetRegistrationLine = "$activeUrl$assetRegistrationLineMethod";
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
    Endpoints.assetReturnHeader = "$activeUrl$assetReturnHeaderMethod";
    Endpoints.assetReturnItems = "$activeUrl$assetReturnItemsMethod";
    Endpoints.assetReturnContainer = "$activeUrl$assetReturnContainerMethod";
    Endpoints.assetReturnComplete = "$activeUrl$assetReturnCompleteMethod";
    Endpoints.assetReturnItemsValidation = "$activeUrl$assetReturnItemsValidationMethod";
    Endpoints.assetReturnRegisterItem = "$activeUrl$assetReturnRegisterItemsMethod";
    Endpoints.listLocSite = "$activeUrl$listLocSiteMethod";
    //stock Take
    Endpoints.listStockTakeHeader = "$activeUrl$listStockTakeHeaderMethod";
    Endpoints.listStockTakeLine = "$activeUrl$listStockTakeLineMethod";
    Endpoints.newStocktakeHeader = "$activeUrl$newStockTakeHeaderMethod";
    Endpoints.updateStocktakeHeader = "$activeUrl$updateStockTakeHeaderMethod";
    Endpoints.removeStocktakeHeader = "$activeUrl$removeStockTakeHeaderMethod";
    Endpoints.stockTakeInitiate = "$activeUrl$stockTakeInitiateMethod";
    Endpoints.stockTakeStart = "$activeUrl$stockTakeStartMethod";
    Endpoints.stockTakeCheckInItems = "$activeUrl$stockTakeCheckInItemsMethod";
    Endpoints.stockTakeCancel = "$activeUrl$stockTakeCancelMethod";
    Endpoints.stockTakeComplete  = "$activeUrl$stockTakeCompleteMethod";

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
    print(Endpoints.assetReturnHeader);
    print(Endpoints.assetReturnItems);
    print(Endpoints.assetReturnContainer);
    print(Endpoints.assetReturnComplete);
    print(Endpoints.assetReturnItemsValidation);
    print(Endpoints.assetReturnRegisterItem);

    print(Endpoints.listLocSite);

    print("KeyCloak URL\n");
    print(Endpoints.forgetPassword);
    print(Endpoints.forgetPasswordPageUrl);

    print("Version Conttrol URL\n");
    print(Endpoints.getAppVersion);
    print(Endpoints.getAppDownloadLink);
  }

}