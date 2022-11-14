import 'package:flutter/material.dart';
import 'package:survey_flutter/ui/helpers/i18n/i18n.dart';

class SurveyResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(R.string.surveys)), body: const Text('OK'));
  }
}

//items: snapshot.data?.map((viewModel) => SurveyItem(viewModel)).toList(),
