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
  Computed<bool>? _$hasARChangeRightComputed;

  @override
  bool get hasARChangeRight => (_$hasARChangeRightComputed ??= Computed<bool>(
          () => super.hasARChangeRight,
          name: '_AccessControlStore.hasARChangeRight'))
      .value;
  Computed<bool>? _$hasARScanRightComputed;

  @override
  bool get hasARScanRight =>
      (_$hasARScanRightComputed ??= Computed<bool>(() => super.hasARScanRight,
              name: '_AccessControlStore.hasARScanRight'))
          .value;
  Computed<bool>? _$hasARCompleteRightComputed;

  @override
  bool get hasARCompleteRight => (_$hasARCompleteRightComputed ??=
          Computed<bool>(() => super.hasARCompleteRight,
              name: '_AccessControlStore.hasARCompleteRight'))
      .value;
  Computed<ObservableList<String?>>? _$assetReturnRoleListComputed;

  @override
  ObservableList<String?> get assetReturnRoleList =>
      (_$assetReturnRoleListComputed ??= Computed<ObservableList<String?>>(
              () => super.assetReturnRoleList,
              name: '_AccessControlStore.assetReturnRoleList'))
          .value;
  Computed<bool>? _$hasARtnChangeRightComputed;

  @override
  bool get hasARtnChangeRight => (_$hasARtnChangeRightComputed ??=
          Computed<bool>(() => super.hasARtnChangeRight,
              name: '_AccessControlStore.hasARtnChangeRight'))
      .value;
  Computed<bool>? _$hasARtnScanRightComputed;

  @override
  bool get hasARtnScanRight => (_$hasARtnScanRightComputed ??= Computed<bool>(
          () => super.hasARtnScanRight,
          name: '_AccessControlStore.hasARtnScanRight'))
      .value;
  Computed<bool>? _$hasARtnCompleteRightComputed;

  @override
  bool get hasARtnCompleteRight => (_$hasARtnCompleteRightComputed ??=
          Computed<bool>(() => super.hasARtnCompleteRight,
              name: '_AccessControlStore.hasARtnCompleteRight'))
      .value;
  Computed<ObservableList<String?>>? _$TIRoleListComputed;

  @override
  ObservableList<String?> get TIRoleList => (_$TIRoleListComputed ??=
          Computed<ObservableList<String?>>(() => super.TIRoleList,
              name: '_AccessControlStore.TIRoleList'))
      .value;
  Computed<bool>? _$hasTIChangeRightComputed;

  @override
  bool get hasTIChangeRight => (_$hasTIChangeRightComputed ??= Computed<bool>(
          () => super.hasTIChangeRight,
          name: '_AccessControlStore.hasTIChangeRight'))
      .value;
  Computed<bool>? _$hasTIScanRightComputed;

  @override
  bool get hasTIScanRight =>
      (_$hasTIScanRightComputed ??= Computed<bool>(() => super.hasTIScanRight,
              name: '_AccessControlStore.hasTIScanRight'))
          .value;
  Computed<bool>? _$hasTICompleteRightComputed;

  @override
  bool get hasTICompleteRight => (_$hasTICompleteRightComputed ??=
          Computed<bool>(() => super.hasTICompleteRight,
              name: '_AccessControlStore.hasTICompleteRight'))
      .value;
  Computed<ObservableList<String?>>? _$TORoleListComputed;

  @override
  ObservableList<String?> get TORoleList => (_$TORoleListComputed ??=
          Computed<ObservableList<String?>>(() => super.TORoleList,
              name: '_AccessControlStore.TORoleList'))
      .value;
  Computed<bool>? _$hasTOChangeRightComputed;

  @override
  bool get hasTOChangeRight => (_$hasTOChangeRightComputed ??= Computed<bool>(
          () => super.hasTOChangeRight,
          name: '_AccessControlStore.hasTOChangeRight'))
      .value;
  Computed<bool>? _$hasTOScanRightComputed;

  @override
  bool get hasTOScanRight =>
      (_$hasTOScanRightComputed ??= Computed<bool>(() => super.hasTOScanRight,
              name: '_AccessControlStore.hasTOScanRight'))
          .value;
  Computed<bool>? _$hasTOCompleteRightComputed;

  @override
  bool get hasTOCompleteRight => (_$hasTOCompleteRightComputed ??=
          Computed<bool>(() => super.hasTOCompleteRight,
              name: '_AccessControlStore.hasTOCompleteRight'))
      .value;
  Computed<ObservableList<String?>>? _$STRoleListComputed;

  @override
  ObservableList<String?> get STRoleList => (_$STRoleListComputed ??=
          Computed<ObservableList<String?>>(() => super.STRoleList,
              name: '_AccessControlStore.STRoleList'))
      .value;
  Computed<bool>? _$hasSTChangeRightComputed;

  @override
  bool get hasSTChangeRight => (_$hasSTChangeRightComputed ??= Computed<bool>(
          () => super.hasSTChangeRight,
          name: '_AccessControlStore.hasSTChangeRight'))
      .value;
  Computed<bool>? _$hasSTScanRightComputed;

  @override
  bool get hasSTScanRight =>
      (_$hasSTScanRightComputed ??= Computed<bool>(() => super.hasSTScanRight,
              name: '_AccessControlStore.hasSTScanRight'))
          .value;
  Computed<bool>? _$hasSTCompleteRightComputed;

  @override
  bool get hasSTCompleteRight => (_$hasSTCompleteRightComputed ??=
          Computed<bool>(() => super.hasSTCompleteRight,
              name: '_AccessControlStore.hasSTCompleteRight'))
      .value;
  Computed<ObservableList<String?>>? _$INVRoleListComputed;

  @override
  ObservableList<String?> get INVRoleList => (_$INVRoleListComputed ??=
          Computed<ObservableList<String?>>(() => super.INVRoleList,
              name: '_AccessControlStore.INVRoleList'))
      .value;
  Computed<bool>? _$hasINVChangeRightComputed;

  @override
  bool get hasINVChangeRight => (_$hasINVChangeRightComputed ??= Computed<bool>(
          () => super.hasINVChangeRight,
          name: '_AccessControlStore.hasINVChangeRight'))
      .value;
  Computed<bool>? _$hasINVScanRightComputed;

  @override
  bool get hasINVScanRight =>
      (_$hasINVScanRightComputed ??= Computed<bool>(() => super.hasINVScanRight,
              name: '_AccessControlStore.hasINVScanRight'))
          .value;
  Computed<bool>? _$hasINVCompleteRightComputed;

  @override
  bool get hasINVCompleteRight => (_$hasINVCompleteRightComputed ??=
          Computed<bool>(() => super.hasINVCompleteRight,
              name: '_AccessControlStore.hasINVCompleteRight'))
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
hasARChangeRight: ${hasARChangeRight},
hasARScanRight: ${hasARScanRight},
hasARCompleteRight: ${hasARCompleteRight},
assetReturnRoleList: ${assetReturnRoleList},
hasARtnChangeRight: ${hasARtnChangeRight},
hasARtnScanRight: ${hasARtnScanRight},
hasARtnCompleteRight: ${hasARtnCompleteRight},
TIRoleList: ${TIRoleList},
hasTIChangeRight: ${hasTIChangeRight},
hasTIScanRight: ${hasTIScanRight},
hasTICompleteRight: ${hasTICompleteRight},
TORoleList: ${TORoleList},
hasTOChangeRight: ${hasTOChangeRight},
hasTOScanRight: ${hasTOScanRight},
hasTOCompleteRight: ${hasTOCompleteRight},
STRoleList: ${STRoleList},
hasSTChangeRight: ${hasSTChangeRight},
hasSTScanRight: ${hasSTScanRight},
hasSTCompleteRight: ${hasSTCompleteRight},
INVRoleList: ${INVRoleList},
hasINVChangeRight: ${hasINVChangeRight},
hasINVScanRight: ${hasINVScanRight},
hasINVCompleteRight: ${hasINVCompleteRight}
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
