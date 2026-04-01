import 'package:flutter/material.dart';

class Rules extends StatelessWidget {
  final String type;

  Rules({required this.type});

  @override
  Widget build(BuildContext context) {
    List<String> rules;

    if (type == "Bearish") {
      rules = ["Sell CE above market", "Spread 200 points"];
    } else if (type == "Bullish") {
      rules = ["Sell PE below market", "Spread 200 points"];
    } else {
      rules = ["Sell both PE & CE", "Exit on breakout"];
    }

    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: rules.map((e) => Text("✔ $e")).toList(),
        ),
      ),
    );
  }
}
