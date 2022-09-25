import 'package:flutter/material.dart';
import '../../../helpers/i18n/resources.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: Text(R.string.addAccount.toUpperCase()),
    );
  }
}
