// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pro/component/my_drawer_tile.dart';
import 'package:pro/pages/about_us.dart';
import 'package:pro/pages/profile_page.dart';
import 'package:pro/pages/requested_ticket.dart';
import 'package:pro/pages/setting_page.dart';
import 'package:pro/services/Auth/auth_services.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  // Access the auth service
  final _auth = AuthService();

  // Logout method
  void logout(BuildContext context) async {
    await _auth.logout();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/loginOrRegister', (route) => false);
    // Return to the first route (usually the login page)
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              // APP LOGO
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: CircleAvatar(
                    radius: 40, // Adjust the radius as needed
                    backgroundImage: AssetImage(
                        'assets/img/admin.webp'), // Path to your image
                  )),
              // DIVIDER
              Divider(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 10),

              // Home list tile
              MyDrawerTile(
                title: 'H o m e',
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              // Profile list tile
              MyDrawerTile(
                title: "P r o f i l e",
                icon: Icons.person,
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(uid: _auth.getCurrentUid()),
                    ),
                  );
                },
              ),
              // Settings list tile
              MyDrawerTile(
                title: 'S e t t i n g',
                icon: Icons.settings,
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()),
                  );
                },
              ),

              // Ticket list tile
              MyDrawerTile(
                title: 'T I C K E T  L I S T',
                icon: Icons.line_style_outlined,
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TicketListPage()),
                  );
                },
              ),
              MyDrawerTile(
                title: 'About US',
                icon: Icons.insert_drive_file_rounded,
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
              ),
              // Spacer to push Logout to the bottom
              const Spacer(),
              // Logout list tile
              MyDrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: () => logout(context), // Pass context to logout
              ),
            ],
          ),
        ),
      ),
    );
  }
}
