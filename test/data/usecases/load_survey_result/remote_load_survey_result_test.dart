import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/http/http.dart';
import 'package:survey_flutter/data/usecases/usecases.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {
  When mockRequestCall() =>
      when(() => request(url: any(named: 'url'), method: any(named: 'method'), body: any(named: 'body')));
  void mockRequest(dynamic data) => mockRequestCall().thenAnswer((_) async => data);
  void mockRequestError(HttpError error) => mockRequestCall().thenThrow(error);
}

class ApiFactory {
  static Map makeSurvey() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'coun': faker.randomGenerator.integer(2000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'coun': faker.randomGenerator.integer(2000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          }
        ],
        'date': faker.date.dateTime().toIso8601String(),
      };

  static Map makeInvalidData() => {'invalid_key': 'invalid_value'};
}

void main() {
  late RemoteLoadSurveyResult sut;
  late HttpClientSpy httpClient;
  late String url;
  late Map surveyResult;

  setUp(() {
    surveyResult = ApiFactory.makeSurvey();
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    httpClient.mockRequest(surveyResult);
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.loadBySurvey();

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys result on 200', () async {
    final result = await sut.loadBySurvey();

    expect(
        result,
        SurveyResultEntity(surveyId: surveyResult['surveyId'], question: surveyResult['question'], answers: [
          SurveyAnswerEntity(
            image: surveyResult['answers'][0]['image'],
            answer: surveyResult['answers'][0]['answer'],
            isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'],
            percent: surveyResult['answers'][0]['percent'],
          ),
          SurveyAnswerEntity(
            answer: surveyResult['answers'][1]['answer'],
            isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'],
            percent: surveyResult['answers'][1]['percent'],
          )
        ]));
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    httpClient.mockRequest(ApiFactory.makeInvalidData());

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
