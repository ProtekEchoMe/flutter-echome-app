// import 'package:dio/dio.dart';
// import 'package:echo_me_mobile/data/network/dio_base.dart';
// import 'package:echo_me_mobile/data/sharedpref/shared_preference_helper.dart';
// import 'package:echo_me_mobile/di/service_locator.dart';
// import 'package:echo_me_mobile/utils/permission_helper/permission_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:ota_update/ota_update.dart';

// class SplashPage extends StatefulWidget {
//   SplashPage({Key? key}) : super(key: key);

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   final PermissionHelper permissionHelper = PermissionHelper();

//   //  final AppVersionControlStore _appVersionControlStore = getIt<AppVersionControlStore>();

//   String msg = "";

//   Future<void> tryUpdate() async {
//     try {
//       //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
//       var dio = DioBase.provideDio(getIt<SharedPreferenceHelper>());
//       var res = await dio.get(
//           "https://github.com/lclrobert2020/express-mock-server-apk/raw/c92eb5de5f29850d055763d626261655dfbb1964/app-release.apk",
//           options: Options(
//               followRedirects: false,
//               validateStatus: (status) => status! < 400));
//       if (res.statusCode == 302 && res.headers["location"]?[0] is String) {
//         var url = res.headers["location"]![0];
//         OtaUpdate()
//             .execute(
//           url,
//           destinationFilename: 'flutter_hello_world.apk',
//           //OPTIONAL, ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:

//           // OPTIONAL
//         )
//             .listen(
//           (OtaEvent event) {
//             print(event.status);
//             print(event.value);
//            if( event.status == OtaStatus.DOWNLOADING){
//              setState(() {
//                msg = "Downloading ${event.value} %";
//              });
//              return;
//            }
//            if( event.status == OtaStatus.INSTALLING){
//              setState(() {
//                msg = "Installing";
//              });
//              return;
//            }else{
//              setState(() {
//                msg = "Error in downloading latest version";
//              });
//              return;
//            }
//           },
//         );
//       }
//       // OtaUpdate()
//       //     .execute(
//       //   'https://github.com/lclrobert2020/express-mock-server-apk/raw/c92eb5de5f29850d055763d626261655dfbb1964/app-release.apk',
//       //   destinationFilename: 'flutter_hello_world.apk',
//       //   //OPTIONAL, ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:

//       //   // OPTIONAL
//       // )
//       //     .listen(
//       //   (OtaEvent event) {
//       //     print(event.status);
//       //     print(event.value);
//       //   },
//       // );
//     } catch (e) {
//       print('Failed to make OTA update. Details: $e');
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     init();
//   }

//   Future<void> init() async {
//     var result = await permissionHelper.requestBasicPermission();
//     setState(() {
//       msg = result.msg;
//     });
//     if (result.hasError) {
//       return;
//     }
//     await tryUpdate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Splash Page"),
//           Text(msg)
//         ],
//       )),
//     );
//   }
// }
