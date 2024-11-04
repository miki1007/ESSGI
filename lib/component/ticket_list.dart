import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/my_ticket_detail.dart';
import 'package:pro/services/database/database_service.dart';
// Import your database service

class TicketList extends StatefulWidget {
  final String status;

  const TicketList({Key? key, required this.status}) : super(key: key);

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Center(child: Text('${widget.status} Tickets')),
          ],
        ),
      ),
      body: FutureBuilder<List<MaintenanceTicket>>(
        future: DatabaseService()
            .fetchTicketsByStatus(widget.status), // Fetch tickets by status
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final tickets = snapshot.data ?? [];
          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(ticket.title),
                  subtitle: Text('Priority: ${ticket.priority}'),
                  trailing: Text('Status: ${ticket.status}'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TicketDetailPage(ticket: ticket)));
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
