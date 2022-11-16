import 'package:flutter/material.dart';

import 'survey_viewmodel.dart';

abstract class SurveysPresenter implements Listenable {
  Future<void> loadData();
  void goToSurveyResult(String surveyId);

  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;
}
