import 'package:flutter/material.dart';
import 'package:pro/Models/user.dart';
import 'package:pro/services/database/database_service.dart';

class AppUserList extends StatefulWidget {
  @override
  _AppUserListState createState() => _AppUserListState();
}

class _AppUserListState extends State<AppUserList> {
  late Future<List<UserProfile>> _users;

  @override
  void initState() {
    super.initState();
    _users = DatabaseService().getUsers();
  }

  int _getUserCount(List<UserProfile> users) {
    return users.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<UserProfile>>(
          future: _users,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading users...');
            } else if (snapshot.hasError) {
              return Text('Error loading users');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No users found');
            } else {
              // Display the count in the AppBar title
              int userCount = _getUserCount(snapshot.data!);
              return Text('User List ($userCount)');
            }
          },
        ),
      ),
      body: FutureBuilder<List<UserProfile>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          List<UserProfile> users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
                trailing: Text(users[index].role),
              );
            },
          );
        },
      ),
    );
  }
}
