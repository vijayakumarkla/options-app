import 'package:flutter/material.dart';

class ProfitLoss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Profit / Loss"),
            Text("Final Profit: -24 points"),
            Text("Loss Amount: ₹1800"),
          ],
        ),
      ),
    );
  }
}
