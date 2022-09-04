import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey_flutter/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  /*
  final emailErrorController = StreamController<String>();

  LoginPresenterSpy() {
    when(() => this.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
  }

  void dispose() {
    emailErrorController.close();
  }
  */
}

void main() {
  late LoginPresenterSpy presenter;
  late StreamController<String> emailErrorController;

//continua 8min
  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();

    when(() => presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    //when(() => this.emailErrorStream).thenAnswer((_) => emailErrorController.stream);

    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
  });

  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onLongPress, null);
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

    emailErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });
}
