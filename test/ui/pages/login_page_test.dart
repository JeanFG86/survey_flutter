import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey_flutter/ui/helpers/errors/ui_error.dart';
import 'package:survey_flutter/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  final StreamController<UIError?> emailErrorController = StreamController<UIError?>();
  final StreamController<UIError?> passwordErrorController = StreamController<UIError?>();
  final StreamController<bool> isFormValidController = StreamController<bool>();
  final StreamController<bool> isLoadindController = StreamController<bool>();
  final StreamController<String?> mainErrorController = StreamController<String?>();

  LoginPresenterSpy() {
    when(() => auth()).thenAnswer((_) async => _);
    when(() => emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(() => mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(() => isFormValidStream).thenAnswer((_) => isFormValidController.stream);
    when(() => isLoadingStream).thenAnswer((_) => isLoadindController.stream);
  }

  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);
  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);
  void emitFormError() => isFormValidController.add(false);
  void emitLoading([bool show = true]) => isLoadindController.add(show);
  void emitFormValid() => isFormValidController.add(true);
  void emitMainError(String? error) => mainErrorController.add(error);

  @override
  void dispose() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    isFormValidController.close();
    isLoadindController.close();
  }
}

void main() {
  late LoginPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();

    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    presenter.dispose();
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

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.unexpected);
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if email is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailValid();
    await tester.pump();

    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)), findsOneWidget);
  });

  testWidgets('Should present error if password is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.unexpected);
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if password is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordValid();
    await tester.pump();

    expect(find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)), findsOneWidget);
  });

  testWidgets('Should enable button if form is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormError();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call authentication on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.auth()).called(1);
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

  testWidgets('Should present error message if authentication fails', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError('Credenciais inválidas.');
    await tester.pump();

    expect(find.text('Credenciais inválidas.'), findsOneWidget);
  });
}
