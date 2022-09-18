import '../../../../presentation/presenter/presenter.dart';
import '../../../../ui/pages/splash/splash.dart';
import '../../factories.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(loadCurrentAccount: makeLocalLoadCurrentAccount());
}
