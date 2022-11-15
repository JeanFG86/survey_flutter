import 'package:flutter/material.dart';
import 'package:survey_flutter/ui/helpers/i18n/i18n.dart';

import '../../components/components.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(R.string.surveys)),
        body: Builder(builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          presenter.loadData();
          return StreamBuilder<SurveyResultViewModel?>(
              stream: presenter.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(error: '${snapshot.error}', reload: presenter.loadData);
                }
                if (snapshot.hasData) {
                  return SurveyResult(viewModel: snapshot.data!);
                }
                return const SizedBox(height: 0);
              });
        }));
  }
}
