import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/cache/cache.dart';
import 'package:survey_flutter/data/usecases/load_current_account/load_current_account.dart';
import 'package:survey_flutter/domain/entities/account_entity.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:test/test.dart';

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

  test('Should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token: token));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage throws', () async {
    secureCacheStorage.mockFetchError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
