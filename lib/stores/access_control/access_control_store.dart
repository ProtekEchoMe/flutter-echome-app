import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
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
  ObservableList<String?> get accessRoleList{
    ObservableList<String?> tempList = ObservableList<String?>();
    List<dynamic> tempRoleList = loginFormStore.payload!["resource_access"]![Strings.appName]!["roles"]!;
    tempRoleList.forEach((element) {tempList.add(element.toString());});
    return tempList;
  }

  @computed
  ObservableList<String?> get roleSiteNameList {
    ObservableList<String?> tempList = ObservableList<String?>();
    ObservableList<String?> debugList = accessRoleList;
    accessRoleList.forEach((element) {
      String roleSiteStr = Strings.roleSiteIdentifierStr; // "SITE_"
      element!.contains(roleSiteStr) ? tempList.add(element.substring(
          element.indexOf(roleSiteStr) + roleSiteStr.length)
      ): "";
    });
    return tempList;
  }

    late List<ReactionDisposer> _disposers;

    void dispose() {
      for (final d in _disposers) {
        d();
      }
    }

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
