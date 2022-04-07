import 'dart:async';

import 'package:echo_me_mobile/data/network/apis/asset_inventory/asset_inventory_api.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/data/network/apis/login/logout_api.dart';
import 'package:echo_me_mobile/data/network/apis/transfer_out/transfer_out_api.dart';
import 'package:echo_me_mobile/data/sharedpref/shared_preference_helper.dart';
import 'package:echo_me_mobile/models/asset_inventory/asset_inventory_response.dart';
import 'package:echo_me_mobile/models/asset_inventory/inventory_item.dart';
import 'package:echo_me_mobile/models/login/auth_response.dart';

import 'network/apis/login/login_api.dart';

class Repository {
  // data source object
  // final PostDataSource _postDataSource;

  // api objects
  final LoginApi _loginApi;

  final LogoutApi _logoutApi;

  final AssetInventoryApi _assetInventoryApi;

  final AssetRegistrationApi _assetRegistrationApi;

  final TransferOutApi _transferOutApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(this._sharedPrefsHelper, this._loginApi, this._logoutApi, this._assetInventoryApi, this._assetRegistrationApi, this._transferOutApi);


  // Login:---------------------------------------------------------------------
  Future<AuthResponse> login({String email="", String password=""}) async {
     return await _loginApi.login(email: email, password: password);
    // return await _loginApi.login(email: email, password: password).then((String jwt){
    //   _sharedPrefsHelper.saveAuthToken(jwt);
    //   return jwt;
    // }).catchError((error)=> throw error);
  }

  Future<void> logout({String refreshToken = ""}) async {
     return await _logoutApi.logout(refreshToken);
    // return await _loginApi.login(email: email, password: password).then((String jwt){
    //   _sharedPrefsHelper.saveAuthToken(jwt);
    //   return jwt;
    // }).catchError((error)=> throw error);
  }

  void cancelLogin(){
    _loginApi.cancelLogin();
  }

  Future<AssetInventoryResponse> getAssetInventory({int page =0 , int limit = 10, String assetId = "", String itemCode = "" }) async {
    return await _assetInventoryApi.getAssetInventory(page: page, limit: limit, assetId:assetId, itemCode:itemCode);
  }

  Future<AssetRegistrationResponse> getAssetRegistration({int page =0 , int limit = 10,String docNumber = "" }) async {
    return await _assetRegistrationApi.getAssetRegistration(page: page, limit: limit, docNumber: docNumber );
  }

  Future<TransferOutHeaderResponse> getTransferOutHeader({int page =0 , int limit = 10,String shipmentCode = "" }) async {
    return await _transferOutApi.getTransferOutHeaderItem(page: page, limit: limit, shipmentCode: shipmentCode);
  }


  // Post: ---------------------------------------------------------------------
  // Future<PostList> getPosts() async {
  //   // check to see if posts are present in database, then fetch from database
  //   // else make a network call to get all posts, store them into database for
  //   // later use
  //   return await _postApi.getPosts().then((postsList) {
  //     postsList.posts?.forEach((post) {
  //       _postDataSource.insert(post);
  //     });

  //     return postsList;
  //   }).catchError((error) => throw error);
  // }

  // Future<List<Post>> findPostById(int id) {
  //   //creating filter
  //   List<Filter> filters = [];

  //   //check to see if dataLogsType is not null
  //   Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
  //   filters.add(dataLogTypeFilter);

  //   //making db call
  //   return _postDataSource
  //       .getAllSortedByFilter(filters: filters)
  //       .then((posts) => posts)
  //       .catchError((error) => throw error);
  // }

  // Future<int> insert(Post post) => _postDataSource
  //     .insert(post)
  //     .then((id) => id)
  //     .catchError((error) => throw error);

  // Future<int> update(Post post) => _postDataSource
  //     .update(post)
  //     .then((id) => id)
  //     .catchError((error) => throw error);

  // Future<int> delete(Post post) => _postDataSource
  //     .update(post)
  //     .then((id) => id)
  //     .catchError((error) => throw error);


  // Login:---------------------------------------------------------------------


  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  Future<void> changeBrightnessToSystemMode() => 
      _sharedPrefsHelper.changeBrightnessToSystem();
      
  bool get isDarkMode => _sharedPrefsHelper.isDarkMode;

  bool get useSystemMode => _sharedPrefsHelper.useSystemTheme;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  String? get currentLanguage => _sharedPrefsHelper.currentLanguage;
}