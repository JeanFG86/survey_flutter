import '../../../../presentation/presenter/presenter.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) {
  return GetxSurveyResultPresenter(loadSurveyResult: makeRemoteLoadSurveyResult(surveyId), surveyId: surveyId);
}
