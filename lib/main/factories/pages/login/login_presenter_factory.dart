import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
      validation: makeLoginValidation(),
      authentication: makeRemoteAuthentication(),
      saveCurrentAccount: makeLocalSaveCurrentAccount());
}
