import 'package:echo_me_mobile/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  final String TAG = "_ThemeStore";

  final Repository _repository;

   _ThemeStore(Repository repository)
      : _repository = repository {
    init();
  }

  void init(){
    isDarkMode = _repository.isDarkMode;
  }

  @observable
  bool isDarkMode = false;

  @observable
  bool useSystemMode = false;

  @action
  Future changeBrightnessToSystemMode() async{
    useSystemMode =true;
    await _repository.changeBrightnessToSystemMode();
  }

  @action
  Future changeBrightnessToDark(bool value) async {
    useSystemMode = false;
    isDarkMode = value;
    await _repository.changeBrightnessToDark(value);
  }

}