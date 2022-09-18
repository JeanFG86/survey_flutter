import 'package:flutter/material.dart';

import '../../../../ui/pages/splash/splash.dart';
import '../page.dart';

Widget makeSplashPage() {
  return SplashPage(presenter: makeGetxSplashPresenter());
}
