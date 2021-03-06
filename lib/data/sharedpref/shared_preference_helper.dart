import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // General Methods: ----------------------------------------------------------
  Future<String?> get authToken async {
    return _sharedPreference.getString(Preferences.auth_token);
  }

  Future<bool> saveAuthToken(String authToken) async {
    return _sharedPreference.setString(Preferences.auth_token, authToken);
  }

  Future<bool> removeAuthToken() async {
    return _sharedPreference.remove(Preferences.auth_token);
  }

  // Login:---------------------------------------------------------------------
  Future<bool> get isLoggedIn async {
    return _sharedPreference.getBool(Preferences.is_logged_in) ?? false;
  }

  Future<bool> saveIsLoggedIn(bool value) async {
    return _sharedPreference.setBool(Preferences.is_logged_in, value);
  }

  // Theme:------------------------------------------------------
  bool get isDarkMode {
    return _sharedPreference.getBool(Preferences.is_dark_mode) ?? false;
  }

  bool get useSystemTheme {
    bool? useSystem = _sharedPreference.getBool(Preferences.use_system_theme);
    if(useSystem == null){
      return true;
    } else {
      return useSystem;
    }
  }
  Future<void> changeBrightnessToDark(bool value) {
    _sharedPreference.setBool(Preferences.use_system_theme, false);
    return _sharedPreference.setBool(Preferences.is_dark_mode, value);
  }

  Future<void> changeBrightnessToSystem(){
    return _sharedPreference.setBool(Preferences.use_system_theme, true);
  }

  // Language:---------------------------------------------------
  String? get currentLanguage {
    return _sharedPreference.getString(Preferences.current_language);
  }

  Future<void> changeLanguage(String language) {
    return _sharedPreference.setString(Preferences.current_language, language);
  }

  String? get defaultServierDomainName => _sharedPreference.getString(Preferences.defaultServerDomainName);

  Future<void> changeDefaulServicetDomainName(String serverDomainName) =>
      _sharedPreference.setString(Preferences.defaultServerDomainName, serverDomainName);


  String? get defaultVersionControlDomainName => _sharedPreference.getString(Preferences.defaultVersionControlDomainName);

  Future<void> changeDefaultVersionControlDomainName(String versionControlDomainName)=>
      _sharedPreference.setString(Preferences.defaultVersionControlDomainName, versionControlDomainName);


}