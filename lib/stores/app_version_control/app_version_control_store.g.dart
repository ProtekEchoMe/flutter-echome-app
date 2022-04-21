// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_control_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppVersionControlStore on _AppVersionControlStore, Store {
  final _$appVerionAtom = Atom(name: '_AppVersionControlStore.appVerion');

  @override
  String get appVerion {
    _$appVerionAtom.reportRead();
    return super.appVerion;
  }

  @override
  set appVerion(String value) {
    _$appVerionAtom.reportWrite(value, super.appVerion, () {
      super.appVerion = value;
    });
  }

  final _$versionCheckSuccessAtom =
      Atom(name: '_AppVersionControlStore.versionCheckSuccess');

  @override
  bool get versionCheckSuccess {
    _$versionCheckSuccessAtom.reportRead();
    return super.versionCheckSuccess;
  }

  @override
  set versionCheckSuccess(bool value) {
    _$versionCheckSuccessAtom.reportWrite(value, super.versionCheckSuccess, () {
      super.versionCheckSuccess = value;
    });
  }

  final _$hasErrorAtom = Atom(name: '_AppVersionControlStore.hasError');

  @override
  bool get hasError {
    _$hasErrorAtom.reportRead();
    return super.hasError;
  }

  @override
  set hasError(bool value) {
    _$hasErrorAtom.reportWrite(value, super.hasError, () {
      super.hasError = value;
    });
  }

  final _$errorMessageAtom = Atom(name: '_AppVersionControlStore.errorMessage');

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  final _$messageAtom = Atom(name: '_AppVersionControlStore.message');

  @override
  String get message {
    _$messageAtom.reportRead();
    return super.message;
  }

  @override
  set message(String value) {
    _$messageAtom.reportWrite(value, super.message, () {
      super.message = value;
    });
  }

  final _$updateIfNeedAsyncAction =
      AsyncAction('_AppVersionControlStore.updateIfNeed');

  @override
  Future<void> updateIfNeed() {
    return _$updateIfNeedAsyncAction.run(() => super.updateIfNeed());
  }

  @override
  String toString() {
    return '''
appVerion: ${appVerion},
versionCheckSuccess: ${versionCheckSuccess},
hasError: ${hasError},
errorMessage: ${errorMessage},
message: ${message}
    ''';
  }
}
