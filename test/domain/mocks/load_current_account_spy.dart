import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/usecases/usecases.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  When mockLoadCall() => when(() => load());
  void mockLoad({required AccountEntity account}) => mockLoadCall().thenAnswer((_) async => account);
  void mockLoadError() => mockLoadCall().thenThrow(Exception());
}
