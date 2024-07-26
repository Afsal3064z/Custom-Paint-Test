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
  int _currentPage = 0;
  int _pauseCounter = 0;
  final int _pauseDuration = 30; // Adjust this value to control pause duration

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {
          if (_currentPage == 0 && _pauseCounter < _pauseDuration) {
            _pauseCounter++;
            if (_pauseCounter == _pauseDuration) {
              _animationController.stop();
              Future.delayed(const Duration(seconds: 1), () {
                _animationController.forward(from: 0);
              });
            }
          } else {
            _currentPage = (_currentPage + 1) % 6;
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
                painter: CirclePainter(_animation.value, _currentPage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//This is the painter for the circle in the background of the view..
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
          ? 1.0 + 1.0 * (1 - animationValue) // scales down from 2.0 to 1.0
          : 1.0;

      final circleSize = 30.0 * scale;

      canvas.drawCircle(Offset(dx, dy), circleSize,
          paint..color = isCurrent ? Colors.red : Colors.blue);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
