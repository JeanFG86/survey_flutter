import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/http/http.dart';
import 'package:survey_flutter/data/usecases/usecases.dart';
import 'package:survey_flutter/domain/usecases/usecases.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AddAccountParams params;

/*
  Map mockValidData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  When mockRequest() =>
      when(() => httpClient.request(url: any(named: 'url'), method: any(named: 'method'), body: any(named: 'body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }
  */

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
        name: faker.person.name(),
        email: faker.internet.email(),
        password: faker.internet.password(),
        passwordConfirmation: faker.internet.password());
    //mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct Values', () async {
    await sut.add(params);

    verify(() => httpClient.request(url: url, method: 'post', body: {
          'name': params.name,
          'email': params.email,
          'password': params.password,
          'passwordConfirmation': params.passwordConfirmation
        }));
  });
}
