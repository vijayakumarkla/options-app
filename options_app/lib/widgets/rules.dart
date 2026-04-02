import 'package:flutter/material.dart';

class Rules extends StatelessWidget {
  final String strategy;
  final double nifty;
  final Map<String, dynamic> trade;

  const Rules({
    Key? key,
    required this.strategy,
    required this.nifty,
    required this.trade,
  }) : super(key: key);

  List<String> getRules() {
    double atm = (nifty / 50).round() * 50;

    switch (strategy) {
      case "Bull Call Spread":
        return [
          "Market View: Bullish",
          "Buy CE at ATM (${atm.toInt()})",
          "Sell CE at ${_val(trade['sell'])}",
          "Spread: ${_spread()} points",
          "Use when VIX is low",
        ];

      case "Bear Put Spread":
        return [
          "Market View: Bearish",
          "Buy PE at ATM (${atm.toInt()})",
          "Sell PE at ${_val(trade['sell'])}",
          "Spread: ${_spread()} points",
          "Use when VIX is low",
        ];

      case "Bull Put Spread":
        return [
          "Market View: Moderately Bullish",
          "Sell PE at ${_val(trade['sell'])}",
          "Buy PE at ${_val(trade['buy'])}",
          "Spread: ${_spread()} points",
          "Time decay strategy",
        ];

      case "Bear Call Spread":
        return [
          "Market View: Moderately Bearish",
          "Sell CE at ${_val(trade['sell'])}",
          "Buy CE at ${_val(trade['buy'])}",
          "Spread: ${_spread()} points",
          "Time decay strategy",
        ];

      case "Iron Condor":
        return [
          "Market View: Sideways",
          "Sell CE: ${_val(trade['sellCE'])}",
          "Buy CE: ${_val(trade['buyCE'])}",
          "Sell PE: ${_val(trade['sellPE'])}",
          "Buy PE: ${_val(trade['buyPE'])}",
          "Range-bound profit strategy",
        ];

      default:
        return ["No rules available"];
    }
  }

  // 🔥 Safe value formatter (removes .0 issue)
  String _val(dynamic value) {
    if (value == null) return "-";
    return (value as num).toInt().toString();
  }

  // 🔥 FIXED spread calculation (no type error)
  int _spread() {
    if (trade.containsKey("buy") && trade.containsKey("sell")) {
      double buy = (trade['buy'] as num).toDouble();
      double sell = (trade['sell'] as num).toDouble();
      return (sell - buy).abs().toInt();
    }

    if (trade.containsKey("buyCE") && trade.containsKey("sellCE")) {
      double buyCE = (trade['buyCE'] as num).toDouble();
      double sellCE = (trade['sellCE'] as num).toDouble();
      return (buyCE - sellCE).abs().toInt();
    }

    if (trade.containsKey("buyPE") && trade.containsKey("sellPE")) {
      double buyPE = (trade['buyPE'] as num).toDouble();
      double sellPE = (trade['sellPE'] as num).toDouble();
      return (buyPE - sellPE).abs().toInt();
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final rules = getRules();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Strike Selection Rules",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            ...rules.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("✔ $e"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}