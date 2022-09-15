import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/entities/entities.dart';
import 'package:survey_flutter/domain/usecases/load_current_account.dart';
import 'package:survey_flutter/presentation/presenter/presenter.dart';
import 'package:test/test.dart';

import 'getx_login_presenter_test.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  When mockLoadCall() => when(() => load());
  void mockLoad({required AccountEntity account}) => mockLoadCall().thenAnswer((_) async => account);
  void mockLoadError() => mockLoadCall().thenThrow(Exception());
}

void main() {
  late LoadCurrentAccountSpy loadCurrentAccount;
  late GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    loadCurrentAccount.mockLoad(account: EntityFactory.makeAccount());
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount();
  });

  test('Should go to login page on error', () async {
    loadCurrentAccount.mockLoadError();

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccount();
  });
}
