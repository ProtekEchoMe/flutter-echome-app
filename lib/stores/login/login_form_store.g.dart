// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginFormStore on _LoginFormStore, Store {
  Computed<bool>? _$isUserLoginingComputed;

  @override
  bool get isUserLogining =>
      (_$isUserLoginingComputed ??= Computed<bool>(() => super.isUserLogining,
              name: '_LoginFormStore.isUserLogining'))
          .value;
  Computed<bool>? _$isDataFilledComputed;

  @override
  bool get isDataFilled =>
      (_$isDataFilledComputed ??= Computed<bool>(() => super.isDataFilled,
              name: '_LoginFormStore.isDataFilled'))
          .value;

  final _$accessTokenAtom = Atom(name: '_LoginFormStore.accessToken');

  @override
  String? get accessToken {
    _$accessTokenAtom.reportRead();
    return super.accessToken;
  }

  @override
  set accessToken(String? value) {
    _$accessTokenAtom.reportWrite(value, super.accessToken, () {
      super.accessToken = value;
    });
  }

  final _$refreshTokenAtom = Atom(name: '_LoginFormStore.refreshToken');

  @override
  String? get refreshToken {
    _$refreshTokenAtom.reportRead();
    return super.refreshToken;
  }

  @override
  set refreshToken(String? value) {
    _$refreshTokenAtom.reportWrite(value, super.refreshToken, () {
      super.refreshToken = value;
    });
  }

  final _$idTokenAtom = Atom(name: '_LoginFormStore.idToken');

  @override
  String? get idToken {
    _$idTokenAtom.reportRead();
    return super.idToken;
  }

  @override
  set idToken(String? value) {
    _$idTokenAtom.reportWrite(value, super.idToken, () {
      super.idToken = value;
    });
  }

  final _$emailAtom = Atom(name: '_LoginFormStore.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$passwordAtom = Atom(name: '_LoginFormStore.password');

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$isLoginingAtom = Atom(name: '_LoginFormStore.isLogining');

  @override
  bool get isLogining {
    _$isLoginingAtom.reportRead();
    return super.isLogining;
  }

  @override
  set isLogining(bool value) {
    _$isLoginingAtom.reportWrite(value, super.isLogining, () {
      super.isLogining = value;
    });
  }

  final _$isLoggedInAtom = Atom(name: '_LoginFormStore.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  final _$logoutAsyncAction = AsyncAction('_LoginFormStore.logout');

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  final _$loginAsyncAction = AsyncAction('_LoginFormStore.login');

  @override
  Future<void> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  final _$_LoginFormStoreActionController =
      ActionController(name: '_LoginFormStore');

  @override
  void validatePassword(String value) {
    final _$actionInfo = _$_LoginFormStoreActionController.startAction(
        name: '_LoginFormStore.validatePassword');
    try {
      return super.validatePassword(value);
    } finally {
      _$_LoginFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateEmail(String value) {
    final _$actionInfo = _$_LoginFormStoreActionController.startAction(
        name: '_LoginFormStore.validateEmail');
    try {
      return super.validateEmail(value);
    } finally {
      _$_LoginFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_LoginFormStoreActionController.startAction(
        name: '_LoginFormStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_LoginFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_LoginFormStoreActionController.startAction(
        name: '_LoginFormStore.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_LoginFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
accessToken: ${accessToken},
refreshToken: ${refreshToken},
idToken: ${idToken},
email: ${email},
password: ${password},
isLogining: ${isLogining},
isLoggedIn: ${isLoggedIn},
isUserLogining: ${isUserLogining},
isDataFilled: ${isDataFilled}
    ''';
  }
}

mixin _$LoginFormErrorState on _LoginFormErrorState, Store {
  Computed<bool>? _$hasErrorsComputed;

  @override
  bool get hasErrors =>
      (_$hasErrorsComputed ??= Computed<bool>(() => super.hasErrors,
              name: '_LoginFormErrorState.hasErrors'))
          .value;

  final _$usernameAtom = Atom(name: '_LoginFormErrorState.username');

  @override
  String? get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String? value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  final _$emailAtom = Atom(name: '_LoginFormErrorState.email');

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$passwordAtom = Atom(name: '_LoginFormErrorState.password');

  @override
  String? get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String? value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  @override
  String toString() {
    return '''
username: ${username},
email: ${email},
password: ${password},
hasErrors: ${hasErrors}
    ''';
  }
}
