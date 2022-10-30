import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/cache/cache.dart';
import 'package:survey_flutter/data/http/http.dart';
import 'package:test/test.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({required this.fetchSecureCacheStorage, required this.decoratee});

  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers,
  }) async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    final authorizedHeaders = headers ?? {}
      ..addAll({'x-access-token': token});
    return await decoratee.request(url: url, method: method, body: body, headers: authorizedHeaders);
  }
}

class SecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {
  SecureCacheStorageSpy();

  When mockFetchCall() => when(() => fetchSecure(any()));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());
}

class HttpClientSpy extends Mock implements HttpClient {
  When mockRequestCall() => when(() => request(
      url: any(named: 'url'), method: any(named: 'method'), body: any(named: 'body'), headers: any(named: 'headers')));
  void mockRequest(dynamic data) => mockRequestCall().thenAnswer((_) async => data);
  void mockRequestError(HttpError error) => mockRequestCall().thenThrow(error);
}

void main() {
  late AuthorizeHttpClientDecorator sut;
  late SecureCacheStorageSpy secureCacheStorage;
  late HttpClientSpy httpClient;
  late String url;
  late String method;
  late Map body;
  late String token;
  late String httpResponse;

  setUp(() {
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    token = faker.guid.guid();
    httpResponse = faker.randomGenerator.string(50);
    secureCacheStorage = SecureCacheStorageSpy();
    secureCacheStorage.mockFetch(token);
    httpClient = HttpClientSpy();
    httpClient.mockRequest(httpResponse);
    sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage: secureCacheStorage, decoratee: httpClient);
  });
  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => secureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(() => httpClient.request(url: url, method: method, body: body, headers: {'x-access-token': token}))
        .called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_header': 'any_value'});
    verify(() => httpClient.request(
        url: url, method: method, body: body, headers: {'x-access-token': token, 'any_header': 'any_value'})).called(1);
  });
}
