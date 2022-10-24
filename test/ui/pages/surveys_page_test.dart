import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import 'package:survey_flutter/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {
  final surveysController = StreamController<List<SurveyViewModel>>();
  final isLoadingController = StreamController<bool>();

  SurveysPresenterSpy() {
    when(() => loadData()).thenAnswer((_) async => _);
    when(() => surveysStream).thenAnswer((_) => surveysController.stream);
    when(() => isLoadingStream).thenAnswer((_) => isLoadingController.stream);
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
  late SurveysPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [GetPage(name: '/surveys', page: () => SurveysPage(presenter))],
    );
    await tester.pumpWidget(surveysPage);
  }

  tearDown(() {
    presenter.dispose();
  });
  testWidgets('Should call LoadSurveys on page load', (WidgetTester tester) async {
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
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should present list if surveysStream succeeds', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveys(makeSurveyList());
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });
}
