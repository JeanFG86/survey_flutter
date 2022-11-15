import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../surveys.dart';
import 'survey_item.dart';

class SurveyItens extends StatelessWidget {
  final List<SurveyViewModel>? viewModels;

  const SurveyItens(this.viewModels);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        options: CarouselOptions(aspectRatio: 1, enlargeCenterPage: true),
        items: viewModels?.map((viewModel) => SurveyItem(viewModel)).toList(),
      ),
    );
  }
}
