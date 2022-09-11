import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/data/cache/cache.dart';
import 'package:survey_flutter/data/usecases/usecases.dart';
import 'package:survey_flutter/domain/helpers/helpers.dart';
import 'package:test/test.dart';
import 'package:survey_flutter/domain/entities/entities.dart';

class SecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
  SecureCacheStorageSpy() {
    mockSave();
  }

  When mockSaveCall() => when(() => saveSecure(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}

void main() {
  late LocalSaveCurrentAccount sut;
  late SecureCacheStorageSpy saveSecureCacheStorage;
  late AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SecureCacheStorageSpy();
    account = AccountEntity(faker.guid.guid());
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
  });

  test('Should call SaveCacheStorage with correct values', () async {
    await sut.save(account);

    verify(() => saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws', () async {
    saveSecureCacheStorage.mockSaveError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
