import 'dart:async';
import 'package:corosal_test/circle_box.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 1; // Start from the first duplicate
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(viewportFraction: 0.7, initialPage: _currentPage);
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 6) {
        setState(() {
          _currentPage++;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeIn,
          );
        });
      } else {
        setState(() {
          _currentPage = 1;
          _pageController.jumpToPage(_currentPage); // Jump without animation
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
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
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                itemCount: 8, // 6 original + 2 duplicates
                itemBuilder: (context, index) {
                  bool isCurrent = index == _currentPage;
                  double scale = isCurrent ? 1.0 : 0.8;
                  int displayIndex = index;
                  if (index == 0) {
                    displayIndex = 5; // Duplicate of the last item
                  } else if (index == 7) {
                    displayIndex = 0; // Duplicate of the first item
                  } else {
                    displayIndex = index - 1;
                  }
                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child:
                          CircleBox(isCurrent: isCurrent, index: displayIndex),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
