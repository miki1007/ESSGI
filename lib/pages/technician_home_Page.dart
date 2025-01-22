import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/my_button.dart';
import 'package:pro/component/my_drawer_tch.dart';
import 'package:pro/component/my_text_field.dart';
import 'package:pro/component/my_ticket_request.dart';
import 'package:pro/component/technician_reference.dart';
import 'package:pro/services/database/database_service.dart';
import 'dart:async';

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
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _refreshTickets() {
    setState(() {
      // Refresh the state to show updates if needed
    });
  }

  void _searchTickets(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final results = await _db.searchTickets(query);
      setState(() {
        _searchResults = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawerTch(),
      appBar: AppBar(
        title: _isSearching
            ? MyTextField(
                controller: _searchController,
                hintText: 'Search',
                obscureText: false,
                onChanged: _searchTickets,
              )
            : Text(
                'Technician Board'.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Center(
                        child: Image.asset(
                          'assets/img/intro_img_1.webp',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.teal[700],
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.home_work,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Welcome to ETHIOPIAN SPACE SCIENCE AND GEOSPATIAL INSTITUTE\n'
                              'Addis Ababa Maintenance App.\n'
                              'Easily manage and track your tickets from anywhere!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.add_task,
                              color: Colors.teal,
                              size: 30,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Ready to create a new ticket? Tap below to get started!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                                  _refreshTickets();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );
    }
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        var ticketData = _searchResults[index].data() as Map<String, dynamic>;
        var ticketID = _searchResults[index].id;
        var ticket = MaintenanceTicket.fromMap(ticketData, ticketID);

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: const Icon(Icons.assignment, color: Colors.teal),
            title: Text(
              ticket.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Assigned to: ${ticket.assignedTo}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TechnicianReference(ticket: ticket),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
