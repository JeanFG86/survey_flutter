import 'dart:async';

import 'package:get/get.dart';
import 'package:survey_flutter/domain/helpers/domain_error.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import 'package:survey_flutter/ui/pages/login/login_presenter.dart';

import '../../domain/usecases/usecases.dart';
import '../protocols/protocols.dart';

class LoginState {
  String? emailError;
  String? passwordError;
  String? email;
  String? password;
  String? mainError;
  bool isLoading = false;
  bool get isFormValid => emailError == null && passwordError == null && email != null && password != null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final _controller = StreamController<LoginState>.broadcast();

  final _state = LoginState();

  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);

  String? _email;
  String? _password;

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  Stream<String?> get mainErrorStream => _controller.stream.map((state) => state.mainError).distinct();
  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();
  Stream<bool> get isLoadingStream => _controller.stream.map((state) => state.isLoading).distinct();

  StreamLoginPresenter({required this.validation, required this.authentication});

  void _update() => _controller.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = validation.validate(field: 'password', value: password);
    _update();
  }

/*
  UIError? _validateField(String field, String value) {
    final error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    isFormValid = _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }
  */

  Future<void> auth() async {
    if (_state.email != null && _state.password != null) {
      _state.isLoading = true;
      _update();

      try {
        await authentication.auth(AuthenticationParams(email: _state.email!, secret: _state.password!));
      } on DomainError catch (error) {
        _state.mainError = error.description;
      }

      _state.isLoading = false;
      _update();
    }
  }

  void dispose() {
    _controller.close();
  }
}
