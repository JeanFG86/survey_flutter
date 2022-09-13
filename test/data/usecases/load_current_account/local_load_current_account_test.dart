import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {
  FetchSecureCacheStorageSpy();

  When mockFetchCall() => when(() => fetchSecure(any()));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());
}

void main() {
  late LocalLoadCurrentAccount sut;
  late FetchSecureCacheStorageSpy secureCacheStorage;
  late String token;

  setUp(() {
    token = faker.guid.guid();
    secureCacheStorage = FetchSecureCacheStorageSpy();
    secureCacheStorage.mockFetch(token);
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: secureCacheStorage);
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(() => secureCacheStorage.fetchSecure('token'));
  });
}
