// IntroPage2 - Mission and Vision of ESSGI

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2>
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

    // Slide animation for the text (from left to center)
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0), // Start position (off the left edge)
      end: Offset.zero, // End position (center)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Hover animation for the image (slight scale effect)
    _imageHoverAnimation = Tween<double>(
      begin: 1.0, // Original size
      end: 1.05, // Slightly larger to simulate hover
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animations
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose the controller to avoid memory leaks
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
                      'assets/img/intro_img_2.webp', // Image related to ESSGI's mission
                      fit: BoxFit.cover, // Cover the full screen
                    ),
                  ),
                ),
              );
            },
          ),
          // Title Text with Slide-In Effect
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Our Mission",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Mission Description
          Positioned(
            top: 90,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "At ESSGI, we are dedicated to advancing Ethiopia's Space and Geospatial capabilities. "
                  "Our mission is to foster innovation, empower scientific research, and drive sustainable "
                  "development through cutting-edge technology and collaboration.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          // Vision Title
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Our Vision",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Vision Description
          Positioned(
            top: 350,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: const Text(
                "Our vision is to position Ethiopia as a leader in Space and Geospatial sciences in Africa. "
                "We aim to inspire a new generation of thinkers, researchers, and innovators who will leverage "
                "geospatial intelligence for a brighter, more sustainable future.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
            ),
          ),
          // Call to Action
          Positioned(
            bottom: 50,
            left: 50,
            right: 50,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the next page or perform an action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Join Us on Our Journey",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
