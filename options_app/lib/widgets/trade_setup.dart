import 'package:flutter/material.dart';

class TradeSetup extends StatelessWidget {
  final String type;
  final double nifty;

  TradeSetup({required this.type, required this.nifty});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(3, 8, 3, 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trade Setup",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            if (type == "Bullish") ...[
              _buildOptionBox("Sell PE", "${nifty - 200}", Colors.red),
              SizedBox(height: 8),
              _buildOptionBox("Buy PE", "${nifty - 400}", Colors.green),
            ] else if (type == "Bearish") ...[
              _buildOptionBox("Sell CE", "${nifty + 200}", Colors.red),
              SizedBox(height: 8),
              _buildOptionBox("Buy CE", "${nifty + 400}", Colors.green),
            ] else ...[
              _buildOptionBox("Sell PE & CE", "", Colors.red),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptionBox(String action, String price, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${action.startsWith("Buy") ? "▲" : "▼"} $action",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          if (price.isNotEmpty) ...[
            SizedBox(width: 8),
            Text(
              price,
              style: TextStyle(
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
