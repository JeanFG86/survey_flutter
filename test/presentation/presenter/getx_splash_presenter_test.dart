import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/domain/usecases/load_current_account.dart';
import 'package:survey_flutter/ui/pages/splash/splash.dart';
import 'package:test/test.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = Rx<String?>(null);

  GetxSplashPresenter({required this.loadCurrentAccount});

  @override
  Future<void> checkAccount() async {
    await loadCurrentAccount.load();
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  test('Should call LoadCurrentAccount', () async {
    final loadCurrentAccount = LoadCurrentAccountSpy();
    final sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);

    await sut.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });
}
