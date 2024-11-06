import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/my_button.dart';
import 'package:pro/component/my_drawer_Tch.dart';
import 'package:pro/component/my_text_field.dart';
import 'package:pro/component/my_ticket_detail.dart';
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

  void _searchTickets(String query) async {
    final results = await _db.searchTickets(query);
    setState(() {
      _searchResults = results;
    });
  }

  void _refreshTickets() {
    setState(() {});
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
            : Text('Technician Dashboard'.toUpperCase()),
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
      body: _isSearching ? _buildSearchResults() : _buildDashboardContent(),
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
                      builder: (context) => TicketDetailPage(ticket: ticket),
                    ),
                  );
                },
              );
            },
          )
        : const Center(child: Text('No results found'));
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Featured Image
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/img/intro_img_1.webp',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Welcome message section with background decoration
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  'Welcome to the Ethiopian Space Science Maintenance Dashboard',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Description text to fill more space
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'As a technician, your role is crucial in maintaining the smooth operation of our space science facilities. This dashboard empowers you to efficiently manage and track maintenance tickets, ensuring that all assigned tasks are completed promptly and to the highest standards.\n\n',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                MyButton(
                  text: 'CREATE NEW TICKET',
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
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
