import 'package:flutter/material.dart';

class ExitScenario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Exit Scenario (Nifty 22100)"),
            Text("Buy 21900 PE → ₹160"),
            Text("Sell 21700 PE → ₹100"),
            Text("Exit Cost: ₹60"),
            Text("LOSS = ₹1800", style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
