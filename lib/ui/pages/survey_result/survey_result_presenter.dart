import 'package:flutter/material.dart';

abstract class SurveyResultPresenter implements Listenable {
  Future<void> loadData();
}
