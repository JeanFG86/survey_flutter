import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/usecases/usecases.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
  When mockLoadCall() => when(() => loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity surveyResult) => mockLoadCall().thenAnswer((_) async => surveyResult);
  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);
}
