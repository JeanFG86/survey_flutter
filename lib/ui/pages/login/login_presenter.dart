import 'package:flutter/material.dart';
import 'package:survey_flutter/ui/helpers/errors/ui_error.dart';

abstract class LoginPresenter implements Listenable {
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String?> get navigateToStream;

  void validateEmail(String email);
  void validatePassword(String email);
  Future<void> auth();
  void dispose();
  void goToSignUp();
}
