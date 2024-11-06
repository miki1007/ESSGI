import 'package:flutter/material.dart';
import 'package:pro/Models/user.dart';
import 'package:pro/pages/technician__ticket_page.dart';
import 'package:pro/services/database/database_service.dart';

class AppUserList extends StatefulWidget {
  @override
  _AppUserListState createState() => _AppUserListState();
}

class _AppUserListState extends State<AppUserList> {
  late Future<List<UserProfile>> _users;
  List<UserProfile> _filteredUsers = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _users = DatabaseService().getUsers();
    _users.then((users) => setState(() {
          _filteredUsers = users;
        }));
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredUsers = _filteredUsers
          .where((user) =>
              user.name.toLowerCase().contains(_searchQuery) ||
              user.email.toLowerCase().contains(_searchQuery) ||
              user.role.toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'Technician':
        return Icons.build;
      case 'Admin':
        return Icons.admin_panel_settings;
      case 'User':
      default:
        return Icons.person;
    }
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
              int userCount = _filteredUsers.length;
              return Text('User List ($userCount)');
            }
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _updateSearchQuery,
              decoration: InputDecoration(
                labelText: 'Search Users',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserProfile>>(
              future: _users,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found.'));
                }

                if (_filteredUsers.isEmpty && _searchQuery.isEmpty) {
                  _filteredUsers = snapshot.data!;
                }

                return ListView.builder(
                  itemCount: _filteredUsers.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    var user = _filteredUsers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(
                          _getRoleIcon(user.role),
                          color: user.role == 'Technician'
                              ? Colors.blue
                              : Colors.grey,
                          size: 30,
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user.email),
                        trailing: Text(
                          user.role,
                          style: TextStyle(
                            color: user.role == 'Technician'
                                ? Colors.blue
                                : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          if (user.role == 'Technician') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TechnicianTicketsPage(
                                  technicianName: user.name,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Only technicians have assigned tickets.'),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
