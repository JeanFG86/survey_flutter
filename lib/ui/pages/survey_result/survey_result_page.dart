import 'package:flutter/material.dart';
import 'package:survey_flutter/ui/helpers/i18n/i18n.dart';

import '../../components/components.dart';
import '../pages.dart';
import '../surveys/components/components.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter? presenter;

  const SurveyResultPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(R.string.surveys)),
        body: Builder(builder: (context) {
          presenter?.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          presenter?.loadData();
          return StreamBuilder<dynamic>(
              stream: presenter?.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(error: snapshot.error.toString(), reload: presenter!.loadData);
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: ((context, index) {
                      if (index == 0) {
                        return Container(
                            padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
                            decoration: BoxDecoration(color: Theme.of(context).disabledColor.withAlpha(90)),
                            child: const Text('Qual é seu framework web favorito?'));
                      }
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(
                                  'http://fordevs.herokuapp.com/static/img/logo-angular.png',
                                  width: 40,
                                ),
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'Angular',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const Text(
                                  '100%',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 3, 8, 71)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).highlightColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          )
                        ],
                      );
                    }),
                    itemCount: 4,
                  );
                }
                return const SizedBox(height: 0);
              });
        }));
  }
}

//items: snapshot.data?.map((viewModel) => SurveyItem(viewModel)).toList(),
