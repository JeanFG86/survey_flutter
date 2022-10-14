import 'package:get/get.dart';
import 'package:survey_flutter/domain/usecases/add_account.dart';
import 'package:survey_flutter/domain/usecases/save_current_account.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import '../../domain/helpers/helpers.dart';
import '../../ui/pages/signup/signup.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  final _nameError = Rx<UIError?>(null);
  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _passwordConfirmationError = Rx<UIError?>(null);
  final _mainError = Rx<UIError?>(null);
  final _isFormValid = false.obs;
  final _isLoading = false.obs;
  final _navigateTo = Rx<String?>(null);

  String? _name;
  String? _email;
  String? _password;
  String? _passwordConfirmation;

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<UIError?> get nameErrorStream => _nameError.stream;
  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<UIError?> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  set isFormValid(bool value) => _isFormValid.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set mainError(UIError? value) => _mainError.value = value;
  set navigateTo(String value) => _navigateTo.subject.add(value);

  GetxSignUpPresenter({required this.validation, required this.addAccount, required this.saveCurrentAccount});

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  @override
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

  @override
  Future<void> signUp() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await addAccount.add(AddAccountParams(
          name: _name!, email: _email!, password: _password!, passwordConfirmation: _passwordConfirmation!));
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          mainError = UIError.emailInUse;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
      isLoading = false;
    }
  }

  @override
  void goToLogin() {
    navigateTo = '/login';
  }
}
