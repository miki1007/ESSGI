// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart'; // Import your model
import 'package:pro/component/admin_ticket_detail.dart';
import 'package:pro/component/my_button.dart';
import 'package:pro/component/my_drawer.dart';
import 'package:pro/component/my_text_field.dart';
import 'package:pro/component/my_ticket_request.dart';
import 'package:pro/services/database/database_service.dart';

class TechnicianHomePage extends StatefulWidget {
  const TechnicianHomePage({super.key});

  @override
  State<TechnicianHomePage> createState() => _TechnicianHomePageState();
}

class _TechnicianHomePageState extends State<TechnicianHomePage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  final DatabaseService _db = DatabaseService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshTickets() {
    setState(() {
      // This will refresh the state to show updates if needed
    });
  }

  void _searchTickets(String query) async {
    final results = await _db.searchTickets(query);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      appBar: AppBar(
        title: _isSearching
            ? MyTextField(
                controller: _searchController,
                hintText: 'Search',
                obscureText: false,
                onChanged: _searchTickets,
              )
            : Text('Technician Board'.toUpperCase()),
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
      ),
      body: _isSearching
          ? _buildSearchResults()
          : Column(
              children: [
                //make the search functionality

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 350,
                  child: Center(
                    child: Image.asset(
                      'assets/img/intro_img_1.webp',
                      fit: BoxFit.cover, // This makes the image cover the width
                      width: double.infinity,
                    ),
                  ),
                ),
                //catagories
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Text(
                      'Wellcome to ETHIOPIAN SPACE SCIENCE AND GLOSSARIAL INSTITUTE Addis Ababa \n\n'),
                ),
                const SizedBox(height: 20),

                //create ticket button
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: MyButton(
                    text: "CREATE TICKET",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CreateTicketDialog(
                            onTicketCreated: () {
                              _refreshTickets(); // Refresh data after creating a ticket
                            },
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }

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
                      builder: (context) => AdminTicketDetail(ticket: ticket),
                    ),
                  );
                },
              );
            },
          )
        : const Center(child: Text('No results found'));
  }
}
