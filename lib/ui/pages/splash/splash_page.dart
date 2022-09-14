import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_presenter.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  // ignore: use_key_in_widget_constructors
  const SplashPage({required this.presenter});
  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();
    return Scaffold(
      appBar: AppBar(title: const Text('Survey')),
      body: Builder(builder: (context) {
        presenter.navigateToStream.listen((page) {
          if (page != null && page.isNotEmpty) {
            Get.offAllNamed(page);
          }
        });
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
