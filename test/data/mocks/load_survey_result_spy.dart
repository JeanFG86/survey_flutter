import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:survey_flutter/domain/usecases/usecases.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {
  When mockLoadCall() => when(() => loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity surveyResult) => mockLoadCall().thenAnswer((_) async => surveyResult);
  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);
}
