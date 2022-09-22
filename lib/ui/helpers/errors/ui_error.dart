enum UIError { requiredField, invalidField, unexpected, invalidCredentials, emailInUse }

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return 'Campo obrigratório.';
      case UIError.invalidField:
        return 'Campo inválido.';
      case UIError.invalidCredentials:
        return 'Credenciais inválidas.';
      case UIError.emailInUse:
        return 'E-mail já informado.';
      default:
        return 'Algo errado aconteceu. Tente novamente em breve.';
    }
  }
}
