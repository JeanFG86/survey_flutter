import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_flutter/ui/helpers/errors/errors.dart';
import '../../helpers/i18n/i18n.dart';
import '../../components/components.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

// ignore: use_key_in_widget_constructors
class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  // ignore: use_key_in_widget_constructors
  const SignUpPage(this.presenter);

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
          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const LoginHeader(),
                HeadLine1(text: R.string.addAccount),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: ListenableProvider(
                    create: (_) => presenter,
                    child: Form(
                        child: Column(
                      children: [
                        NameInput(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: EmailInput(),
                        ),
                        PasswordInput(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 32),
                          child: PasswordConfirmationInput(),
                        ),
                        SignUpButton(),
                        TextButton.icon(
                            onPressed: () {}, icon: const Icon(Icons.exit_to_app), label: Text(R.string.login))
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
