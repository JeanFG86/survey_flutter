import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/http/http.dart';
import 'package:test/test.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({required this.url, required this.httpClient});

  Future<void> load() async {
    await httpClient.request(url: url, method: 'get');
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteLoadSurveys sut;
  late HttpClientSpy httpClient;
  late String url;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(() => httpClient.request(url: url, method: 'get'));
  });
}
