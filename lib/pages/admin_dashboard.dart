// ignore_for_file: must_be_immutable

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pro/component/my_drawer.dart';
import 'package:pro/pages/profile_page.dart';
import 'package:pro/pages/requested_ticket.dart';
import 'package:pro/pages/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages to navigate between
  final List<Widget> _pages = [
    const Center(child: Text('Home Page')),
    TicketListPage(),
    const ProfilePage(uid: ''),
    const SettingPage()
  ];

  // Method to handle when a bottom nav item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//  UI
//_________________________________________________________________________
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text('A D M I N   D A S H B O A R D'),
              foregroundColor: Theme.of(context).colorScheme.primary,
            )
          : null,

      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        color: Colors.blueAccent,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.blue,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.dashboard, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped, // Handle tap on navigation items
      ),
    );
  }
}
