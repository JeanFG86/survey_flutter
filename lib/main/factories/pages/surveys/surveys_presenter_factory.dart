import '../../../../presentation/presenter/presenter.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SurveysPresenter makeGetxSurveysPresenter() {
  //makeRemoteLoadSurveys -- sem funcao offline
  //makeRemoteLoadSurveysWithLocalFallback -- com funcao offline
  return GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveys());
}
