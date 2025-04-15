import 'dart:math';
import 'package:flutter/material.dart';

class DynamicCircularIndicator extends StatelessWidget {
  final double percentage; // Percentage to display (0.0 to 100.0)
  final Color color; // Background color of the circle
  final Color progressColor; // Color for the progress arc
  final double size; // Diameter of the circle

  DynamicCircularIndicator({
    required this.percentage,
    required this.color,
    required this.progressColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size + 100,
          height: size,
          child: CustomPaint(
            painter: CircularIndicatorPainter(
              percentage: percentage,
              color: color,
              progressColor: progressColor,
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 75,
          child: Column(
            children: const [
              Text(
                "3",
                style: TextStyle(fontSize: 90, fontWeight: FontWeight.w700),
              ),
              Text(
                "Months",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CircularIndicatorPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color progressColor;

  CircularIndicatorPainter({
    required this.percentage,
    required this.color,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12; // Adjust stroke width

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.13 // Adjust stroke width
      ..strokeCap = StrokeCap.round; // Rounded ends

    final Paint endCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final double startAngle = -1; // Starting angle (top of the circle)
    final double sweepAngle =
        2 * 3.14159 * (percentage / 100); // Sweep angle based on percentage

    // Draw the background circle
    canvas.drawCircle(center, radius - (size.width * 0.1 / 2), backgroundPaint);

    // Draw the progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - (size.width * 0.1 / 2)),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Calculate the end point of the arc
    final double endAngle = startAngle + sweepAngle;
    final double endX =
        center.dx + (radius - (size.width * 0.1 / 2)) * cos(endAngle);
    final double endY =
        center.dy + (radius - (size.width * 0.1 / 2)) * sin(endAngle);

    // Draw the white circle at the end of the progress arc
    final double endCircleRadius =
        size.width * 0.1 / 2; // Radius of the white circle
    canvas.drawCircle(Offset(endX, endY), endCircleRadius, endCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
