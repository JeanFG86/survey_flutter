import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:survey_flutter/domain/usecases/usecases.dart';

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {
  SaveCurrentAccountSpy() {
    mockSave();
  }

  When mockSaveCall() => when(() => save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(DomainError.unexpected);
}
