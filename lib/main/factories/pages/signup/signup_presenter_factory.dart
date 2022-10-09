import '../../../../presentation/presenter/presenter.dart';
import '../../../../ui/pages/signup/signup.dart';
import '../../factories.dart';

SignUpPresenter makeGetxSignUpPresenter() {
  return GetxSignUpPresenter(
      validation: makeSignUpValidation(),
      addAccount: makeRemoteAddAccount(),
      saveCurrentAccount: makeLocalSaveCurrentAccount());
}
