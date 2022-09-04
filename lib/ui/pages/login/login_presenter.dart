abstract class LoginPresenter {
  dynamic get emailErrorStream;

  void validateEmail(String email);
  void validatePassword(String email);
}
