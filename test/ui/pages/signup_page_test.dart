import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:survey_flutter/ui/pages/signup/signup.dart';

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [GetPage(name: '/signup', page: () => SignUpPage())],
    );
    await tester.pumpWidget(signUpPage);
  }

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    //verify(() => presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    //verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    //verify(() => presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);
    //verify(() => presenter.validatePasswordConfirmation(password));
  });
}
