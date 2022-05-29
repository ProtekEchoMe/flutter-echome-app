// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccessControlStore on _AccessControlStore, Store {
  Computed<bool>? _$isEchoMeSuperuserComputed;

  @override
  bool get isEchoMeSuperuser => (_$isEchoMeSuperuserComputed ??= Computed<bool>(
          () => super.isEchoMeSuperuser,
          name: '_AccessControlStore.isEchoMeSuperuser'))
      .value;
  Computed<bool>? _$isEchoMeAdminComputed;

  @override
  bool get isEchoMeAdmin =>
      (_$isEchoMeAdminComputed ??= Computed<bool>(() => super.isEchoMeAdmin,
              name: '_AccessControlStore.isEchoMeAdmin'))
          .value;
  Computed<bool>? _$isSiteSuperuserComputed;

  @override
  bool get isSiteSuperuser =>
      (_$isSiteSuperuserComputed ??= Computed<bool>(() => super.isSiteSuperuser,
              name: '_AccessControlStore.isSiteSuperuser'))
          .value;
  Computed<ObservableList<String?>>? _$accessRoleListComputed;

  @override
  ObservableList<String?> get accessRoleList => (_$accessRoleListComputed ??=
          Computed<ObservableList<String?>>(() => super.accessRoleList,
              name: '_AccessControlStore.accessRoleList'))
      .value;
  Computed<ObservableList<String?>>? _$appModulesAccessRoleListComputed;

  @override
  ObservableList<String?> get appModulesAccessRoleList =>
      (_$appModulesAccessRoleListComputed ??= Computed<ObservableList<String?>>(
              () => super.appModulesAccessRoleList,
              name: '_AccessControlStore.appModulesAccessRoleList'))
          .value;
  Computed<ObservableList<String?>>? _$roleSiteNameListComputed;

  @override
  ObservableList<String?> get roleSiteNameList =>
      (_$roleSiteNameListComputed ??= Computed<ObservableList<String?>>(
              () => super.roleSiteNameList,
              name: '_AccessControlStore.roleSiteNameList'))
          .value;
  Computed<ObservableList<String?>>? _$accessControlledSiteNameListComputed;

  @override
  ObservableList<String?> get accessControlledSiteNameList =>
      (_$accessControlledSiteNameListComputed ??=
              Computed<ObservableList<String?>>(
                  () => super.accessControlledSiteNameList,
                  name: '_AccessControlStore.accessControlledSiteNameList'))
          .value;
  Computed<ObservableList<String?>>? _$modulesViewRolesListComputed;

  @override
  ObservableList<String?> get modulesViewRolesList =>
      (_$modulesViewRolesListComputed ??= Computed<ObservableList<String?>>(
              () => super.modulesViewRolesList,
              name: '_AccessControlStore.modulesViewRolesList'))
          .value;
  Computed<ObservableList<RouteObject>>? _$modulesObjectViewListComputed;

  @override
  ObservableList<RouteObject> get modulesObjectViewList =>
      (_$modulesObjectViewListComputed ??=
              Computed<ObservableList<RouteObject>>(
                  () => super.modulesObjectViewList,
                  name: '_AccessControlStore.modulesObjectViewList'))
          .value;
  Computed<ObservableList<String?>>? _$assetRegistrationRoleListComputed;

  @override
  ObservableList<String?> get assetRegistrationRoleList =>
      (_$assetRegistrationRoleListComputed ??=
              Computed<ObservableList<String?>>(
                  () => super.assetRegistrationRoleList,
                  name: '_AccessControlStore.assetRegistrationRoleList'))
          .value;
  Computed<ObservableList<String?>>? _$assetReturnRoleListComputed;

  @override
  ObservableList<String?> get assetReturnRoleList =>
      (_$assetReturnRoleListComputed ??= Computed<ObservableList<String?>>(
              () => super.assetReturnRoleList,
              name: '_AccessControlStore.assetReturnRoleList'))
          .value;
  Computed<ObservableList<String?>>? _$TIRoleListComputed;

  @override
  ObservableList<String?> get TIRoleList => (_$TIRoleListComputed ??=
          Computed<ObservableList<String?>>(() => super.TIRoleList,
              name: '_AccessControlStore.TIRoleList'))
      .value;
  Computed<ObservableList<String?>>? _$TORoleListComputed;

  @override
  ObservableList<String?> get TORoleList => (_$TORoleListComputed ??=
          Computed<ObservableList<String?>>(() => super.TORoleList,
              name: '_AccessControlStore.TORoleList'))
      .value;
  Computed<ObservableList<String?>>? _$STRoleListComputed;

  @override
  ObservableList<String?> get STRoleList => (_$STRoleListComputed ??=
          Computed<ObservableList<String?>>(() => super.STRoleList,
              name: '_AccessControlStore.STRoleList'))
      .value;
  Computed<ObservableList<String?>>? _$INVRoleListComputed;

  @override
  ObservableList<String?> get INVRoleList => (_$INVRoleListComputed ??=
          Computed<ObservableList<String?>>(() => super.INVRoleList,
              name: '_AccessControlStore.INVRoleList'))
      .value;

  @override
  String toString() {
    return '''
isEchoMeSuperuser: ${isEchoMeSuperuser},
isEchoMeAdmin: ${isEchoMeAdmin},
isSiteSuperuser: ${isSiteSuperuser},
accessRoleList: ${accessRoleList},
appModulesAccessRoleList: ${appModulesAccessRoleList},
roleSiteNameList: ${roleSiteNameList},
accessControlledSiteNameList: ${accessControlledSiteNameList},
modulesViewRolesList: ${modulesViewRolesList},
modulesObjectViewList: ${modulesObjectViewList},
assetRegistrationRoleList: ${assetRegistrationRoleList},
assetReturnRoleList: ${assetReturnRoleList},
TIRoleList: ${TIRoleList},
TORoleList: ${TORoleList},
STRoleList: ${STRoleList},
INVRoleList: ${INVRoleList}
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
