import 'package:flutter/material.dart';

abstract class SurveyResultPresenter implements Listenable {
  Stream<bool> get isLoadingStream;

  Future<void> loadData();
}
