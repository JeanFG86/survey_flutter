import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import 'package:survey_flutter/ui/pages/pages.dart';
import 'package:survey_flutter/ui/pages/survey_result/components/components.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {
  final surveyResultController = StreamController<SurveyResultViewModel>();
  final isLoadingController = StreamController<bool>();

  SurveyResultPresenterSpy() {
    when(() => loadData()).thenAnswer((_) async => _);
    when(() => surveyResultStream).thenAnswer((_) => surveyResultController.stream);
    when(() => isLoadingStream).thenAnswer((_) => isLoadingController.stream);
  }

  void emitSurveyResult(SurveyResultViewModel data) => surveyResultController.add(data);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitSurveysError(String error) => surveyResultController.addError(error);

  void dispose() {
    isLoadingController.close();
    surveyResultController.close();
  }
}

SurveyResultViewModel makeSurveyResult() =>
    const SurveyResultViewModel(surveyId: 'Any id', question: 'Question', answers: [
      SurveyAnswerViewModel(image: 'Image 0', answer: 'Answer 0', isCurrentAnswer: true, percent: '60%'),
      SurveyAnswerViewModel(answer: 'Answer 1', isCurrentAnswer: false, percent: '40%')
    ]);

void main() {
  late SurveyResultPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [GetPage(name: '/survey_result/:survey_id', page: () => SurveyResultPage(presenter))],
    );
    await mockNetworkImagesFor(() async {
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

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    presenter.emitLoading(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should present error if surveysStream fails', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question'), findsNothing);
  });

  testWidgets('Should call LoadSurveys on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('Should present valid data if surveyResultStream succeeds', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResult(makeSurveyResult());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisabledIcon), findsOneWidget);
    final image = tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
  });
}
