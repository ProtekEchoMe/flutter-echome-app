import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/models/language/language.dart';
import 'package:mobx/mobx.dart';

part 'language_store.g.dart';

class LanguageStore = _LanguageStore with _$LanguageStore;

abstract class _LanguageStore with Store {
  static const String TAG = "LanguageStore";

  // repository instance
  final Repository _repository;

  // supported languages
  List<Language> supportedLanguages = [
    Language(locale: 'en', language: 'English'),
    Language(code: 'TW', locale: 'zh', language: 'Traditional Chinese'),
  ];

  // constructor:---------------------------------------------------------------
  _LanguageStore(Repository repository)
      : _repository = repository {
    init();
  }

  // store variables:-----------------------------------------------------------
  @observable
  String? locale;

  // actions:-------------------------------------------------------------------
  @action
  void changeLanguage(String value) {
    locale = value;
    _repository.changeLanguage(value).then((_) {
      print("changed language");
    });
  }


  // general:-------------------------------------------------------------------
  void init() async {
    // getting current language from shared preference
    if(_repository.currentLanguage != null) {
      locale = _repository.currentLanguage;
    }
  }

}
