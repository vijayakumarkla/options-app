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
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rules to Select Strikes price",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            ...rules.map((e) => Text("✔ $e")).toList(),
          ],
        ),
      ),
    );
  }
}
