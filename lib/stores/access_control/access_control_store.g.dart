// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccessControlStore on _AccessControlStore, Store {
  Computed<ObservableList<String?>>? _$accessRoleListComputed;

  @override
  ObservableList<String?> get accessRoleList => (_$accessRoleListComputed ??=
          Computed<ObservableList<String?>>(() => super.accessRoleList,
              name: '_AccessControlStore.accessRoleList'))
      .value;
  Computed<ObservableList<String?>>? _$roleSiteNameListComputed;

  @override
  ObservableList<String?> get roleSiteNameList =>
      (_$roleSiteNameListComputed ??= Computed<ObservableList<String?>>(
              () => super.roleSiteNameList,
              name: '_AccessControlStore.roleSiteNameList'))
          .value;

  @override
  String toString() {
    return '''
accessRoleList: ${accessRoleList},
roleSiteNameList: ${roleSiteNameList}
    ''';
  }
}

mixin _$AccessControlErrorState on _AccessControlErrorState, Store {
  Computed<bool>? _$hasErrorsComputed;

  @override
  bool get hasErrors =>
      (_$hasErrorsComputed ??= Computed<bool>(() => super.hasErrors,
              name: '_AccessControlErrorState.hasErrors'))
          .value;

  final _$usernameAtom = Atom(name: '_AccessControlErrorState.username');

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

  final _$emailAtom = Atom(name: '_AccessControlErrorState.email');

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

  final _$passwordAtom = Atom(name: '_AccessControlErrorState.password');

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
