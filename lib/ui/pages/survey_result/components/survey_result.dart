import 'package:flutter/material.dart';
import 'package:survey_flutter/ui/pages/pages.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        if (index == 0) {
          return Container(
              padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
              decoration: BoxDecoration(color: Theme.of(context).disabledColor.withAlpha(90)),
              child: Text(viewModel.question));
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  viewModel.answers[index - 1].image != null
                      ? Image.network(
                          viewModel.answers[index - 1].image!,
                          width: 40,
                        )
                      : SizedBox(height: 0),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        viewModel.answers[index - 1].answer,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Text(
                    viewModel.answers[index - 1].percent,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 3, 8, 71)),
                  ),
                  viewModel.answers[index - 1].isCurrentAnswer ? ActiveIcon() : DisabledIcon()
                ],
              ),
            ),
            const Divider(
              height: 1,
            )
          ],
        );
      }),
      itemCount: viewModel.answers.length + 1,
    );
  }
}

class ActiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Icon(
        Icons.check_circle,
        color: Theme.of(context).highlightColor,
      ),
    );
  }
}

class DisabledIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Icon(
        Icons.check_circle,
        color: Theme.of(context).disabledColor,
      ),
    );
  }
}

//items: snapshot.data?.map((viewModel) => SurveyItem(viewModel)).toList(),
