import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;
  HttpAdapter(this.client);
  Future<void> request({required String url, required String method}) async {
    late Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    await client.post(Uri.parse(url), headers: headers);
  }
}

class ClientSpy extends Mock implements Client {
  ClientSpy() {
    mockPost(200);
  }
  When mockPostCall() =>
      when(() => this.post(any(), headers: any(named: 'headers')));
  void mockPost(int statusCode, {String body = '{"any_key":"any_value"}'}) =>
      mockPostCall().thenAnswer((_) async => Response(body, statusCode));
}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });
  group('post', () {
    test('Should call post with correct Values', () async {
      await sut.request(url: url, method: 'post');

      verify(() => client.post(Uri.parse(url), headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          }));
    });
  });
}
