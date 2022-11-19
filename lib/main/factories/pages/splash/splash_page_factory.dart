import 'package:flutter/material.dart';

import '../../../../ui/pages/splash/splash.dart';
import '../pages.dart';

Widget makeSplashPage() {
  return SplashPage(presenter: makeGetxSplashPresenter());
}
