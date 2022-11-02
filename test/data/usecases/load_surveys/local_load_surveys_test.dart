import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class CacheStorage {
  Future<void> fetch(String key);
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
  Future<void> load() async {
    await cacheStorage.fetch('surveys');
  }
}

void main() {
  late CacheStorageSpy cacheStorage;
  late LocalLoadSurveys sut;

  setUp(() {
    cacheStorage = CacheStorageSpy();
    sut = LocalLoadSurveys(cacheStorage: cacheStorage);
  });
  test('Should call FetchCacheStorage with correct key', () async {
    await sut.load();

    verify(() => cacheStorage.fetch('surveys')).called(1);
  });
}
