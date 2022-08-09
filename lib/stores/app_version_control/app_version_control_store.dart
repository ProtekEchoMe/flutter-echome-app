import 'package:echo_me_mobile/constants/app_data.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:echo_me_mobile/utils/permission_helper/permission_helper.dart';
import 'package:mobx/mobx.dart';
import 'package:ota_update/ota_update.dart';

import 'package:echo_me_mobile/data/sharedpref/shared_preference_helper.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';


part 'app_version_control_store.g.dart';

class AppVersionControlStore = _AppVersionControlStore
    with _$AppVersionControlStore;

abstract class _AppVersionControlStore with Store {
  final String TAG = "_AppVersionControlStore";

  final Repository _repository;

  final SharedPreferenceHelper _sharedPreferenceHelper =
  getIt<SharedPreferenceHelper>();

  _AppVersionControlStore(this._repository) {
    appVerion = AppData.appVersion;
  }

  @observable
  String appVerion = "";

  @observable
  bool versionCheckSuccess = false;

  @observable
  bool hasError = false;

  @observable
  String errorMessage = "";

  @observable
  String message = "";



  @action
  Future<bool> getAppPermission () async {
    var permissionHelper= PermissionHelper();
    var result = await permissionHelper.requestBasicPermission();
    message = result.msg;
    if(result.hasError){
      return false;
    }
    return true;
  } 

  @action
  Future<void> updateIfNeed() async {
    try {
      String? currentSelectedServer = _sharedPreferenceHelper.defaultVersionControlDomainName;
      if (currentSelectedServer == null) {
        // set Default Value into shared preference
        String defaultServerDomainNameKey = Endpoints.versionControlDomainMap.keys.toList()[0];
        _sharedPreferenceHelper.changeDefaultVersionControlDomainName(defaultServerDomainNameKey);
        currentSelectedServer = _sharedPreferenceHelper.defaultVersionControlDomainName;
      }

      String domainNameUrl = Endpoints.versionControlDomainMap[currentSelectedServer];
      Endpoints.updateVersionControlEndPointUrl(domainNameUrl);

      message = "Getting information about app version";
      var latestVer = await _repository.getAppVersion();
      if (latestVer == appVerion) {
        versionCheckSuccess = true;
        message="The app version is latest";
        return;
      }
      message = "New Version Found, Starting to download";
      var link = _repository.getAppDownloadLink2();
      OtaUpdate()
          .execute(
        link,
        destinationFilename: 'update.apk',
      )
          .listen(
        (OtaEvent event) {
          if (event.status == OtaStatus.DOWNLOADING) {
            message = "Downloading ${event.value} %";
            return;
          }
          if (event.status == OtaStatus.INSTALLING) {
            message = "Installing";

            return;
          } else {
            message = "Error in downloading latest version";
            return;
          }
        },
      );
    } catch (e) {
      hasError = true;
      message = e.toString();
    } finally {}
  }
}
