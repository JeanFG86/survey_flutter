import 'package:flutter/material.dart';
import 'package:survey_flutter/ui/pages/pages.dart';

// ignore: use_key_in_widget_constructors
class SurveyItem extends StatelessWidget {
  final SurveyViewModel viewModel;

  const SurveyItem(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: viewModel.didAnswer ? Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColorDark,
            boxShadow: const [BoxShadow(offset: Offset(0, 1), spreadRadius: 0, blurRadius: 2, color: Colors.black)],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              viewModel.date,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(viewModel.question, style: TextStyle(color: Colors.white, fontSize: 24))
          ],
        ),
      ),
    );
  }
}
