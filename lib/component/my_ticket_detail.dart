// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/my_update.dart';
import 'package:pro/services/database/database_service.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Correct import

class TicketDetailPage extends StatelessWidget {
  final MaintenanceTicket ticket;

  TicketDetailPage({required this.ticket});

  final DatabaseService _databaseService = DatabaseService();

  void _deleteTicket(BuildContext context) async {
    await _databaseService.deleteTicket(ticket.ticketID);
    Navigator.pop(context);
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => UpdateTicketDialog(
        ticket: ticket,
        onUpdate: (updatedTicket) async {
          await _databaseService.updateTicket(updatedTicket);
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ticket.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showUpdateDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Ticket'),
                  content: Text('Are you sure you want to delete this ticket?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _deleteTicket(context);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Title: ${ticket.title}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const SizedBox(height: 8),
              Text('Description: ${ticket.description}'),
              const SizedBox(height: 8),
              Text('Priority: ${ticket.priority}'),
              const SizedBox(height: 8),
              Text('Problem Type: ${ticket.problemType}'),
              const SizedBox(height: 8),
              Text('Urgency: ${ticket.urgency}'),
              const SizedBox(height: 8),
              Text('Status: ${ticket.status}'),
              const SizedBox(height: 8),
              Text('Created At: ${ticket.createdAt.toDate()}'),
              const SizedBox(height: 8),
              Text('Updated At: ${ticket.updatedAt.toDate()}'),
              const SizedBox(height: 40),
              const SizedBox(height: 8),
              Text('assignedTo: ${ticket.assignedTo}'),
              const SizedBox(height: 40),
              // QR Code
              Center(
                child: Container(
                  child: QrImageView(data: ticket.ticketID),
                  height: 300,
                  width: 300,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                  child: Text(
                ticket.ticketID,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
