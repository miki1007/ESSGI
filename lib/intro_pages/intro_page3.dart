// IntroPage3 - Highlighting Key Projects and Achievements of ESSGI

// ignore_for_file: library_private_types_in_public_api

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
      duration: const Duration(seconds: 2),
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
                  "Key Projects & Achievements",
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
          // Description of the Project Highlights
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Our projects drive innovation and sustainable development. "
                  "Here are some of the impactful initiatives we're leading.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          // Key Projects & Achievements List
          Positioned(
            top: 200,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ProjectHighlight(
                    title: "Ethiopia's First Satellite Launch",
                    description:
                        "Launched to monitor climate and weather, this project aids in agriculture and disaster response.",
                  ),
                  SizedBox(height: 20),
                  ProjectHighlight(
                    title: "Geospatial Data Mapping for Urban Planning",
                    description:
                        "Enhancing infrastructure planning and urban development with precise geospatial data.",
                  ),
                  SizedBox(height: 20),
                  ProjectHighlight(
                    title: "Educational Outreach Programs",
                    description:
                        "Inspiring the next generation with educational programs focused on STEM and space sciences.",
                  ),
                ],
              ),
            ),
          ),
          // Call to Action Button
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
                "Explore More",
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

// Widget to display project highlights with title and description
class ProjectHighlight extends StatelessWidget {
  final String title;
  final String description;

  const ProjectHighlight({
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
