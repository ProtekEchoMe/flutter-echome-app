import 'package:dio/dio.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';
import 'package:validators2/validators.dart';
import 'package:jwt_decode/jwt_decode.dart';


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
  bool isChangingSite = false;

  @observable
  String? siteCode;

  @observable
  String? accessToken;

  @observable
  String? refreshToken;

  @observable
  String? idToken;

  @computed
  Map<String, dynamic>? get payload => Jwt.parseJwt(accessToken!);

  @observable
  String email = "";

  @observable
  String password = "";

  @observable
  bool isLogining = false;

  @observable
  bool isLoggedIn = false;

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
  Future<void> logout() async {
    try{
      repository.logout(refreshToken: refreshToken ?? "");
    } catch(e){
      print("Some error occur when logout $e");
      print("nothing");
    } finally{
      isLoggedIn = false;
      accessToken = "";
      refreshToken = "";
      idToken = "";

    }
  }

  @action
  Future<void> login() async {
    isLogining = true;
    try {
      var auth = await repository.login(email: email, password: password);
      print("login success");
      accessToken = auth.accessToken;
      refreshToken = auth.refreshToken;
      idToken = auth.idToken;
      isLoggedIn = true;
      // payload = Jwt.parseJwt(auth.accessToken!);
      // repository.saveAuthToken(auth.accessToken!); // will trigger Header Interceptor afterwards

    } catch (e) {
      print(e);
      if (e is DioError) {
        String message = (e as DioError).response?.data?["error_description"];
        // message = message ?? "";
        //
        // message += e.error.message;
        errorStore.setErrorMessage(message);
      }
    } finally {
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
    error.email = null;
    // error.email = isEmail(value) ? null : 'Not a valid email';
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action 
  Future<void> changeSite({String siteCode=""})async{
     isChangingSite = true;
    try {
      await repository.changeSite(siteCode:siteCode);
      print("change site success");
      this.siteCode = siteCode;
    } catch (e) {
      print(e);
      if (e is DioError) {
        DioError errorIO = e as DioError;
        if (errorIO.response != null) {
          var message = errorIO.response?.data?["error_description"];
          errorStore.setErrorMessage(message);
        }else{
          var message = errorIO.error.message;
          errorStore.setErrorMessage(message);
        }

      }
    } finally {
        isChangingSite = false;
    }
  }

  void cancelLogin() {
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
