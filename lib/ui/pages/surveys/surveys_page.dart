import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_flutter/ui/helpers/i18n/i18n.dart';
import 'package:survey_flutter/ui/pages/surveys/surveys.dart';

import '../../components/components.dart';
import 'components/components.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  const SurveysPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
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
        return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error.toString(),
                  reload: presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return ListenableProvider(create: (_) => presenter, child: SurveyItens(snapshot.data));
              }
              return const SizedBox(height: 0);
            });
      }),
    );
  }
}
