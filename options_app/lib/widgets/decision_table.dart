import 'package:flutter/material.dart';

class DecisionTable extends StatelessWidget {
  final double nifty;
  final String strategy;

  const DecisionTable({
    Key? key,
    required this.nifty,
    required this.strategy,
  }) : super(key: key);

  Map<String, dynamic> getLevels() {
    double atm = (nifty / 50).round() * 50;

    return {
      "upper": atm + 100,
      "lower": atm - 100,
      "atm": atm,
    };
  }

  @override
  Widget build(BuildContext context) {
    final levels = getLevels();

    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            color: Colors.blue,
            child: Text(
              "Decision Table",
              style: TextStyle(color: Colors.white),
            ),
          ),

          // 🔥 Dynamic Rows
          row(
            "Above ${levels['upper']}",
            _getAction("above"),
            Colors.green,
          ),

          row(
            "${levels['lower']} - ${levels['upper']}",
            _getAction("range"),
            Colors.orange,
          ),

          row(
            "Below ${levels['lower']}",
            _getAction("below"),
            Colors.red,
          ),
        ],
      ),
    );
  }

  String _getAction(String zone) {
    switch (strategy) {
      case "Bull Call Spread":
      case "Bull Put Spread":
        if (zone == "above") return "PROFIT / HOLD";
        if (zone == "range") return "HOLD";
        return "EXIT";

      case "Bear Call Spread":
      case "Bear Put Spread":
        if (zone == "below") return "PROFIT / HOLD";
        if (zone == "range") return "HOLD";
        return "EXIT";

      case "Iron Condor":
        if (zone == "range") return "MAX PROFIT";
        return "ADJUST / EXIT";

      default:
        return "WAIT";
    }
  }

  Widget row(String range, String action, Color color) {
    return ListTile(
      title: Text(range),
      trailing: Text(
        action,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}