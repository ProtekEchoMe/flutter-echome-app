import 'dart:async';

import 'package:echo_me_mobile/data/sharedpref/shared_preference_helper.dart';

import 'network/apis/login/login_api.dart';

class Repository {
  // data source object
  // final PostDataSource _postDataSource;

  // api objects
  final LoginApi _loginApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(this._sharedPrefsHelper, this._loginApi);


  // Login:---------------------------------------------------------------------
  Future<String> login({String email="", String password=""}) async {
    return await _loginApi.login(email: email, password: password).then((String jwt){
      _sharedPrefsHelper.saveAuthToken(jwt);
      return jwt;
    }).catchError((error)=> throw error);
  }

  void cancelLogin(){
    _loginApi.cancelLogin();
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