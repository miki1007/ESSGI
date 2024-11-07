import 'package:flutter/material.dart';
import 'package:pro/Models/user.dart';
import 'package:pro/services/Auth/auth_services.dart';
import 'package:pro/services/database/database_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({
    super.key,
    required this.uid,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(currentUserId);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0, // Removes shadow
        title: Center(
          child: Text(
            _isLoading || user == null
                ? 'Loading...'
                : user!.username.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true, // Extends body behind the AppBar
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                        height: 100), // Adjusted spacing to prevent overlap

                    // Profile picture
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // User Info Containers
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildInfoContainer(
                            context,
                            title: 'N A M E',
                            value: user!.name.toUpperCase(),
                          ),
                          _buildInfoContainer(
                            context,
                            title: 'R O L E',
                            value: user!.role.toUpperCase(),
                          ),
                          _buildInfoContainer(
                            context,
                            title: 'U S E R N A M E',
                            value: user!.username.toUpperCase(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoContainer(BuildContext context,
      {required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
            Theme.of(context).colorScheme.secondary.withOpacity(0.8)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
