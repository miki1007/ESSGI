import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/user.dart';
import 'package:pro/component/my_drawer.dart';
import 'package:pro/pages/profile_page.dart';
import 'package:pro/pages/setting_page.dart';
import 'package:pro/pages/technician_home_Page.dart';
import 'package:pro/pages/technician_ticket_list.dart';
import 'package:pro/services/Auth/auth_services.dart';
import 'package:pro/services/database/database_provider.dart';
import 'package:provider/provider.dart';

class TechnicianBoard extends StatefulWidget {
  const TechnicianBoard({super.key});

  @override
  State<TechnicianBoard> createState() => _TechnicianBoardState();
}

class _TechnicianBoardState extends State<TechnicianBoard> {
  late final DatabaseProvider databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();
  int _currentPage = 0;
  bool isLoading = true; // Flag to indicate loading state

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(currentUserId);
    setState(() {
      isLoading = false; // Set loading to false once user is loaded
    });
  }

  // Method to handle when a bottom nav item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if still loading user data
    if (isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Define the list of pages after user data is loaded
    final List<Widget> pages = [
      const TechnicianHomePage(),
      TechnicianTicketList(technicianName: user!.name),
      ProfilePage(uid: currentUserId),
      const SettingPage(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Expanded widget to show the page content
          Expanded(
            child: pages[_currentPage],
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentPage,
        animationDuration: const Duration(milliseconds: 300),
        height: 60,
        color: Theme.of(context).colorScheme.secondary,
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
