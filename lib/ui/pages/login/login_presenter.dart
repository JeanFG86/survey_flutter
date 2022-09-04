abstract class LoginPresenter {
  dynamic get emailErrorStream;
  dynamic get passwordErrorStream;
  dynamic get isFormValidStream;

  void validateEmail(String email);
  void validatePassword(String email);
  void auth();
}
