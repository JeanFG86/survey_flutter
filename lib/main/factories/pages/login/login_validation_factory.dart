import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/field_validation.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    const RequiredFieldValidation('email'),
    const EmailValidation('email'),
    const RequiredFieldValidation('password')
  ];
}
