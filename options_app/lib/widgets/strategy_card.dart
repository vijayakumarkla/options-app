import 'package:flutter/material.dart';
import 'dart:math';

class StrategyCard extends StatelessWidget {
  final String type;

  StrategyCard({required this.type});

  String _getStrategyName() {
    return type == "Bullish"
        ? "Sell Put Spread"
        : type == "Bearish"
            ? "Bear Call Spread"
            : "Strangle";
  }

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
              _getStrategyName(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomPaint(
                  painter: StrategyChartPainter(type: type),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StrategyChartPainter extends CustomPainter {
  final String type;

  StrategyChartPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    final textPaint = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw grid
    for (int i = 0; i <= 4; i++) {
      double x = (size.width / 4) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (int i = 0; i <= 4; i++) {
      double y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw zero profit line (mid line)
    final midLinePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    double zeroY = size.height / 2;
    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), midLinePaint);

    // Draw payoff diagram with colored segments
    final points = _getPayoffPoints(size);
    if (points.isNotEmpty) {
      for (int i = 0; i < points.length - 1; i++) {
        final start = points[i];
        final end = points[i + 1];
        // Color based on profit/loss: green for profit (above zero, lower y), red for loss
        final color = start.dy < zeroY ? Colors.green : Colors.red;
        final segmentPaint = Paint()
          ..color = color
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
        canvas.drawLine(start, end, segmentPaint);
      }
    }

    // Draw labels
    _drawLabels(canvas, size, textPaint);
  }

  List<Offset> _getPayoffPoints(Size size) {
    final midY = size.height / 2;
    
    switch (type) {
      case "Bullish": // Sell Put Spread
        return [
          Offset(0, size.height * 0.7), // Limited loss on far left
          Offset(size.width * 0.1, size.height * 0.7),
          Offset(size.width * 0.2, size.height * 0.7),
          Offset(size.width * 0.25, size.height * 0.65), // Start sloping up
          Offset(size.width * 0.3, size.height * 0.55),
          Offset(size.width * 0.35, size.height * 0.45),
          Offset(size.width * 0.4, size.height * 0.35),
          Offset(size.width * 0.45, size.height * 0.25),
          Offset(size.width * 0.5, size.height * 0.2), // Break-even
          Offset(size.width * 0.6, size.height * 0.12),
          Offset(size.width * 0.7, size.height * 0.08),
          Offset(size.width * 0.85, size.height * 0.1), // Max profit
          Offset(size.width, size.height * 0.1),
        ];
      case "Bearish": // Bear Call Spread
        return [
          Offset(0, size.height * 0.1), // Max profit on far left
          Offset(size.width * 0.15, size.height * 0.1),
          Offset(size.width * 0.3, size.height * 0.08),
          Offset(size.width * 0.4, size.height * 0.15),
          Offset(size.width * 0.45, size.height * 0.2),
          Offset(size.width * 0.5, size.height * 0.3), // Break-even
          Offset(size.width * 0.55, size.height * 0.38),
          Offset(size.width * 0.6, size.height * 0.45),
          Offset(size.width * 0.65, size.height * 0.52),
          Offset(size.width * 0.7, size.height * 0.6),
          Offset(size.width * 0.75, size.height * 0.65),
          Offset(size.width * 0.8, size.height * 0.7), // Limited loss
          Offset(size.width * 0.9, size.height * 0.7),
          Offset(size.width, size.height * 0.7),
        ];
      default: // Strangle
        return [
          Offset(0, size.height * 0.85), // Loss on far left
          Offset(size.width * 0.08, size.height * 0.82),
          Offset(size.width * 0.15, size.height * 0.75),
          Offset(size.width * 0.2, size.height * 0.65),
          Offset(size.width * 0.25, size.height * 0.5),
          Offset(size.width * 0.3, size.height * 0.4), // Break-even low
          Offset(size.width * 0.35, size.height * 0.25),
          Offset(size.width * 0.4, size.height * 0.15),
          Offset(size.width * 0.45, size.height * 0.1),
          Offset(size.width * 0.5, size.height * 0.08), // Max profit
          Offset(size.width * 0.55, size.height * 0.1),
          Offset(size.width * 0.6, size.height * 0.15),
          Offset(size.width * 0.65, size.height * 0.25),
          Offset(size.width * 0.7, size.height * 0.4), // Break-even high
          Offset(size.width * 0.75, size.height * 0.5),
          Offset(size.width * 0.8, size.height * 0.65),
          Offset(size.width * 0.85, size.height * 0.75),
          Offset(size.width * 0.92, size.height * 0.82),
          Offset(size.width, size.height * 0.85), // Loss on far right
        ];
    }
  }

  void _drawLabels(Canvas canvas, Size size, TextPainter textPainter) {
    // Draw axis labels
    textPainter.text = TextSpan(
      text: 'Market Values',
      style: TextStyle(color: Colors.black, fontSize: 10),
    );
    textPainter.layout();
    canvas.drawText(
      textPainter,
      Offset(size.width / 2 - textPainter.width / 2, size.height - 15),
    );

    textPainter.text = TextSpan(
      text: 'Profit',
      style: TextStyle(color: Colors.black, fontSize: 10),
    );
    textPainter.layout();
    canvas.save();
    canvas.translate(15, size.height / 2);
    canvas.rotate(-pi / 2);
    canvas.drawText(textPainter, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension CanvasExtension on Canvas {
  void drawText(TextPainter textPainter, Offset offset) {
    textPainter.paint(this, offset);
  }
}
