import 'package:flutter/material.dart';
import '../../../helpers/i18n/resources.dart';

// ignore: use_key_in_widget_constructors
class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.string.confirmPassword,
        icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
      ),
      obscureText: true,
    );
  }
}
