import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color.fromARGB(255, 50, 57, 154);
    final primaryColorDark = Color.fromARGB(255, 3, 8, 71);
    final primaryColorLight = Color.fromARGB(255, 97, 161, 218);
    final ThemeData theme = ThemeData();

    return MaterialApp(
      title: 'Survey',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
          primaryColor: primaryColor,
          primaryColorDark: primaryColorDark,
          primaryColorLight: primaryColorLight,
          colorScheme: theme.colorScheme.copyWith(secondary: primaryColor),
          backgroundColor: Colors.white,
          textTheme:
              TextTheme(headline1: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColorDark))),
      home: LoginPage(),
    );
  }
}
