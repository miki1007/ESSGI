import 'package:flutter/material.dart';
import 'package:pro/services/database/database_service.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final DatabaseService _authService = DatabaseService();
  bool _isLoading = false;

  // Method to show a confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without deleting
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _handleDeleteAccount(); // Handle account deletion
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Method to handle account deletion with loading indicator and navigation to LoginPage
  Future<void> _handleDeleteAccount() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    try {
      await _authService.deleteUserAccount(); // Delete the user account

      // Immediately navigate to login page and clear navigation stack
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/loginOr', (route) => false);
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete account: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Account"),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator while deleting
            : ElevatedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(
                      context); // Show confirmation dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text("Delete Account"),
              ),
      ),
    );
  }
}
