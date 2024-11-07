import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro/pages/admin_dashboard.dart';
import 'package:pro/pages/technician_board.dart';
import 'package:pro/services/Auth/login_or_register.dart';
import 'package:pro/services/database/database_service.dart';

class AuthGet extends StatefulWidget {
  const AuthGet({super.key});

  @override
  State<AuthGet> createState() => _AuthGetState();
}

class _AuthGetState extends State<AuthGet> {
  // Get the instance of the database
  final _db = DatabaseService();

  // Navigation controller based on user role
  Future<void> navigateBasedOnRole(String uid) async {
    final role = await _db.getUserRole(uid);
    if (role == 'Admin') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else if (role == 'Technician') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const TechnicianBoard()));
    } else {
      print("Unknown role: $role");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final uid = snapshot.data!.uid;
              navigateBasedOnRole(uid);

              return Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.inversePrimary,
              ));
            } else {
              return const LoginOrRegister();
            }
          }
          // Show a loading indicator while waiting for auth state
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.inversePrimary,
          ));
        },
      ),
    );
  }
}
