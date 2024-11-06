import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pro/pages/profile_page.dart';
import 'package:pro/pages/setting_page_Tch.dart';
import 'package:pro/pages/technician__ticket_page.dart';
import 'package:pro/pages/technician_home_Page.dart';

class TechnicianBoard extends StatefulWidget {
  const TechnicianBoard({super.key});

  @override
  State<TechnicianBoard> createState() => _TechnicianBoardState();
}

class _TechnicianBoardState extends State<TechnicianBoard> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    const TechnicianHomePage(),
    TechnicianTicketsPage(
      technicianName: '',
    ),
    const ProfilePage(uid: ''),
    const SettingPageTch(),
  ];

  // Method to handle when a bottom nav item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Expanded widget to show the page content below the container
          Expanded(
            child: _pages[_currentPage],
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentPage,
        animationDuration: Duration(milliseconds: 300),
        height: 60,
        color: Colors.blueAccent,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.blue,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.update, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped, // Handle tap on navigation items
      ),
    );
  }
}
