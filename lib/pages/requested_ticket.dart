import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/my_ticket_card.dart';
import 'package:pro/component/my_ticket_request.dart';
import 'package:pro/services/database/database_service.dart'; // Ensure this path is correct

class TicketListPage extends StatelessWidget {
  final DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Tickets'.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<MaintenanceTicket>>(
        stream: dbService.getTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading tickets.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tickets available.'));
          }

          final tickets = snapshot.data!;

          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return TicketCard(ticket: tickets[index]);
            },
          );
        },
      ),
      // Add the FloatingActionButton here
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.yellow,
        onPressed: () => _showCreateTicketDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Create a new ticket',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Ensures circular shape
        ),
      ),
    );
  }

  void _showCreateTicketDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreateTicketDialog(
        onTicketCreated: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
