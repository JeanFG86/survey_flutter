import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/models/models.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:test/test.dart';

abstract class CacheStorage {
  Future<dynamic> fetch(String key);
}

class CacheStorageSpy extends Mock implements CacheStorage {
  CacheStorageSpy();

  When mockFetchCall() => when(() => fetch(any()));
  void mockFetch(dynamic json) => mockFetchCall().thenAnswer((_) async => json);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());
}

class LocalLoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({required this.cacheStorage});

  Future<List<SurveyEntity>> load() async {
    final data = await cacheStorage.fetch('surveys');

    try {
      if (data?.isEmpty != false) {
        throw Exception;
      }

      return _mapToEntity(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  List<SurveyEntity> _mapToEntity(dynamic list) =>
      list.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
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
}

void main() {
  late CacheStorageSpy cacheStorage;
  late LocalLoadSurveys sut;
  late List<Map> data;

  setUp(() {
    data = CacheFactory.makeSurveyList();
    cacheStorage = CacheStorageSpy();
    cacheStorage.mockFetch(data);
    sut = LocalLoadSurveys(cacheStorage: cacheStorage);
  });

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
}
