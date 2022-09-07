import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/entities/account_entity.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:survey_flutter/domain/usecases/authentication.dart';
import 'package:survey_flutter/presentation/presenter/presenter.dart';
import 'package:survey_flutter/presentation/protocols/validation.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {
  ValidationSpy() {
    mockValidation();
  }

  When mockValidationCall(String? field) => when(() => validate(field: field ?? 'field', value: 'value'));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }
}

class AuthenticationSpy extends Mock implements Authentication {
  When mockAuthenticationCall() => when(() => auth(any()));
  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) => mockAuthenticationCall().thenThrow(error);
  //void mockAuthentication(AccountEntity data) => mockAuthenticationCall().thenAnswer((_) async => data);
}

void main() {
  late StreamLoginPresenter sut;
  late AuthenticationSpy authentication;
  late ValidationSpy validation;
  late String email;
  late String password;

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    //authentication.mockAuthentication();
    sut = StreamLoginPresenter(validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () async {
    validation.mockValidation(value: 'error');

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    //sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
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

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () async {
    validation.mockValidation(value: 'error');

    //sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () async {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit form valid event form is valid', () async {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => authentication.auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    authentication.mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Credenciais inválidas')));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Algo errado aconteceu')));

    await sut.auth();
  });
}
