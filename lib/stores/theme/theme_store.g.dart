// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ThemeStore on _ThemeStore, Store {
  final _$isDarkModeAtom = Atom(name: '_ThemeStore.isDarkMode');

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  final _$useSystemModeAtom = Atom(name: '_ThemeStore.useSystemMode');

  @override
  bool get useSystemMode {
    _$useSystemModeAtom.reportRead();
    return super.useSystemMode;
  }

  @override
  set useSystemMode(bool value) {
    _$useSystemModeAtom.reportWrite(value, super.useSystemMode, () {
      super.useSystemMode = value;
    });
  }

  final _$changeBrightnessToSystemModeAsyncAction =
      AsyncAction('_ThemeStore.changeBrightnessToSystemMode');

  @override
  Future<dynamic> changeBrightnessToSystemMode() {
    return _$changeBrightnessToSystemModeAsyncAction
        .run(() => super.changeBrightnessToSystemMode());
  }

  final _$changeBrightnessToDarkAsyncAction =
      AsyncAction('_ThemeStore.changeBrightnessToDark');

  @override
  Future<dynamic> changeBrightnessToDark(bool value) {
    return _$changeBrightnessToDarkAsyncAction
        .run(() => super.changeBrightnessToDark(value));
  }

  @override
  String toString() {
    return '''
isDarkMode: ${isDarkMode},
useSystemMode: ${useSystemMode}
    ''';
  }
}
