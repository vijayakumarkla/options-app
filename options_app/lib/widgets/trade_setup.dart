import 'package:flutter/material.dart';

class TradeSetup extends StatelessWidget {
  final String type;
  final double nifty;

  TradeSetup({required this.type, required this.nifty});

  @override
  Widget build(BuildContext context) {
    String text;

    if (type == "Bullish") {
      text = "Sell PE: ${nifty - 200}\nBuy PE: ${nifty - 400}";
    } else if (type == "Bearish") {
      text = "Sell CE: ${nifty + 200}\nBuy CE: ${nifty + 400}";
    } else {
      text = "Sell PE & CE";
    }

    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(text),
      ),
    );
  }
}
