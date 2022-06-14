import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/constants/app_data.dart';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/constants/strings.dart';
import 'package:echo_me_mobile/data/sharedpref/constants/preferences.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:echo_me_mobile/widgets/login_form.dart';
import 'package:echo_me_mobile/data/network/constants/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'package:echo_me_mobile/utils/dialog_helper/auto_complete_searchbar.dart';
import 'package:echo_me_mobile/utils/dialog_helper/dialog_helper.dart';
import 'package:echo_me_mobile/data/sharedpref/shared_preference_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final LoginFormStore loginFormStore = getIt<LoginFormStore>();

  final SharedPreferenceHelper sharePreferenceHelper = getIt<SharedPreferenceHelper>();

  ReactionDisposer? disposer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginFormStore.setupValidations();

    // init sharePreference --> defaultDomainSite
    String? defaultServierDomainName = sharePreferenceHelper.defaultServierDomainName;
    if (defaultServierDomainName == null) {
      sharePreferenceHelper.changeDefaulServicetDomainName(Endpoints.domainList[0]);
    }
    // update Selection
    defaultServierDomainName = sharePreferenceHelper.defaultServierDomainName;
    Endpoints.updateFunctionEndPoint(
        Endpoints.domainMap[defaultServierDomainName]);
    Endpoints.updateKeyCloakEndPoint(
        Endpoints.keyClockDomainMap[defaultServierDomainName]);

    disposer = reaction((_) => loginFormStore.errorStore.errorMessage, (_) {
      if (loginFormStore.errorStore.errorMessage.isNotEmpty) {
        _showSnackBar(loginFormStore.errorStore.errorMessage);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loginFormStore.dispose();
    loginFormStore.cancelLogin();
    if (disposer != null) disposer!();
  }

  void _showSnackBar(String msg) {
    var snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _getBackground(BuildContext ctx, double safeareaTop) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: (220 + safeareaTop),
      child: Arc(
        height: 20,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary
              ])),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('/build'); // var safeareaTop = MediaQuery.of(context).padding.top;
    const safeareaTop = 0.0;
    return WillPopScope(
      onWillPop: () {
        print("onWillPop");
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.language))
          ],
        ),
        backgroundColor: Theme.of(context).cardColor,
        body: SizedBox.expand(
            child: Stack(
          children: [
            _getBackground(context, safeareaTop),
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.horizontal_padding),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: double.maxFinite,
                        height: safeareaTop,
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 140,
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimens.vertical_padding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              Strings.appName,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).cardColor),
                            ),
                            Text(
                              "login".tr(gender: "description"),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context).cardColor),
                            ),
                            // TextButton(
                            //   onPressed: () => showDialog<String>(
                            //       context: context,
                            //       barrierDismissible: false, // user must tap button!
                            //       builder: (BuildContext context) {
                            //         return WillPopScope(
                            //           onWillPop: () async => false,
                            //           child: AlertDialog(
                            //             title: const Text("Choose the Server"),
                            //             content: SingleChildScrollView(
                            //               child: ListBody(
                            //                 children: <Widget>[
                            //                   ...Endpoints.domainMap.keys.toList().map((e) {
                            //                     return GestureDetector(
                            //                       onTap: () async {
                            //                         print(e);
                            //                         // Endpoints.printEndPoint();
                            //                         // print(Preferences.defaultDomain);
                            //                         Preferences.defaultDomain = e;
                            //                         // print(Preferences.defaultDomain);
                            //                         Endpoints.updateFunctionEndPoint(Endpoints.domainMap[e]);
                            //                         Endpoints.updateKeyCloakEndPoint(Endpoints.keyClockDomainMap[e]);
                            //                         // Endpoints.printEndPoint();
                            //                         // if (e != loginFormStore.siteCode) {
                            //                         //   await loginFormStore.changeSite(siteCode: e);
                            //                         // }
                            //                         Navigator.of(context).pop();
                            //                       },
                            //                       child: ListTile(
                            //                         title: Text(e),
                            //                       ),
                            //                     );
                            //                   }).toList()
                            //                 ],
                            //               ),
                            //             ),
                            //             actions: <Widget>[],
                            //           ),
                            //         );
                            //       },
                            //   )
                            //       ,
                            //   child: const Text(''),
                            //
                            //
                            // ),
                          ],
                        ),
                      ),
                      LoginForm(
                        loginFormStore: loginFormStore,
                        passwordController: _passwordController,
                        emailController: _emailController,
                        formKey: formKey,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, "/forget_password"),
                        child: Text(
                          "login".tr(gender: "forget_password"),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      ),
                      Text(""),
                      Text("App Version: ${AppData.appVersion}"),
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 100.0),
                          child: TextButton(
                            onPressed: () {
                              void onClickFunction(String selectedDomainKey){
                                sharePreferenceHelper.changeDefaulServicetDomainName(selectedDomainKey);
                                Endpoints.updateFunctionEndPoint(
                                    Endpoints.domainMap[selectedDomainKey]);
                                Endpoints.updateKeyCloakEndPoint(
                                    Endpoints.keyClockDomainMap[selectedDomainKey]);
                              }
                              DialogHelper.listSelectionDialogWithAutoCompleteBar(
                                  context, List<String?>.from(Endpoints.domainMap.keys.toList()), onClickFunction,
                                  willPop: true);
                            },
                            child: const Text(''),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    print("called");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text("Choose the site"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ...Endpoints.domainMap.keys.toList().map((e) {
                    return GestureDetector(
                      onTap: () async {
                        print(e);
                        // if (e != loginFormStore.siteCode) {
                        //   await loginFormStore.changeSite(siteCode: e);
                        // }
                        Navigator.of(context).pop();
                      },
                      child: ListTile(
                        title: Text(e),
                      ),
                    );
                  }).toList()
                ],
              ),
            ),
            actions: <Widget>[],
          ),
        );
      },
    );
  }
}
