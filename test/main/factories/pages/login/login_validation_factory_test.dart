import 'package:survey_flutter/main/factories/factories.dart';
import 'package:survey_flutter/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      const RequiredFieldValidation('email'),
      const EmailValidation('email'),
      const RequiredFieldValidation('password')
    ]);
  });
}
