import 'package:get/get.dart';
import 'package:survey_flutter/domain/helpers/domain_error.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import 'package:survey_flutter/ui/pages/login/login_presenter.dart';

import '../../domain/usecases/usecases.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _mainError = Rx<String?>(null);
  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  String? _email;
  String? _password;

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;
  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<String?> get mainErrorStream => _mainError.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxLoginPresenter({required this.validation, required this.authentication});

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  UIError? _validateField(String field) {
    final formData = {
      'email': _email,
      'password': _password,
    };
    final error = validation.validate(field: field, input: formData);
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
    _isFormValid.value =
        _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  @override
  Future<void> auth() async {
    if (_email != null && _password != null) {
      _isLoading.value = true;

      try {
        await authentication.auth(AuthenticationParams(email: _email!, secret: _password!));
      } on DomainError catch (error) {
        _mainError.value = error.description;
      }

      _isLoading.value = false;
    }
  }

  @override
  // ignore: must_call_super
  void dispose() {}
}
