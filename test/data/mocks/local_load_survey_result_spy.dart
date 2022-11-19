import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/usecases/usecases.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {
  LocalLoadSurveyResultSpy() {
    mockValidate();
    mockSave();
  }

  When mockLoadCall() => when(() => loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity surveyResult) => mockLoadCall().thenAnswer((_) async => surveyResult);
  void mockLoadError() => mockLoadCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => validate(any()));
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);
  void mockValidateError() => mockValidateCall().thenThrow(Exception());

  When mockSaveCall() => when(() => save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}
