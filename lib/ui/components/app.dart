import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 50, 57, 154);
    const primaryColorDark = Color.fromARGB(255, 3, 8, 71);
    const primaryColorLight = Color.fromARGB(255, 97, 161, 218);
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
            const TextTheme(headline1: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColorDark)),
        inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColorLight)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
            alignLabelWithHint: true),
      ),
      //home: LoginPage(null),
    );
  }
}
