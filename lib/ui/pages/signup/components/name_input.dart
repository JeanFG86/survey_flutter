import 'package:flutter/material.dart';
import '../../../helpers/i18n/resources.dart';

// ignore: use_key_in_widget_constructors
class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.string.name,
        icon: Icon(Icons.person, color: Theme.of(context).primaryColorLight),
      ),
      keyboardType: TextInputType.name,
    );
  }
}
