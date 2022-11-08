import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LocalStorageSpy extends Mock implements LocalStorage {
  LocalStorageSpy() {
    mockDelete();
    mockSave();
  }

  When mockDeleteCall() => when(() => deleteItem(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => when(() => mockDeleteCall().thenThrow(Exception()));

  When mockSaveCall() => when(() => setItem(any(), any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => when(() => mockSaveCall().thenThrow(Exception()));

  When mockFetchCall() => when(() => getItem(any()));
  void mockFetch(dynamic data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => when(() => mockFetchCall().thenThrow(Exception()));
}

class LocalStorageAdapter {
  final LocalStorage localStorage;

  LocalStorageAdapter({required this.localStorage});

  Future<void> save({required String key, required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
}

void main() {
  late LocalStorageAdapter sut;
  late LocalStorageSpy localStorage;
  late String key;
  late dynamic value;
  late String result;

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    result = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    localStorage.mockFetch(result);
    sut = LocalStorageAdapter(localStorage: localStorage);
  });
  test('Should call localStorage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(() => localStorage.setItem(key, value)).called(1);
  });
}
