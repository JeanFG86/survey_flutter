import '../../../../presentation/presenter/presenter.dart';
import '../../factories.dart';

StreamLoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(validation: makeLoginValidation(), authentication: makeRemoteAuthentication());
}
