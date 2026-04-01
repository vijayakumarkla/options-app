import 'package:flutter/material.dart';

class StopLoss extends StatelessWidget {
  final String type;

  StopLoss({required this.type});

  @override
  Widget build(BuildContext context) {
    String text = "Exit on breakout";

    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(text),
      ),
    );
  }
}
