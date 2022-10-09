import 'package:get/get.dart';
import 'package:survey_flutter/domain/helpers/domain_error.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import 'package:survey_flutter/ui/pages/login/login_presenter.dart';

import '../../domain/usecases/usecases.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _mainError = Rx<UIError?>(null);
  final _navigateTo = Rx<String?>(null);
  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  String? _email;
  String? _password;

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;
  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  set isFormValid(bool value) => _isFormValid.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set mainError(UIError? value) => _mainError.value = value;
  set navigateTo(String value) => _navigateTo.subject.add(value);

  GetxLoginPresenter({required this.validation, required this.authentication, required this.saveCurrentAccount});

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
    try {
      mainError = null;
      _isLoading.value = true;
      final account = await authentication.auth(AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
      //_navigateTo.value = '/login';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;
        default:
          _mainError.value = UIError.unexpected;
      }
      _isLoading.value = false;
    }
  }

  void goToSignUp() {
    navigateTo = '/signup';
  }

  @override
  // ignore: must_call_super
  void dispose() {}
}
