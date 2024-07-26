import 'dart:math';
import 'package:flutter/material.dart';

class CustomPaintTest extends StatefulWidget {
  const CustomPaintTest({super.key});

  @override
  State<CustomPaintTest> createState() => CustomPaintTestState();
}

class CustomPaintTestState extends State<CustomPaintTest>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _animationValue = 0;
  int _currentPage = 0;
  int _pauseCounter = 0;
  final int _pauseDuration = 20;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..reverse();

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {
          _animationValue = _animation.value;
          if (_pauseCounter < _pauseDuration) {
            _pauseCounter++;
            if (_pauseCounter == _pauseDuration) {
              _animationController.stop();
              Future.delayed(const Duration(milliseconds: 500), () {
                _animationController.forward(from: _animationValue);
                _pauseCounter = _pauseDuration + 1;
              });
            }
          } else {
            if (!_animationController.isAnimating) {
              _currentPage = (_currentPage + 1) % 6;
              _animationController.forward(
                  from: 0.0); // Restart the animation from the beginning
            }
            _pauseCounter = 0;
          }
        });
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carousel Test"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
                "This is a test for the animated carousel in the application"),
            const SizedBox(height: 50),
            Center(
              child: CustomPaint(
                size: const Size(300, 300),
                painter: CirclePainter(_animationValue, _currentPage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double animationValue;
  final int currentPage;

  CirclePainter(this.animationValue, this.currentPage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final radius = min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, paint);

    for (int i = 0; i < 6; i++) {
      final angle = 2 * pi * i / 6 - pi / 2;
      final currentAngle = 2 * pi * (currentPage + animationValue) / 6 - pi / 2;
      final dx = center.dx + 120 * cos(angle - currentAngle);
      final dy = center.dy + 120 * sin(angle - currentAngle);
      final isCurrent = i == (currentPage + 3) % 6;
      double scale = isCurrent
          ? 1.0 +
              0.5 * sin(animationValue * 2 * pi) // Smooth scaling up and down
          : 1.0;

      final circleSize = 30.0 * scale;

      // Draw the circle
      canvas.drawCircle(Offset(dx, dy), circleSize,
          paint..color = isCurrent ? Colors.red : Colors.blue);

      // Draw the number in the center of each circle
      final textSpan = TextSpan(
        text: '${i + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0, // Fixed size for visibility
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: double.maxFinite,
      );
      final textOffset = Offset(
        dx - textPainter.width / 2,
        dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
