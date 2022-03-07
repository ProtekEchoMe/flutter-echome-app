import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/stores/login/login_form_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'custom_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm(
      {Key? key,
      required this.formKey,
      required this.emailController,
      required this.passwordController,
      required this.loginFormStore})
      : super(key: key);
  final Key formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoginFormStore loginFormStore;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.9,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Observer(builder: (_) {
                  return (TextField(
                    onChanged: (value) => loginFormStore.email = value,
                    controller: emailController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      isDense: true,
                      labelText: "login".tr(gender: "email"),
                      hintText: "login".tr(gender: "email_placeholder"),
                      errorText: loginFormStore.error.email,
                      prefixIcon: const Icon(Icons.email),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          emailController.clear();
                        },
                        child: const Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                  ));
                }),
                const SizedBox(width: double.maxFinite, height: 24),
                Observer(builder: (_) {
                  return (TextField(
                    onChanged: (value) => loginFormStore.password = value,
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      isDense: true,
                      labelText: "login".tr(gender: "password"),
                      hintText: "login".tr(gender: "password_placeholder"),
                      errorText: loginFormStore.error.password,
                      prefixIcon: const Icon(Icons.lock),
                      // suffixIcon: const Icon(Icons.visibility),
                    ),
                  ));
                }),
                const SizedBox(width: double.maxFinite, height: 24),
                Observer(
                  builder: (_) => SizedBox(
                    width: double.maxFinite,
                    child: Center(
                      child: CustomButton(
                        isLoading: loginFormStore.isUserLogining,
                          width: width * 0.88 - 50,
                          text: "login".tr(gender: "submit"),
                          onPressed: loginFormStore.isDataFilled
                              ? () {
                                  loginFormStore.validateAll();
                                  if (!loginFormStore.error.hasErrors) {
                                    loginFormStore.login();
                                  }
                                }
                              : null),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
