import 'package:flutter/material.dart';

class DecisionTable extends StatelessWidget {
  final String type;

  DecisionTable({required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            color: Colors.red,
            child: Text("Decision Table", style: TextStyle(color: Colors.white)),
          ),
          row("Above 22500", "BUY MORE", Colors.green),
          row("22150 - 22500", "HOLD", Colors.orange),
          row("Below 22150", "EXIT", Colors.red),
        ],
      ),
    );
  }

  Widget row(String r, String a, Color c) {
    return ListTile(
      title: Text(r),
      trailing: Text(a, style: TextStyle(color: c)),
    );
  }
}
