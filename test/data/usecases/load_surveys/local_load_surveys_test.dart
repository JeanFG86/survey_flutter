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

void main() {
  test('Should call FetchCacheStorage with correct key', () async {
    final fetchCacheStorage = CacheStorageSpy();
    final sut = LocalLoadSurveys(cacheStorage: fetchCacheStorage);

    await sut.load();

    verify(() => fetchCacheStorage.fetch('surveys')).called(1);
  });
}

class LocalLoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({required this.cacheStorage});
  Future<void> load() async {
    await cacheStorage.fetch('surveys');
  }
}
