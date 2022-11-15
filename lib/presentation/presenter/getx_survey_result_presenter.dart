import 'package:get/get.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter extends GetxController implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final _surveyResult = Rx<SurveyResultViewModel?>(null);
  final _isLoading = false.obs;
  final String surveyId;

  @override
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) => _isLoading.value = value;

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.surveyId,
  });

  @override
  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.value = SurveyResultViewModel(
          surveyId: surveyResult.surveyId,
          question: surveyResult.question,
          answers: surveyResult.answers
              .map((answer) => SurveyAnswerViewModel(
                  image: answer.image,
                  answer: answer.answer,
                  isCurrentAnswer: answer.isCurrentAnswer,
                  percent: '${answer.percent}%'))
              .toList());
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        //isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }
}
