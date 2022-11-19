import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/usecases/usecases.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {
  When mockLoadCall() => when(() => load());
  void mockLoad(List<SurveyEntity> surveys) => mockLoadCall().thenAnswer((_) async => surveys);
  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);
}
