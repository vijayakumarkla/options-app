import 'package:flutter/material.dart';

class ExitScenario extends StatelessWidget {
  final double nifty;
  final String strategy;
  final Map<String, dynamic> trade;

  const ExitScenario({
    Key? key,
    required this.nifty,
    required this.strategy,
    required this.trade,
  }) : super(key: key);

  static const int lotSize = 50; // Nifty lot size

  String _val(dynamic v) {
    if (v == null) return "-";
    return (v as num).toInt().toString();
  }

  Map<String, dynamic> calculateExit() {
    // 🔥 Dummy premium logic (can replace with real API later)
    double buyPremium = 150;
    double sellPremium = 100;

    double exitCost = (buyPremium - sellPremium).abs();
    double pnl = exitCost * lotSize;

    return {
      "buyPremium": buyPremium,
      "sellPremium": sellPremium,
      "exitCost": exitCost,
      "pnl": pnl,
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = calculateExit();

    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Exit Scenario (Nifty ${nifty.toInt()})",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            // 🔹 Strategy-based display
            if (strategy.contains("Put"))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Buy ${_val(trade['buy'])} PE → ₹${data['buyPremium']}"),
                  Text(
                      "Sell ${_val(trade['sell'])} PE → ₹${data['sellPremium']}"),
                ],
              ),

            if (strategy.contains("Call"))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Buy ${_val(trade['buy'])} CE → ₹${data['buyPremium']}"),
                  Text(
                      "Sell ${_val(trade['sell'])} CE → ₹${data['sellPremium']}"),
                ],
              ),

            if (strategy == "Iron Condor")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Sell CE ${_val(trade['sellCE'])} → ₹100"),
                  Text(
                      "Buy CE ${_val(trade['buyCE'])} → ₹150"),
                  Text(
                      "Sell PE ${_val(trade['sellPE'])} → ₹100"),
                  Text(
                      "Buy PE ${_val(trade['buyPE'])} → ₹150"),
                ],
              ),

            SizedBox(height: 10),

            Text("Exit Cost: ₹${data['exitCost']}"),

            SizedBox(height: 6),

            Text(
              "P&L = ₹${data['pnl'].toInt()}",
              style: TextStyle(
                color:
                    data['pnl'] > 0 ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}