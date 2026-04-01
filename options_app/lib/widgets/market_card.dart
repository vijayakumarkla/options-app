import 'package:flutter/material.dart';
import 'dart:math' as math;

class MarketCard extends StatelessWidget {
  final double nifty;
  final double vix;
  final String trend;

  MarketCard({required this.nifty, required this.vix, required this.trend});

  Color _getCardColor() {
    final trendLower = trend.toLowerCase();
    if (trendLower.contains('bear')) {
      return const Color.fromARGB(255, 218, 106, 117); // Light red for bear market
    } else if (trendLower.contains('bull')) {
      return Colors.green.shade100; // Light green for bull market
    } else {
      return Colors.blue.shade100; // Light blue for sideways market
    }
  }

  Color _vixColor() {
    if (vix <= 15) return Colors.green;
    if (vix <= 20) return Colors.lightGreen;
    if (vix <= 30) return Colors.orange;
    return Colors.red;
  }

  String _vixLabel() {
    if (vix <= 15) return 'Low volatility';
    if (vix <= 20) return 'Moderate volatility';
    if (vix <= 30) return 'High volatility';
    return 'Extreme volatility';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      color: _getCardColor(),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: Market heading with Nifty, VIX, Trend
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📊 Market", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DataTable(
                    columnSpacing: 16,
                    dataRowHeight: 20,
                    headingRowHeight: 24,
                    columns: [
                      DataColumn(
                        label: Text('Todays ', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Nifty')),
                        DataCell(Text(nifty.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('VIX')),
                        DataCell(Text(vix.toStringAsFixed(1))),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Trend')),
                        DataCell(Text(trend)),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            // Right column: VIX meter with details
            Expanded(
              flex: 1,
              child: _VixMeter(value: vix, color: _vixColor(), label: _vixLabel()),
            ),
          ],
        ),
      ),
    );
  }
}

class _VixMeter extends StatelessWidget {
  final double value;
  final Color color;
  final String label;

  const _VixMeter({
    required this.value,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('VIX Meter', style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 4),
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        SizedBox(
          height: 120,
          width: 150,
          child: CustomPaint(painter: _SpeedometerPainter(value: value)),
        ),
      ],
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  final double value;

  _SpeedometerPainter({required this.value});

  static const maxVix = 40.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // Start from left (π radians)
      3.14159, // 180 degrees
      false,
      backgroundPaint,
    );

    // Draw colored segments
    final segmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Green segment (0-15)
    segmentPaint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159,
      (15 / maxVix) * 3.14159,
      false,
      segmentPaint,
    );

    // Light green segment (15-20)
    segmentPaint.color = Colors.lightGreen;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159 + (15 / maxVix) * 3.14159,
      (5 / maxVix) * 3.14159,
      false,
      segmentPaint,
    );

    // Orange segment (20-30)
    segmentPaint.color = Colors.orange;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159 + (20 / maxVix) * 3.14159,
      (10 / maxVix) * 3.14159,
      false,
      segmentPaint,
    );

    // Red segment (30-40)
    segmentPaint.color = Colors.red;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159 + (30 / maxVix) * 3.14159,
      (10 / maxVix) * 3.14159,
      false,
      segmentPaint,
    );

    // Draw needle
    final clampedValue = value.clamp(0.0, maxVix);
    final angle = 3.14159 + (clampedValue / maxVix) * 3.14159;

    final needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final needleLength = radius - 15;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(angle),
      center.dy + needleLength * math.sin(angle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw center dot
    final centerDotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 5, centerDotPaint);

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // 0 label
    textPainter.text = TextSpan(
      text: '0',
      style: TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    final zeroPos = Offset(
      center.dx - radius * math.cos(3.14159),
      center.dy - radius * math.sin(3.14159) + 15,
    );
    textPainter.paint(canvas, zeroPos - Offset(textPainter.width / 2, 0));

    // 20 label
    textPainter.text = TextSpan(
      text: '20',
      style: TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    final twentyPos = Offset(center.dx, center.dy - radius + 15);
    textPainter.paint(canvas, twentyPos - Offset(textPainter.width / 2, 0));

    // 40 label
    textPainter.text = TextSpan(
      text: '40',
      style: TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    final fortyPos = Offset(
      center.dx + radius * math.cos(3.14159),
      center.dy - radius * math.sin(3.14159) + 15,
    );
    textPainter.paint(canvas, fortyPos - Offset(textPainter.width / 2, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
