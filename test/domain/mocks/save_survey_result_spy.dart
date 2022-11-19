import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:survey_flutter/domain/usecases/usecases.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {
  When mockSaveCall() => when(() => save(answer: any(named: 'answer')));
  void mockSave(SurveyResultEntity data) => mockSaveCall().thenAnswer((_) async => data);
  void mockSaveError(DomainError error) => mockSaveCall().thenThrow(error);
}
