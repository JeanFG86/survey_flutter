enum UIError { requiredField, invalidField, unexpected, invalidCredentials, emailInUse }

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return '';
      case UIError.invalidField:
        return '';
      case UIError.invalidCredentials:
        return '';
      case UIError.emailInUse:
        return '';
      default:
        return 'any error';
    }
  }
}
