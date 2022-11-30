import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/network/apis/app_version_control/app_version_control_api.dart';
import 'package:echo_me_mobile/data/network/apis/asset_inventory/asset_inventory_api.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/data/network/apis/asset_return/asset_return_api.dart';
import 'package:echo_me_mobile/data/network/apis/login/login_api.dart';
import 'package:echo_me_mobile/data/network/apis/login/logout_api.dart';
import 'package:echo_me_mobile/data/network/apis/transfer_in/transfer_in_api.dart';
import 'package:echo_me_mobile/data/network/apis/transfer_out/transfer_out_api.dart';
import 'package:echo_me_mobile/data/network/apis/stock_take/stock_take_api.dart';
import 'package:echo_me_mobile/data/network/apis/site_code/loc_site_api.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:echo_me_mobile/data/network/dio_base.dart';
import 'package:echo_me_mobile/data/network/dio_client.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/data/sharedpref/shared_preference_helper.dart';
import 'package:echo_me_mobile/di/local_module.dart';
import 'package:echo_me_mobile/pages/login/forget_password_page.dart';
import 'package:echo_me_mobile/stores/app_version_control/app_version_control_store.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_scan_expand_store.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_scan_store.dart';
import 'package:echo_me_mobile/stores/asset_registration/asset_registration_store.dart';
import 'package:echo_me_mobile/stores/asset_return/asset_return_scan_store.dart';
import 'package:echo_me_mobile/stores/asset_return/asset_return_store.dart';
import 'package:echo_me_mobile/stores/asset_inventory/asset_inventory_store.dart';
import 'package:echo_me_mobile/stores/asset_inventory/asset_inventory_scan_store.dart';
import 'package:echo_me_mobile/stores/login/forget_password_store.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:echo_me_mobile/stores/site_code/site_code_item_store.dart';
import 'package:echo_me_mobile/stores/reader_connection/reader_connection_store.dart';
import 'package:echo_me_mobile/stores/transfer_in/transfer_in_scan_store.dart';
import 'package:echo_me_mobile/stores/transfer_in/transfer_in_store.dart';
import 'package:echo_me_mobile/stores/transfer_out/transfer_out_store.dart';
import 'package:echo_me_mobile/stores/transfer_out/transfer_out_scan_store.dart';
import 'package:echo_me_mobile/stores/stock_take/stock_take_scan_store.dart';
import 'package:echo_me_mobile/stores/stock_take/stock_take_store.dart';
import 'package:echo_me_mobile/stores/access_control/access_control_store.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // get the base shared preference
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());
  // provide the base shared preference to the helper
  getIt.registerSingleton<SharedPreferenceHelper>(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  // get the base dio settings
  getIt.registerSingleton<Dio>(
      DioBase.provideDio(getIt<SharedPreferenceHelper>()));
  // provide RESTful api
  getIt.registerSingleton<DioClient>(DioClient(getIt<Dio>()));

  // setup the api service
  getIt.registerSingleton(LoginApi(getIt<DioClient>()));
  getIt.registerSingleton(LogoutApi(getIt<DioClient>()));
  getIt.registerSingleton(AssetInventoryApi(getIt<DioClient>()));
  getIt.registerSingleton(AssetRegistrationApi(getIt<DioClient>()));
  getIt.registerSingleton(AssetReturnApi(getIt<DioClient>()));
  getIt.registerSingleton(TransferOutApi(getIt<DioClient>()));
  getIt.registerSingleton(TransferInApi(getIt<DioClient>()));
  getIt.registerSingleton(StockTakeApi(getIt<DioClient>()));
  getIt.registerSingleton(AppVersionControlApi(getIt<DioClient>()));
  // getIt.registerSingleton(AppVersionControlApi(getIt<DioClient>()));
  getIt.registerSingleton(LocSiteApi(getIt<DioClient>()));
  
  // set up the repo
  getIt.registerSingleton<Repository>(
    Repository(
        getIt<SharedPreferenceHelper>(),
        getIt<LoginApi>(),
        getIt<LogoutApi>(),
        getIt<AssetInventoryApi>(),
        getIt<AssetRegistrationApi>(),
        getIt<AssetReturnApi>(),
        getIt<TransferOutApi>(),
        getIt<TransferInApi>(),
        getIt<StockTakeApi>(),
        getIt<AppVersionControlApi>(),
        getIt<LocSiteApi>()),
  );

  //  local store => only called when needed => use Factory
  // getIt.registerFactory<ForgetPasswordStore>(
  //     () => ForgetPasswordStore(getIt<Repository>()));
  getIt.registerFactory<AssetRegistrationStore>(
      () => AssetRegistrationStore(getIt<Repository>()));

  getIt.registerFactory<StockTakeStore>(
          () => StockTakeStore(getIt<Repository>()));

  getIt.registerFactory<AssetReturnStore>(
          () => AssetReturnStore(getIt<Repository>()));

  getIt.registerFactory<AssetInventoryStore>(
      () => AssetInventoryStore(getIt<Repository>()));

  getIt.registerFactory<AssetInventoryScanStore>(
          () => AssetInventoryScanStore(getIt<Repository>()));

  getIt.registerFactory<TransferOutStore>(
      () => TransferOutStore(getIt<Repository>()));

  getIt.registerFactory<TransferOutScanStore>(
          () => TransferOutScanStore(getIt<Repository>()));

  getIt.registerFactory<ForgetPasswordStore>(
      () => ForgetPasswordStore(getIt<Repository>()));

  getIt.registerFactory<TransferInStore>(
      () => TransferInStore(getIt<Repository>()));

  getIt.registerFactory<AssetRegistrationScanStore>(
      () => AssetRegistrationScanStore(getIt<Repository>()));

  getIt.registerFactory<ARScanExpandStore>(
          () => ARScanExpandStore(getIt<Repository>()));

  getIt.registerFactory<AssetReturnScanStore>(
          () => AssetReturnScanStore(getIt<Repository>()));

  getIt.registerFactory<TransferInScanStore>(
      () => TransferInScanStore(getIt<Repository>()));

  getIt.registerFactory<StockTakeScanStore>(
          () => StockTakeScanStore(getIt<Repository>()));

  getIt.registerSingleton<AppVersionControlStore>(AppVersionControlStore(getIt<Repository>()));

  getIt.registerSingleton<SiteCodeItemStore>(SiteCodeItemStore(getIt<Repository>()));
  
  getIt.registerSingleton(ReaderConnectionStore());

  getIt.registerSingleton<LoginFormStore>(LoginFormStore(getIt<Repository>()));

  getIt.registerSingleton<AccessControlStore>(AccessControlStore(getIt<Repository>()));

  //debug
  // Endpoints.printEndPoint();
  // print("");

}


