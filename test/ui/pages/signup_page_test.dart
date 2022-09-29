import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import 'package:survey_flutter/ui/pages/signup/signup.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {
  final nameErrorController = StreamController<UIError?>();
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final passwordConfirmationErrorController = StreamController<UIError?>();

  SignUpPresenterSpy() {
    when(() => nameErrorStream).thenAnswer((_) => nameErrorController.stream);
    when(() => emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(() => passwordConfirmationErrorStream).thenAnswer((_) => passwordConfirmationErrorController.stream);
  }

  void emitNameError(UIError error) => nameErrorController.add(error);
  void emitNameValid() => nameErrorController.add(null);
  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);
  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);
  void emitPasswordConfirmationError(UIError error) => passwordConfirmationErrorController.add(error);
  void emitPasswordConfirmationValid() => passwordConfirmationErrorController.add(null);

  @override
  void dispose() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
  }
}

void main() {
  late SignUpPresenterSpy presenter;
  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [GetPage(name: '/signup', page: () => SignUpPage(presenter))],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);
    verify(() => presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Should present email error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    presenter.emitEmailValid();
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)), findsOneWidget);
  });

  testWidgets('Should present name error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNameError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    presenter.emitNameError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    presenter.emitNameValid();
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)), findsOneWidget);
  });

  testWidgets('Should present password error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    presenter.emitPasswordError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    presenter.emitPasswordValid();
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)), findsOneWidget);
  });

  testWidgets('Should present passwordConfirmation error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordConfirmationError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    presenter.emitPasswordConfirmationError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    presenter.emitPasswordConfirmationValid();
    await tester.pump();
    expect(find.descendant(of: find.bySemanticsLabel('Confirmar senha'), matching: find.byType(Text)), findsOneWidget);
  });
}
