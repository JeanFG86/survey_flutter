import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/cache/cache.dart';
import 'package:survey_flutter/data/usecases/usecases.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:test/test.dart';

class CacheStorageSpy extends Mock implements CacheStorage {
  CacheStorageSpy() {
    mockDelete();
    mockSave();
  }

  When mockFetchCall() => when(() => fetch(any()));
  void mockFetch(dynamic json) => mockFetchCall().thenAnswer((_) async => json);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => mockDeleteCall().thenThrow(Exception());

  When mockSaveCall() => when(() => save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}

class CacheFactory {
  static List<Map> makeSurveyList() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2020-07-20T00:00:00Z',
          'didAnswer': 'false',
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2019-02-02T00:00:00Z',
          'didAnswer': 'true',
        }
      ];

  static List<Map> makeInvalidSurveyList() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid date',
          'didAnswer': 'false',
        }
      ];

  static List<Map> makeIncompleteSurveyList() => [
        {
          'date': '2019-02-02T00:00:00Z',
          'didAnswer': 'false',
        }
      ];

  static List<SurveyEntity> makeSurveyList2() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: DateTime.utc(2020, 2, 2),
            didAnswer: true),
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: DateTime.utc(2018, 12, 20),
            didAnswer: false)
      ];
}

void main() {
  late CacheStorageSpy cacheStorage;
  late LocalLoadSurveys sut;
  late List<Map> data;
  late List<SurveyEntity> surveys;

  setUp(() {
    surveys = CacheFactory.makeSurveyList2();
    data = CacheFactory.makeSurveyList();
    cacheStorage = CacheStorageSpy();
    cacheStorage.mockFetch(data);
    sut = LocalLoadSurveys(cacheStorage: cacheStorage);
  });
  group('load', () {
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
            id: data[0]['id'], question: data[0]['question'], dateTime: DateTime.utc(2020, 7, 20), didAnswer: false),
        SurveyEntity(
            id: data[1]['id'], question: data[1]['question'], dateTime: DateTime.utc(2019, 2, 2), didAnswer: true),
      ]);
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      cacheStorage.mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is isvalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyList());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyList());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      cacheStorage.mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call CacheStorage on validate', () async {
      await sut.validate();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyList());

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyList());

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    test('Should call cacheStorage save with correct values', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': '2020-02-02T00:00:00.000Z',
          'didAnswer': 'true',
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': '2018-12-20T00:00:00.000Z',
          'didAnswer': 'false',
        }
      ];

      await sut.save(surveys);

      verify(() => cacheStorage.save(key: 'surveys', value: list)).called(1);
    });
  });

  test('Should throw UnexpectedError if save throws', () async {
    cacheStorage.mockSaveError();

    final future = sut.save(surveys);

    expect(future, throwsA(DomainError.unexpected));
  });
}
