import 'package:get/get.dart';
import 'package:survey_flutter/domain/usecases/add_account.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import '../../domain/helpers/helpers.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  final AddAccount addAccount;

  final _nameError = Rx<UIError?>(null);
  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _passwordConfirmationError = Rx<UIError?>(null);
  final _isFormValid = false.obs;

  String? _name;
  String? _email;
  String? _password;
  String? _passwordConfirmation;

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<UIError?> get nameErrorStream => _nameError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  Stream<UIError?> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;

  set isFormValid(bool value) => _isFormValid.value = value;

  GetxSignUpPresenter({required this.validation, required this.addAccount});

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

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField('passwordConfirmation');
    _validateForm();
  }

  UIError? _validateField(String field) {
    final formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation
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
    isFormValid = _emailError.value == null &&
        _nameError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _name != null &&
        _email != null &&
        _password != null &&
        _passwordConfirmation != null;
  }

  Future<void> signUp() async {
    try {
      //mainError = null;
      //isLoading = true;
      final account = await addAccount.add(AddAccountParams(
          name: _name!, email: _email!, password: _password!, passwordConfirmation: _passwordConfirmation!));
      //await saveCurrentAccount.save(account);
      //navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.EmailInUse:
          //mainError = UIError.emailInUse;
          break;
        default:
          //mainError = UIError.unexpected;
          break;
      }
      //isLoading = false;
    }
  }
}
