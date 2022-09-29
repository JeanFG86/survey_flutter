import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers/errors/errors.dart';
import '../../../helpers/i18n/resources.dart';
import '../signup.dart';

// ignore: use_key_in_widget_constructors
class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.passwordConfirmationErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.string.confirmPassword,
            icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
          ),
          obscureText: true,
          onChanged: presenter.validatePasswordConfirmation,
        );
      },
    );
  }
}
