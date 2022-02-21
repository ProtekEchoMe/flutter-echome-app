import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';
import 'package:validators2/validators.dart';

// Include generated file
part 'login_form_store.g.dart';

// This is the class used by rest of your codebase
class LoginFormStore = _LoginFormStore with _$LoginFormStore;

// The store-class
abstract class _LoginFormStore with Store {
  final String TAG = "_LoginFormStore";

  // for handling network related error;
  final ErrorStore errorStore = ErrorStore();

  // for handling form validation error;
  final LoginFormErrorState error = LoginFormErrorState();

  // repo for sending request
  final Repository repository;

  _LoginFormStore(this.repository);

  @observable
  String email = "";

  @observable
  String password = "";

  @observable
  bool isLogining = false;

  @computed
  bool get isUserLogining => isLogining == true;


  @computed
  bool get isDataFilled => email.isEmpty || password.isEmpty ? false : true;

  late List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword)
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void validateAll() {
    validatePassword(password);
    validateEmail(email);
  }

  @action
  Future<void> login () async{
    try{
      isLogining = true;
      var result = await repository.login(email: email, password: password);
      print("login success with result ${result}");
    }catch(e){
      if(e is DioError){
        var message = (e as DioError).response?.data?["message"];
        errorStore.setErrorMessage(message);
      }
    }finally {
      isLogining = false;
    }
  }
  @action
  void validatePassword(String value) {
    error.password = isNull(value) || value.isEmpty ? 'Cannot be blank' : null;
    print(error.password);
  }

  @action
  void validateEmail(String value) {
    error.email = isEmail(value) ? null : 'Not a valid email';
  }


  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }


  void cancelLogin (){
    repository.cancelLogin();
  }
}

class LoginFormErrorState = _LoginFormErrorState with _$LoginFormErrorState;

abstract class _LoginFormErrorState with Store {
  @observable
  String? username;

  @observable
  String? email;

  @observable
  String? password;

  @computed
  bool get hasErrors => username != null || email != null || password != null;
}
