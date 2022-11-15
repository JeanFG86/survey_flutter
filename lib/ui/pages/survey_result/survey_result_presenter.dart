import 'package:flutter/material.dart';
import 'package:survey_flutter/ui/pages/pages.dart';

abstract class SurveyResultPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<SurveyResultViewModel?> get surveyResultStream;

  Future<void> loadData();
}
