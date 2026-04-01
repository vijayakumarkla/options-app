import 'package:flutter/material.dart';

class IncomePlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("💰 Income Plan"),
            Text("Weekly: ₹2000-3000"),
            Text("Monthly: ₹12K-20K"),
          ],
        ),
      ),
    );
  }
}
