import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:survey_flutter/ui/helpers/i18n/i18n.dart';
import 'package:survey_flutter/ui/pages/surveys/surveys.dart';

import '../../components/components.dart';
import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  const SurveysPage(this.presenter);

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
                return Column(
                  children: [
                    Text('${snapshot.error}'),
                    ElevatedButton(onPressed: presenter.loadData, child: Text(R.string.reload))
                  ],
                );
              }
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CarouselSlider(
                    options: CarouselOptions(aspectRatio: 1, enlargeCenterPage: true),
                    items: snapshot.data?.map((viewModel) => SurveyItem(viewModel)).toList(),
                  ),
                );
              }
              return SizedBox(height: 0);
            });
      }),
    );
  }
}

//items: snapshot.data?.map((viewModel) => SurveyItem(viewModel)).toList(),
