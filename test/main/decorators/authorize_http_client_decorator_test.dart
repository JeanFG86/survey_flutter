import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/cache/cache.dart';
import 'package:test/test.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({required this.fetchSecureCacheStorage});

  Future<void> request() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

class SecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {
  SecureCacheStorageSpy();

  When mockFetchCall() => when(() => fetchSecure(any()));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());
}

void main() {
  late AuthorizeHttpClientDecorator sut;
  late SecureCacheStorageSpy secureCacheStorage;

  setUp(() {
    secureCacheStorage = SecureCacheStorageSpy();
    secureCacheStorage.mockFetch('token');
    sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage: secureCacheStorage);
  });
  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request();

    verify(() => secureCacheStorage.fetchSecure('token')).called(1);
  });
}
