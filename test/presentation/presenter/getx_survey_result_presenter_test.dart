import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:survey_flutter/domain/usecases/usecases.dart';
import 'package:survey_flutter/presentation/presenter/presenter.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import 'package:survey_flutter/ui/pages/pages.dart';
import 'package:survey_flutter/ui/pages/surveys/surveys.dart';
import 'package:test/test.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {
  When mockLoadCall() => when(() => loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity surveyResult) => mockLoadCall().thenAnswer((_) async => surveyResult);
  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);
}

SurveyResultEntity makeValidData() =>
    SurveyResultEntity(surveyId: faker.guid.guid(), question: faker.lorem.sentence(), answers: [
      SurveyAnswerEntity(
          image: faker.internet.httpUrl(),
          answer: faker.lorem.sentence(),
          isCurrentAnswer: faker.randomGenerator.boolean(),
          percent: faker.randomGenerator.integer(100)),
      SurveyAnswerEntity(
          answer: faker.lorem.sentence(),
          isCurrentAnswer: faker.randomGenerator.boolean(),
          percent: faker.randomGenerator.integer(100)),
    ]);

void main() {
  late GetxSurveyResultPresenter sut;
  late LoadSurveyResultSpy loadSurveyResult;
  late SurveyResultEntity surveyResult;
  late String surveyId;

  setUp(() {
    surveyResult = makeValidData();
    loadSurveyResult = LoadSurveyResultSpy();
    loadSurveyResult.mockLoad(surveyResult);
    surveyId = faker.guid.guid();
    sut = GetxSurveyResultPresenter(loadSurveyResult: loadSurveyResult, surveyId: surveyId);
  });

  test('Should call LoadSurveyResult on loadData', () async {
    await sut.loadData();

    verify(() => loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(expectAsync1((result) => expect(
        result,
        SurveyResultViewModel(surveyId: surveyResult.surveyId, question: surveyResult.question, answers: [
          SurveyAnswerViewModel(
              image: surveyResult.answers[0].image,
              answer: surveyResult.answers[0].answer,
              isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
              percent: '${surveyResult.answers[0].percent}%'),
          SurveyAnswerViewModel(
              answer: surveyResult.answers[1].answer,
              isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
              percent: '${surveyResult.answers[1].percent}%')
        ]))));

    await sut.loadData();
  });

  test('Should emit correct events on failure', () async {
    loadSurveyResult.mockLoadError(DomainError.unexpected);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream
        .listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

    await sut.loadData();
  });
}
