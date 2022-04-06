import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/constants/app_theme.dart';
import 'package:echo_me_mobile/constants/strings.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/stores/language/language_store.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:echo_me_mobile/stores/theme/theme_store.dart';
import 'package:echo_me_mobile/utils/app_routes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await setPreferredOrientations();
  await setupLocator();
  await EasyLocalization.ensureInitialized();
  runZonedGuarded(() async {
    // ignore: prefer_const_constructors

    runApp(EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('zh', 'TW')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MyApp()));
  }, (error, stack) {
    print("===========================");
    print("runZonedGuarded catch error");
    print(error);
    print(stack);
    print("===========================");
  });
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    // DeviceOrientation.landscapeRight,
    // DeviceOrientation.landscapeLeft,
  ]);
}

class MyApp extends HookWidget {
  MyApp({Key? key}) : super(key: key);

  static final navigatorKey = GlobalKey<NavigatorState>();
  final ThemeStore _themeStore = ThemeStore(getIt<Repository>());
  final LanguageStore _languageStore = LanguageStore(getIt<Repository>());
  final LoginFormStore _loginFormStore = getIt<LoginFormStore>();

  @override
  Widget build(BuildContext context) {
    return ReactionBuilder(
        child: MaterialApp(
            navigatorKey: navigatorKey,
            title: Strings.appName,
            themeMode: ThemeMode.light,
            theme: ThemeData(primarySwatch: Colors.orange).copyWith(
                scaffoldBackgroundColor: Colors.grey.shade200,
                appBarTheme: const AppBarTheme(
                    foregroundColor:
                        Colors.white //here you can give the text color
                    )),
            // theme: FlexThemeData.light(scheme: FlexScheme.blue),
            // darkTheme: FlexThemeData.dark(scheme: FlexScheme.blue),
            // themeMode: _themeStore.useSystemMode
            //     ? ThemeMode.system
            //     : (_themeStore.isDarkMode ? ThemeMode.dark : ThemeMode.light),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routes: AppRoutes.getMap(),
            initialRoute: "/login"
            // initialRoute: "/login",
            ),
        builder: (_) {
          return reaction((_) => _loginFormStore.isLoggedIn, (_) {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
                _loginFormStore.isLoggedIn ? '/home' : '/login',
                (Route<dynamic> route) => false);
          });
        });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
