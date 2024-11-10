import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/technician_ticket_detail.dart';
import 'package:pro/services/database/database_service.dart';

class TechnicianTicketList extends StatelessWidget {
  final String technicianName;
  final DatabaseService _databaseService = DatabaseService();

  TechnicianTicketList({super.key, required this.technicianName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Assigned Tickets"),
      ),
      body: StreamBuilder<List<MaintenanceTicket>>(
        stream: _databaseService.getTechnicianTickets(technicianName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tickets assigned to you."));
          }

          final tickets = snapshot.data!;

          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(ticket.title),
                  subtitle: Text("Priority: ${ticket.priority}\n"
                      "Status: ${ticket.status}"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigate to a detailed view of the ticket if needed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TechnicianTicketDetail(ticket: ticket),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
