import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class SurveyItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            boxShadow: const [BoxShadow(offset: Offset(0, 1), spreadRadius: 0, blurRadius: 2, color: Colors.black)],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Text(
              "20 ago 2021",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Qual seu framework web favorito?", style: TextStyle(color: Colors.white, fontSize: 24))
          ],
        ),
      ),
    );
  }
}
