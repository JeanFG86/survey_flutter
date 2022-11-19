import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/usecases/usecases.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {
  LocalLoadSurveysSpy() {
    mockValidate();
    mockSave();
  }

  When mockLoadCall() => when(() => load());
  void mockLoad(List<SurveyEntity> surveys) => mockLoadCall().thenAnswer((_) async => surveys);
  void mockLoadError() => mockLoadCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => validate());
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);
  void mockValidateError() => mockValidateCall().thenThrow(Exception());

  When mockSaveCall() => when(() => save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}
