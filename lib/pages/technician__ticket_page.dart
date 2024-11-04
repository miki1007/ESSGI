import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/component/my_ticket_detail_Tch.dart';

import '../Models/ticket_request.dart';

class TechnicianTicketsPage extends StatefulWidget {
  final String technicianName;

  TechnicianTicketsPage({required this.technicianName});

  @override
  _TechnicianTicketsPageState createState() => _TechnicianTicketsPageState();
}

class _TechnicianTicketsPageState extends State<TechnicianTicketsPage> {
  Stream<List<MaintenanceTicket>> _fetchTechnicianTickets() {
    return FirebaseFirestore.instance
        .collection('tickets')
        .where('assignedTo', isEqualTo: widget.technicianName)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return MaintenanceTicket.fromMap(
                  doc.data() as Map<String, dynamic>, doc.id);
            }).toList());
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return FontAwesomeIcons.clock;
      case 'In Progress':
        return FontAwesomeIcons.tools;
      case 'Completed':
        return FontAwesomeIcons.checkCircle;
      default:
        return FontAwesomeIcons.ticketAlt;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tickets for ${widget.technicianName}"),
      ),
      body: StreamBuilder<List<MaintenanceTicket>>(
        stream: _fetchTechnicianTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error loading tickets: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No tickets assigned to ${widget.technicianName}."),
            );
          } else {
            List<MaintenanceTicket> tickets = snapshot.data!;
            return ListView.builder(
              itemCount: tickets.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                MaintenanceTicket ticket = tickets[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      _getStatusIcon(ticket.status),
                      color: _getStatusColor(ticket.status),
                      size: 30,
                    ),
                    title: Text(
                      ticket.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          "Status: ${ticket.status}",
                          style: TextStyle(
                            color: _getStatusColor(ticket.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Urgency: ${ticket.urgency}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Location: ${ticket.location}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TicketDetailPageTch(ticket: ticket),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
