import 'package:flutter/material.dart';
import 'package:pro/Models/user.dart';
import 'package:pro/services/Auth/auth_services.dart';
import 'package:pro/services/database/database_provider.dart';
import 'package:provider/provider.dart';

/*
   PROFILE PAGE

   This is a profile page for a given uid
 */
class ProfilePage extends StatefulWidget {
  //user id
  final String uid;

  const ProfilePage({
    super.key,
    required this.uid,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //providers
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  //user info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  //loading
  bool _isLoading = true;

  //on startup
  @override
  void initState() {
    super.initState();
    //let's the user info
    loadUser();
  }

  Future<void> loadUser() async {
    //get user profile info
    user = await databaseProvider.userProfile(currentUserId);

    //finished loading
    setState(() {
      _isLoading = false;
    });
  }

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: Center(
            child: Text(
          _isLoading || user == null
              ? 'Loading...'
              : user!.username.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ListView(
                  children: [
                    //profile picture
                    const Icon(
                      Icons.person,
                      size: 100,
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        'R O L E : ${user!.role.toUpperCase()}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        'U S E R N A M E: ${user!.username.toUpperCase()}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    //list of post from user
                  ],
                ),
              ),
            ),
    );
  }
}
