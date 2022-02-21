// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_password_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ForgetPasswordStore on _ForgetPasswordStore, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: '_ForgetPasswordStore.hasError'))
          .value;

  final _$emailAtom = Atom(name: '_ForgetPasswordStore.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$errorAtom = Atom(name: '_ForgetPasswordStore.error');

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$sendResetPasswordRequestAsyncAction =
      AsyncAction('_ForgetPasswordStore.sendResetPasswordRequest');

  @override
  Future<void> sendResetPasswordRequest() {
    return _$sendResetPasswordRequestAsyncAction
        .run(() => super.sendResetPasswordRequest());
  }

  final _$_ForgetPasswordStoreActionController =
      ActionController(name: '_ForgetPasswordStore');

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_ForgetPasswordStoreActionController.startAction(
        name: '_ForgetPasswordStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_ForgetPasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateEmail(String value) {
    final _$actionInfo = _$_ForgetPasswordStoreActionController.startAction(
        name: '_ForgetPasswordStore.validateEmail');
    try {
      return super.validateEmail(value);
    } finally {
      _$_ForgetPasswordStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
error: ${error},
hasError: ${hasError}
    ''';
  }
}
