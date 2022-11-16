import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;
  final _surveys = Rx<List<SurveyViewModel>>([]);
  final _isLoading = false.obs;

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) => _isLoading.value = value;

  GetxSurveysPresenter({required this.loadSurveys});

/*
  @override
  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map((survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer))
          .toList();
    } on DomainError {
      //_surveys.value = [
      //  new SurveyViewModel(
      //     id: "2", question: "3213", date: DateFormat('dd MMM yyyy').format(DateTime.now()), didAnswer: false)
      // ] as List<SurveyViewModel>;

      _surveys.subject.addError(UIError.unexpected.description);
      // _surveys.addError(UIError.unexpected.description);

      //  _surveys.subject.add([
      //    new SurveyViewModel(
      //       id: "2", question: "3213", date: DateFormat('dd MMM yyyy').format(DateTime.now()), didAnswer: false)
      // ] as List<SurveyViewModel>
      //UIError.unexpected.description,
      //     );
    } finally {
      isLoading = false;
    }

*/
  @override
  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map((survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer))
          .toList();
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        //isSessionExpired = true;
      } else {
        _surveys.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToSurveyResult(String surveyId) {}
}
