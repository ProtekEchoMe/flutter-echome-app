import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:echo_me_mobile/pages/home/route_constant.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:echo_me_mobile/stores/site_code/site_code_item_store.dart';
import 'package:mobx/mobx.dart';
import 'package:validators2/validators.dart';
import 'package:echo_me_mobile/constants/strings.dart';

// Include generated file
part 'access_control_store.g.dart';

// This is the class used by rest of your codebase
class AccessControlStore = _AccessControlStore with _$AccessControlStore;

// The store-class
abstract class _AccessControlStore with Store {
  final String TAG = "_AccessControlStore";

  // for handling network related error;
  final ErrorStore errorStore = ErrorStore();

  // for handling form validation error;
  final AccessControlErrorState error = AccessControlErrorState();

  // repo for sending request
  final Repository repository;

  _AccessControlStore(this.repository);

  final LoginFormStore loginFormStore = getIt<LoginFormStore>();
  final SiteCodeItemStore siteCodeItemStore = getIt<SiteCodeItemStore>();

  @computed
  bool get isEchoMeSuperuser => accessRoleList.any((element) {return element!.contains(Strings.echoMeSuperUserStr);});

  @computed
  bool get isEchoMeAdmin => accessRoleList.any((element) {return element!.contains(Strings.echoMeAdminStr);});

  @computed
  bool get isSiteSuperuser => accessRoleList.any((element) {return element!.contains(Strings.siteSuperUserStr);});
  
  @computed
  ObservableList<String?> get accessRoleList => ObservableList<String?>.of(
      List<String?>.from(
        loginFormStore.payload!["resource_access"]![Strings.appName]!["roles"]!.map(
                (role) => role.toString()).toList()));

  @computed
  ObservableList<String?> get appModulesAccessRoleList => ObservableList<String?>.of(accessRoleList.where((accessRole) => accessRole!.contains(Strings.appRoleIdStr)));

  @computed
  ObservableList<String?> get roleSiteNameList {
    ObservableList<String?> tempList = ObservableList<String?>();
    String roleSiteStr = Strings.roleSiteIdStr; // "SITE_"

    accessRoleList.forEach((accessRole) {
      if(accessRole!.contains(roleSiteStr)) tempList.add(accessRole.substring(accessRole.indexOf(roleSiteStr) + roleSiteStr.length));
    });
    return tempList;
  }

  @computed
  ObservableList<String?> get accessControlledSiteNameList {
    final ObservableList<String?> siteCodeNameList = siteCodeItemStore.siteCodeNameList;
    return (isSiteSuperuser || isEchoMeSuperuser) ? 
      siteCodeNameList : 
      ObservableList<String?>.of(roleSiteNameList.where((roleSiteName) => siteCodeNameList.contains(roleSiteName)));
  }

  @computed
  ObservableList<String?> get modulesViewRolesList => getRoleList(Strings.viewIdStr);

  @computed
  ObservableList<RouteObject> get modulesObjectViewList {
    ObservableList<RouteObject> tempList = ObservableList<RouteObject>();
    final Map<String, RouteObject>routeMap = RouteConstant.getRouteMap;
    if (isEchoMeSuperuser || isEchoMeAdmin){
      routeMap.forEach((_, routeOb) {tempList.add(routeOb);});
    }else{
      routeMap.forEach((routeId, routeOb) {
        for (final String? routeViewRole in modulesViewRolesList){
          if (routeViewRole!.contains('_${routeId}_')){
            tempList.add(routeOb);
            break;
          }
        }
      });
    }

    return tempList;
  }

  @computed
  ObservableList<String?> get assetRegistrationRoleList  => getRoleList(Strings.assetRegRoleIdStr);

  @computed
  ObservableList<String?> get assetReturnRoleList  => getRoleList(Strings.assetReturnRoleIdStr);

  @computed
  ObservableList<String?> get TIRoleList  => getRoleList(Strings.tiRoleIdStr);

  @computed
  ObservableList<String?> get TORoleList  => getRoleList(Strings.toRoleIdStr);

  @computed
  ObservableList<String?> get STRoleList => getRoleList(Strings.stRoleIdStr);

  @computed
  ObservableList<String?> get INVRoleList => getRoleList(Strings.invRoleIdStr);

    late List<ReactionDisposer> _disposers;

    void dispose() {
      for (final d in _disposers) {
        d();
      }
    }

  ObservableList<String?> getAppRoleList(String roleIdStr) => ObservableList<String?>.of(accessRoleList.where((accessRole) => accessRole!.contains(roleIdStr)));

  ObservableList<String?> getRoleList(String roleIdStr) => ObservableList<String?>.of(appModulesAccessRoleList.where((accessRole) => accessRole!.contains(roleIdStr)));

}

class AccessControlErrorState = _AccessControlErrorState with _$AccessControlErrorState;

abstract class _AccessControlErrorState with Store {
  @observable
  String? username;

  @observable
  String? email;

  @observable
  String? password;

  @computed
  bool get hasErrors => username != null || email != null || password != null;
}
