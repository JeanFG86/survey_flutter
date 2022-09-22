import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/errors/errors.dart';
import '../../../helpers/i18n/resources.dart';
import '../../pages.dart';

// ignore: use_key_in_widget_constructors
class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.string.email,
            icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
            errorText: snapshot.data?.description,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
        );
      },
    );
  }
}
