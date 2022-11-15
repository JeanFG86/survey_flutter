import 'package:flutter/material.dart';

abstract class SurveyResultPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<dynamic>? get surveyResultStream;

  Future<void> loadData();
}
