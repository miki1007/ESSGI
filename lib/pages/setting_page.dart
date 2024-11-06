import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro/component/my_button.dart';
import 'package:pro/component/my_setting_tile.dart';
import 'package:pro/pages/app_user_list.dart';
import 'package:pro/services/Auth/delete_user.dart';
import 'package:pro/theme/themeProvider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Center(child: Text('S e t t i n g ')),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          MySettingTile(
            title: 'Dark Mode',
            action: CupertinoSwitch(
              onChanged: (value) =>
                  Provider.of<Themeprovider>(context, listen: false)
                      .toggleTheme(),
              value:
                  Provider.of<Themeprovider>(context, listen: false).isDarMode,
            ),
          ),
          const SizedBox(height: 5),
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
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyButton(
              text: 'Delete Account',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteAccountPage()),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
