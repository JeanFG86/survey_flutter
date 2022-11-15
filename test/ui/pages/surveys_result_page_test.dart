import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:survey_flutter/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {
  final surveysController = StreamController<List<SurveyViewModel>>();
  final isLoadingController = StreamController<bool>();

  SurveyResultPresenterSpy() {
    when(() => loadData()).thenAnswer((_) async => _);
    //when(() => surveysStream).thenAnswer((_) => surveysController.stream);
    //when(() => isLoadingStream).thenAnswer((_) => isLoadingController.stream);
  }

  void emitSurveys(List<SurveyViewModel> data) => surveysController.add(data);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitSurveysError(String error) => surveysController.addError(error);

  void dispose() {
    isLoadingController.close();
    surveysController.close();
  }
}

List<SurveyViewModel> makeSurveyList() => [
      const SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
      const SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
    ];

void main() {
  late SurveyResultPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [GetPage(name: '/survey_result/:survey_id', page: () => SurveyResultPage(presenter))],
    );
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  tearDown(() {
    presenter.dispose();
  });
  testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });
}
