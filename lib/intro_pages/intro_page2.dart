import 'package:flutter/material.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _rocketAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _imageHoverAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Longer animation duration
      vsync: this,
    );

    // Rocket animation (moving from bottom to top)
    _rocketAnimation = Tween<Offset>(
      begin: Offset(0, 1.5), // Start from off the bottom of the screen
      end: Offset(0, -0.2), // End slightly off the top of the screen
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Hover animation for stars (slight scale effect)
    _imageHoverAnimation = Tween<double>(
      begin: 1.0, // Original size
      end: 1.05, // Slightly larger size to simulate hover
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Fade-in animation for the text
    _textFadeAnimation = Tween<double>(
      begin: 0.0, // Fully transparent
      end: 1.0, // Fully visible
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
      backgroundColor: Colors.black, // Space-like background
      body: Stack(
        children: [
          // Background stars with a hover effect
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
                      'assets/img/space_background.webp', // New space background image
                      fit: BoxFit.cover, // Make the image cover the full screen
                    ),
                  ),
                ),
              );
            },
          ),

          // Rocket animation (moving from bottom to top)
          Positioned.fill(
            child: SlideTransition(
              position: _rocketAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/img/rocket.png', // Replace with your rocket image
                  width: 100,
                  height: 200,
                ),
              ),
            ),
          ),

          // Exhaust/smoke effect (below the rocket)
          Positioned(
            bottom: 100, // Positioned just below the rocket
            left: MediaQuery.of(context).size.width * 0.4, // Center the exhaust
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _controller
                      .value, // Smoke fades out as the rocket moves up
                  child: Image.asset(
                    'assets/img/gas.webp', // Replace with your smoke/exhaust image
                    width: 120,
                    height: 120,
                  ),
                );
              },
            ),
          ),

          // Fade-in Text with Slide-In Effect from the right to the top
          Positioned(
            top: 50, // Position the text towards the top
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textFadeAnimation,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Ethiopian Space Science and Geospatial Institute",
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
        ],
      ),
    );
  }
}
