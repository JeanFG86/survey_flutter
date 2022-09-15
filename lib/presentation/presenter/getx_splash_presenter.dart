import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/splash/splash.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = Rx<String?>(null);

  GetxSplashPresenter({required this.loadCurrentAccount});

  @override
  Future<void> checkAccount() async {
    try {
      await loadCurrentAccount.load();
      _navigateTo.value = '/surveys';
    } catch (error) {
      _navigateTo.value = '/login';
    }
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;
}
