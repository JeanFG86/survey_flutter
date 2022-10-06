import 'package:equatable/equatable.dart';
import 'package:survey_flutter/presentation/protocols/validation.dart';
import 'package:survey_flutter/validation/protocols/field_validation.dart';
import 'package:test/test.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int size;

  List get props => [field, size];

  MinLengthValidation({required this.field, required this.size});

  ValidationError? validate(Map input) =>
      input[field] != null && input[field].length >= size ? null : ValidationError.invalidField;
}

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });
  test('Should return error if value is empty', () {
    expect(sut.validate({'any_field': ''}), ValidationError.invalidField);
  });
}
