// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:pro/intro_pages/intro_page1.dart';
import 'package:pro/intro_pages/intro_page2.dart';
import 'package:pro/intro_pages/intro_page3.dart';
import 'package:pro/services/Auth/auth_get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  // Controller to keep the page status
  final PageController _controller = PageController();
  bool isLastPage = false;
  bool isNewUser = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  // Check if the user is new or returning
  Future<void> _checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? seenOnboard = prefs.getBool('seenOnboard');

    if (seenOnboard == true) {
      // If the user has seen the onboarding, navigate to AuthGet
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthGet()),
      );
    } else {
      // Set isNewUser to true and proceed to onboarding
      setState(() {
        isNewUser = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If the user is not new, show a loading indicator
    if (!isNewUser) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = (index == 2);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Dot indicator
                SmoothPageIndicator(controller: _controller, count: 3),
                // Next or Done
                isLastPage
                    ? GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool(
                              'seenOnboard', true); // Mark as seen
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const AuthGet();
                          }));
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
