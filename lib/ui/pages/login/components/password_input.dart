import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers/errors/ui_error.dart';
import '../../pages.dart';

// ignore: use_key_in_widget_constructors
class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Senha',
              icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
              errorText: snapshot.data?.description,
            ),
            obscureText: true,
            onChanged: presenter.validatePassword,
          );
        });
  }
}
