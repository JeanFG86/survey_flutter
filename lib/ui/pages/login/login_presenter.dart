import 'package:flutter/material.dart';
import 'package:survey_flutter/ui/helpers/errors/ui_error.dart';

abstract class LoginPresenter implements Listenable {
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String?> get mainErrorStream;

  void validateEmail(String email);
  void validatePassword(String email);
  Future<void> auth();
  void dispose();
}
