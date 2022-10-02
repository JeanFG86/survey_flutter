import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/entities/account_entity.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:survey_flutter/domain/usecases/usecases.dart';
import 'package:survey_flutter/presentation/presenter/presenter.dart';
import 'package:survey_flutter/presentation/protocols/validation.dart';
import 'package:survey_flutter/ui/helpers/errors/ui_error.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {
  ValidationSpy() {
    mockValidation();
  }

  When mockValidationCall(String? field) =>
      when(() => validate(field: field ?? any(named: 'field'), input: any(named: 'input')));
  void mockValidation({String? field}) => mockValidationCall(field).thenReturn(null);
  void mockValidationError({String? field, required ValidationError value}) =>
      mockValidationCall(field).thenReturn(value);
}

class EntityFactory {
  static AccountEntity makeAccount() => AccountEntity(token: faker.guid.guid());
}

class ParamsFactory {
  static AuthenticationParams makeAuthentication() =>
      AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
}

void main() {
  late GetxSignUpPresenter sut;
  late ValidationSpy validation;
  late String email;
  late String name;
  late String password;

  setUp(() {
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(validation: validation);
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.guid.guid();
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAuthentication());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call Validation with correct email', () {
    final formData = {'name': null, 'email': email, 'password': null, 'passwordConfirmation': null};

    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct name', () {
    final formData = {'name': name, 'email': null, 'password': null, 'passwordConfirmation': null};

    sut.validateName(name);

    verify(() => validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if name is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredFieldError if name is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    final formData = {'name': null, 'email': null, 'password': password, 'passwordConfirmation': null};

    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if password is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit requiredFieldError if password is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });
}
