import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';
import 'package:validators2/validators.dart';

part 'forget_password_store.g.dart';

class ForgetPasswordStore = _ForgetPasswordStore with _$ForgetPasswordStore;

abstract class _ForgetPasswordStore with Store {
  final String TAG = "_ForgetPasswordStore";

  // for handling network related error;
  final ErrorStore errorStore = ErrorStore();

  final Repository repository;

   _ForgetPasswordStore(this.repository);

  @observable
  String email = "";

  @observable
  String? error ;

  final List<ReactionDisposer> _disposers= [];

  void setupValidations() {
    var dis = reaction((_) => email, validateEmail);
    _disposers.add( dis );
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  @action
  void setEmail(String value){
    email = value;
  }

  @action
  void validateEmail(String value) {
    error = isEmail(value) ? null  : 'Not a valid email';
  }

  @computed
  bool get hasError => error == null ? false : true;

  @action
  Future<void> sendResetPasswordRequest() async {

  }

}
