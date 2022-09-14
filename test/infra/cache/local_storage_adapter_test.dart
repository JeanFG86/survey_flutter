import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/infra/cache/cache.dart';
import 'package:test/test.dart';

class FlutterSecurityStorageSpy extends Mock implements FlutterSecureStorage {
  FlutterSecurityStorageSpy() {
    mockSave();
  }

  When mockSaveCall() => when(() => write(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => when(() => mockSaveCall().thenThrow(Exception()));

  When mockFetchCall() => when(() => read(key: any(named: 'key')));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => when(() => mockFetchCall().thenThrow(Exception()));
}

void main() {
  late LocalStorageAdapter sut;
  late FlutterSecurityStorageSpy localStorage;
  late String key;
  late dynamic value;
  late String result;

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    result = faker.randomGenerator.string(50);
    localStorage = FlutterSecurityStorageSpy();
    localStorage.mockFetch(result);
    sut = LocalStorageAdapter(secureStorage: localStorage);
  });

  group('saveSecure', () {
    test('Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(() => localStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () async {
      localStorage.mockSaveError();
      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    test('Should call fetch secure with correct value', () async {
      await sut.fetchSecure(key);

      verify(() => localStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetchSecure(key);

      expect(fetchedValue, result);
    });
  });
}
