import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../helpers/errors/errors.dart';
import '../../../utils/i18n/i18n.dart';
import 'components/components.dart';
import 'login_presenter.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  // ignore: use_key_in_widget_constructors
  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          presenter.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context, error.description);
            }
          });

          presenter.navigateToStream.listen((page) {
            if (page != null && page.isNotEmpty) {
              //if (clear == true) {
              //  Get.offAllNamed(page);
              /// } else {
              Get.offAllNamed(page);
              // }
            }
          });

          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const LoginHeader(),
                HeadLine1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: ListenableProvider(
                    create: (_) => presenter,
                    child: Form(
                        child: Column(
                      children: [
                        EmailInput(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 32),
                          child: PasswordInput(),
                        ),
                        LoginButton(),
                        TextButton.icon(
                            onPressed: () {}, icon: const Icon(Icons.person), label: Text(R.string.addAccount))
                      ],
                    )),
                  ),
                )
              ]),
            ),
          );
        },
      ),
    );
  }
}
