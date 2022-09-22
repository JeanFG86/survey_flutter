import 'package:flutter/material.dart';

import '../helpers/i18n/resources.dart';

void showLoading(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text(R.string.wait, textAlign: TextAlign.center)
                ],
              )
            ],
          ));
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
