import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  Future<PermissionRequestResult> requestBasicPermission() async {
    List<String> errorMsg = [];
    try {
      var storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        errorMsg.add("Failed to get storage permission");
      }
      var installPackageStatus =
          await Permission.requestInstallPackages.request();
      if (!installPackageStatus.isGranted) {
        errorMsg.add("Failed to get permission to install apk");
      }
    } catch (e) {
      errorMsg.add("unexpected error occur during permission request");
    }
    return errorMsg.isEmpty
        ? PermissionRequestResult.buildSuccess(
            msg: "Request Permission Successful")
        : PermissionRequestResult.buildError(
            msg: errorMsg.reduce((value, element) => value + element));
  }
}

class PermissionRequestResult {
  bool hasError;
  bool isSuccess;
  String msg;

  PermissionRequestResult(
      {required this.hasError, required this.isSuccess, required this.msg});

  static PermissionRequestResult buildSuccess({String msg = ""}) {
    return PermissionRequestResult(isSuccess: true, hasError: false, msg: msg);
  }

  static PermissionRequestResult buildError({String msg = ""}) {
    return PermissionRequestResult(isSuccess: false, hasError: true, msg: msg);
  }
}
