import 'package:flutter/material.dart';

class StrategyCard extends StatelessWidget {
  final String type;

  StrategyCard({required this.type});

  @override
  Widget build(BuildContext context) {
    String strategy = type == "Bullish"
        ? "Sell Put Spread"
        : type == "Bearish"
            ? "Bear Call Spread"
            : "Strangle";

    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(strategy, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
