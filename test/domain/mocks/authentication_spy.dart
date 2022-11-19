import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:survey_flutter/domain/usecases/usecases.dart';

class AuthenticationSpy extends Mock implements Authentication {
  When mockAuthenticationCall() => when(() => auth(any()));
  void mockAuthentication(AccountEntity data) => mockAuthenticationCall().thenAnswer((_) async => data);
  void mockAuthenticationError(DomainError error) => mockAuthenticationCall().thenThrow(error);
}
