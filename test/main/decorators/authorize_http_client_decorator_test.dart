import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/cache/cache.dart';
import 'package:test/test.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({required this.fetchSecureCacheStorage});

  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers,
  }) async {
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
  late String url;
  late String method;
  late Map body;
  late String token;

  setUp(() {
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    token = faker.guid.guid();
    secureCacheStorage = SecureCacheStorageSpy();
    secureCacheStorage.mockFetch(token);
    sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage: secureCacheStorage);
  });
  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => secureCacheStorage.fetchSecure('token')).called(1);
  });
}
