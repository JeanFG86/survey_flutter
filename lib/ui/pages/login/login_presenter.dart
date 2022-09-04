abstract class LoginPresenter {
  dynamic get emailErrorStream;
  dynamic get passwordErrorStream;

  void validateEmail(String email);
  void validatePassword(String email);
}
