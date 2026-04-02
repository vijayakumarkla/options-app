import 'package:flutter/material.dart';

class TradeSetup extends StatelessWidget {
  final String type;
  final double nifty;
  final Map<String, dynamic> trade;

  const TradeSetup({
    Key? key,
    required this.type,
    required this.nifty,
    required this.trade,
  }) : super(key: key);

  Map<String, double> getPnL() {
    // 🔥 Dummy premium assumptions (can upgrade later)
    double premium = 50; // average option premium

    switch (type) {
      case "Bull Call Spread":
        return {
          "maxProfit": 100 - premium,
          "maxLoss": premium,
        };

      case "Bear Call Spread":
        return {
          "maxProfit": premium,
          "maxLoss": 100 - premium,
        };

      case "Bull Put Spread":
        return {
          "maxProfit": premium,
          "maxLoss": 100 - premium,
        };

      case "Bear Put Spread":
        return {
          "maxProfit": 100 - premium,
          "maxLoss": premium,
        };

      case "Iron Condor":
        return {
          "maxProfit": premium,
          "maxLoss": 200 - premium,
        };

      default:
        return {"maxProfit": 0, "maxLoss": 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    final pnl = getPnL();

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Trade Setup",
                style: TextStyle(fontWeight: FontWeight.bold)),

            SizedBox(height: 6),

            Text("Strategy: $type"),

            SizedBox(height: 6),

            // 🔹 Strikes
            if (trade.containsKey("buy"))
              Text("Buy: ${trade['buy']}"),

            if (trade.containsKey("sell"))
              Text("Sell: ${trade['sell']}"),

            if (trade.containsKey("sellCE"))
              Text("Sell CE: ${trade['sellCE']}"),

            if (trade.containsKey("buyCE"))
              Text("Buy CE: ${trade['buyCE']}"),

            if (trade.containsKey("sellPE"))
              Text("Sell PE: ${trade['sellPE']}"),

            if (trade.containsKey("buyPE"))
              Text("Buy PE: ${trade['buyPE']}"),

            Divider(height: 16),

            // 🔥 P&L Section
            Text("P&L",
                style: TextStyle(fontWeight: FontWeight.bold)),

            SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Max Profit:",
                    style: TextStyle(color: Colors.green)),
                Text("₹${pnl['maxProfit']!.toStringAsFixed(0)}",
                    style: TextStyle(color: Colors.green)),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Max Loss:",
                    style: TextStyle(color: Colors.red)),
                Text("₹${pnl['maxLoss']!.toStringAsFixed(0)}",
                    style: TextStyle(color: Colors.red)),
              ],
            ),

            SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Risk/Reward:"),
                Text(
                  (pnl['maxLoss']! == 0)
                      ? "-"
                      : (pnl['maxProfit']! / pnl['maxLoss']!)
                          .toStringAsFixed(2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}