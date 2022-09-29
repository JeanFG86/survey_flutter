import 'package:flutter/material.dart';
import 'package:survey_flutter/ui/helpers/errors/ui_error.dart';

abstract class SignUpPresenter implements Listenable {
  Stream<UIError?> get nameErrorStream;
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get passwordConfirmationErrorStream;

  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String passwordConfirmation);
  void dispose();
}
