import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:survey_flutter/domain/usecases/usecases.dart';

class AddAccountSpy extends Mock implements AddAccount {
  When mockAddAccountCall() => when(() => add(any()));
  void mockAddAccount(AccountEntity data) => mockAddAccountCall().thenAnswer((_) async => data);
  void mockAddAccountError(DomainError error) => mockAddAccountCall().thenThrow(error);
}
