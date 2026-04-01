import 'package:flutter/material.dart';

class MarketBanner extends StatelessWidget {
  final String type;

  MarketBanner({required this.type});

  String getImage() {
    if (type == "Bullish") return "assets/images/bull_banner.png";
    if (type == "Bearish") return "assets/images/bear_banner.png";
    return "assets/images/sideways.png";
  }

  Color getColor() {
    if (type == "Bullish") return Colors.green.shade800;
    if (type == "Bearish") return Colors.red.shade800;
    return Colors.orange.shade800;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 120, // 👈 SMALL SIZE (important)
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: getColor(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // 🔥 BACKGROUND IMAGE
            Positioned.fill(
              child: Image.asset(
                getImage(),
                fit: BoxFit.cover,
              ),
            ),

            // 🔴 DARK OVERLAY (for text readability)
            Container(
              color: Colors.black.withOpacity(0.4),
            ),

            // 📝 TEXT
            Center(
              child: Text(
                "$type Market",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}