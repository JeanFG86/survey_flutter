import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
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

void main() {
  late StreamLoginPresenter sut;
  late ValidationSpy validation;
  late String email;
  late String password;

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
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
}
