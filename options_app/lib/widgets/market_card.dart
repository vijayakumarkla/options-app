import 'package:flutter/material.dart';

class MarketCard extends StatelessWidget {
  final double nifty;
  final double vix;
  final String trend;

  MarketCard({required this.nifty, required this.vix, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📊 Market", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Nifty: $nifty"),
            Text("VIX: $vix"),
            Text("Trend: $trend"),
          ],
        ),
      ),
    );
  }
}
