import 'package:flutter/material.dart';

class StrategyCard extends StatelessWidget {
  final String type;
  final Map<String, dynamic> trade;

  const StrategyCard({
    Key? key,
    required this.type,
    required this.trade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type,
                style:
                    TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              height: 140,
              width: double.infinity,
              child: CustomPaint(
                painter: StrategyChartPainter(
                  type: type,
                  trade: trade,
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
  final Map<String, dynamic> trade;

  StrategyChartPainter({
    required this.type,
    required this.trade,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final zeroY = size.height / 2;

    final grid = Paint()..color = Colors.grey.shade300;

    for (int i = 0; i <= 4; i++) {
      canvas.drawLine(
          Offset(size.width * i / 4, 0),
          Offset(size.width * i / 4, size.height),
          grid);
    }

    canvas.drawLine(
        Offset(0, zeroY), Offset(size.width, zeroY),
        Paint()..color = Colors.black);

    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    List<Offset> points = _getPoints(size);

    for (int i = 0; i < points.length - 1; i++) {
      paint.color =
          points[i].dy < zeroY ? Colors.green : Colors.red;
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  List<Offset> _getPoints(Size size) {
    switch (type) {
      case "Bull Call Spread":
        return [
          Offset(0, size.height * 0.7),
          Offset(size.width * 0.5, size.height * 0.7),
          Offset(size.width * 0.7, size.height * 0.3),
          Offset(size.width, size.height * 0.3),
        ];

      case "Bear Call Spread":
        return [
          Offset(0, size.height * 0.3),
          Offset(size.width * 0.5, size.height * 0.3),
          Offset(size.width * 0.7, size.height * 0.7),
          Offset(size.width, size.height * 0.7),
        ];

      case "Iron Condor":
        return [
          Offset(0, size.height * 0.7),
          Offset(size.width * 0.3, size.height * 0.4),
          Offset(size.width * 0.7, size.height * 0.4),
          Offset(size.width, size.height * 0.7),
        ];

      default:
        return [
          Offset(0, size.height * 0.6),
          Offset(size.width * 0.5, size.height * 0.3),
          Offset(size.width, size.height * 0.6),
        ];
    }
  }

  @override
  bool shouldRepaint(covariant StrategyChartPainter oldDelegate) {
    return true;
  }
}