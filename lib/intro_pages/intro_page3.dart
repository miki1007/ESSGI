// IntroPage3 - Highlighting Key Projects and Achievements of ESSGI

import 'package:flutter/material.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  _IntroPage3State createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _imageHoverAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Animation duration
      vsync: this,
    );

    // Slide animation for the text (from right to left)
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Hover animation for the image (slight scale effect)
    _imageHoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animations
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          // Background Image with hover effect
          AnimatedBuilder(
            animation: _imageHoverAnimation,
            builder: (context, child) {
              return Center(
                child: Transform.scale(
                  scale: _imageHoverAnimation.value,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      'assets/img/intro_img_3.webp', // Updated image for projects
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          // Title Text with Slide-In Effect
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Pioneering Projects in Space Science",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Description Text for ongoing and completed projects
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: const Text(
                "From satellite launches to groundbreaking geospatial research, our projects support sustainable development and innovation.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
