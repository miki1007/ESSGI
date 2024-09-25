// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pro/Models/user.dart';
import 'package:pro/component/my_bio_box.dart';
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

  const ProfilePage({super.key, required this.uid});

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
    user = await databaseProvider.userProfile(widget.uid);

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      // App Bar
      appBar: AppBar(
        title: Text(_isLoading || user == null ? 'Loading...' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                children: [
                  //username handle
                  Center(
                    child: Text(
                      _isLoading ? '' : '@${user!.username}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  //profile picture
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.all(25),
                      child: Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  //profile status->number of post/followers/following

                  //follow/unfollow
                  //edit bio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "bio",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      )
                    ],
                  ),
                  //bio box
                  MyBioBox(text: _isLoading ? ". . ." : user!.bio),
                  //list of post from user
                ],
              ),
            ),
    );
  }
}
