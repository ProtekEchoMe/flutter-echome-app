import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/constants/dimens.dart';
import 'package:echo_me_mobile/di/service_locator.dart';
import 'package:echo_me_mobile/stores/login/forget_password_store.dart';
import 'package:echo_me_mobile/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final ForgetPasswordStore forgetPasswordStore = getIt<ForgetPasswordStore>();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forgetPasswordStore.setupValidations();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    forgetPasswordStore.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        print("onWillPop");
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 10,
            centerTitle: true,
            title: Text(
              "login".tr(gender: "forget_password"),
            )),
        body: Stack(
          children: [
            Positioned.fill(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.horizontal_padding,
                    vertical: Dimens.vertical_padding),
                child: Column(
                  children: [
                    Text("login".tr(gender: "forget_password_description")),
                    const SizedBox(
                      width: double.infinity,
                      height: 12,
                    ),
                    Observer(
                      builder:(_) => TextField(
                        onChanged: (value)=> forgetPasswordStore.setEmail(value),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder(),
                          isDense: true,
                          labelText: "login".tr(gender: "email"),
                          hintText: "login".tr(gender: "email_placeholder"),
                          errorText: forgetPasswordStore.error
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 12,
                    ),
                    Observer(
                      builder: (_) => SizedBox(
                        width: double.maxFinite,
                        child: Center(
                          child: CustomButton(
                            width: MediaQuery.of(context).size.width - Dimens.horizontal_padding*2 - 5,
                            text: "login".tr(gender: "forget_password_submit"),
                            onPressed: !forgetPasswordStore.hasError
                                ? () {
                                    Loader.show(context);
                                  }
                                : null,
                            ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
