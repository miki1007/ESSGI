// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/my_drawer.dart';
import 'package:pro/component/my_text_field.dart';
import 'package:pro/component/my_ticket_detail.dart';
import 'package:pro/pages/admin_home.dart';
import 'package:pro/pages/profile_page.dart';
import 'package:pro/pages/requested_ticket.dart';
import 'package:pro/pages/setting_page.dart';
import 'package:pro/services/database/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  final DatabaseService _db = DatabaseService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchTickets(String query) async {
    final results = await _db.searchTickets(query);
    setState(() {
      _searchResults = results;
    });
  }

  int _selectedIndex = 0;

  // List of pages to navigate between
  final List<Widget> _pages = [
    const AdminHome(),
    TicketListPage(),
    const ProfilePage(uid: ''),
    const SettingPage()
  ];

  // Method to handle when a bottom nav item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//  UI
//_________________________________________________________________________
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: MyDrawer(), // Your custom drawer

        appBar: _selectedIndex == 0
            ? AppBar(
                title: _isSearching
                    ? MyTextField(
                        controller: _searchController,
                        hintText: 'Search',
                        obscureText: false,
                        onChanged: _searchTickets,
                      )
                    : Text('admin board'.toUpperCase()),
                actions: [
                  IconButton(
                    icon: Icon(_isSearching ? Icons.clear : Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchController.clear();
                          _searchResults.clear();
                        }
                      });
                    },
                  ),
                ],
              )
            : null,

        body: Column(
          children: [
            if (_isSearching) // If searching, display search results
              Expanded(child: _buildSearchResults())
            else
              Expanded(child: _pages[_selectedIndex]),
          ],
        ),

        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 300),
          index: _selectedIndex,
          height: 60,
          color: Colors.blueAccent,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Theme.of(context).colorScheme.primary,
          items: [
            Icon(Icons.home,
                size: 30, color: Theme.of(context).colorScheme.tertiary),
            Icon(Icons.book_online,
                size: 30, color: Theme.of(context).colorScheme.tertiary),
            Icon(Icons.person,
                size: 30, color: Theme.of(context).colorScheme.tertiary),
            Icon(Icons.settings,
                size: 30, color: Theme.of(context).colorScheme.tertiary),
          ],
          onTap: _onItemTapped, // Handle tap on navigation items
        ),
      ),
    );
  }

  //searching widget
  Widget _buildSearchResults() {
    return _searchResults.isNotEmpty
        ? ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              var ticketData =
                  _searchResults[index].data() as Map<String, dynamic>;
              var ticketID = _searchResults[index].id;
              var ticket = MaintenanceTicket.fromMap(ticketData, ticketID);

              return ListTile(
                title: Text(ticket.title),
                subtitle: Text(ticket.assignedTo),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailPage(ticket: ticket),
                    ),
                  );
                },
              );
            },
          )
        : const Center(child: Text('No results found'));
  }
}
