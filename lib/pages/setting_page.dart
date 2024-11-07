import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro/component/my_button.dart';
import 'package:pro/component/my_setting_tile.dart';
import 'package:pro/pages/app_user_list.dart';
import 'package:pro/theme/themeProvider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'S e t t i n g ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor:
            Colors.transparent, // Make AppBar background transparent
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100), // Space for AppBar overlap
            // Dark Mode Tile
            MySettingTile(
              title: 'Dark Mode',
              action: CupertinoSwitch(
                onChanged: (value) =>
                    Provider.of<Themeprovider>(context, listen: false)
                        .toggleTheme(),
                value: Provider.of<Themeprovider>(context, listen: false)
                    .isDarMode,
              ),
            ),
            const SizedBox(height: 20),
            // Manage Users Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: MyButton(
                text: 'Manage Users',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppUserList()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
