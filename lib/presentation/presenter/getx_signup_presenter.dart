import 'package:get/get.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  final _nameError = Rx<UIError?>(null);
  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _isFormValid = false.obs;

  String? _name;
  String? _email;
  String? _password;

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<UIError?> get nameErrorStream => _nameError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  set isFormValid(bool value) => _isFormValid.value = value;

  GetxSignUpPresenter({required this.validation});

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  UIError? _validateField(String field) {
    final formData = {'name': _name, 'email': _email};
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
    isFormValid =
        _emailError.value == null && _nameError.value == null && _name != null && _email != null && _password != null;
  }
}
