import '../../../../presentation/presenter/presenter.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SurveysPresenter makeGetxSurveysPresenter() {
  return GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveysWithLocalFallback());
}
