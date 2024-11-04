import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/my_update.dart';
import 'package:pro/services/database/database_service.dart';

class TicketDetailPage extends StatelessWidget {
  final MaintenanceTicket ticket;

  TicketDetailPage({required this.ticket});

  final DatabaseService _databaseService = DatabaseService();

  void _deleteTicket(BuildContext context) async {
    await _databaseService.deleteTicket(ticket.ticketID);
    if (context.mounted) {
      Navigator.popAndPushNamed(context, '/TicketListPage');
    }
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
    return StreamBuilder<MaintenanceTicket>(
      stream: _databaseService.getTicketStream(ticket.ticketID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.popAndPushNamed(context, '/TicketListPage');
          });
          return Container();
        }

        final ticket = snapshot.data!;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Ticket ID: ${ticket.ticketID}',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => _showUpdateDialog(context),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Ticket'),
                      content:
                          Text('Are you sure you want to delete this ticket?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteTicket(context);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
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
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Ticket Title
                    Center(
                      child: Text(
                        ticket.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ticket Details with Icons
                    _buildDetailRow(context, Icons.description, 'Description',
                        ticket.description),
                    _buildDetailRow(context, Icons.priority_high, 'Priority',
                        ticket.priority),
                    _buildDetailRow(context, Icons.bug_report, 'Problem Type',
                        ticket.problemType),
                    _buildDetailRow(
                        context, Icons.speed, 'Urgency', ticket.urgency),
                    _buildDetailRow(context, Icons.event, 'Created At',
                        ticket.createdAt.toDate().toString()),
                    _buildDetailRow(context, Icons.update, 'Updated At',
                        ticket.updatedAt.toDate().toString()),
                    _buildDetailRow(context, Icons.person, 'Assigned To',
                        ticket.assignedTo),
                    _buildDetailRow(context, _getStatusIcon(ticket.status),
                        'Status', ticket.status),

                    const SizedBox(height: 40),

                    // QR Code for Ticket ID
                    Center(
                      child: BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: ticket.ticketID,
                        width: 200,
                        height: 80,
                        drawText: true,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to get the appropriate icon for the status
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.hourglass_top;
      case 'In Progress':
        return Icons.work;
      case 'Completed':
        return Icons.check_circle;
      default:
        return Icons.info_outline;
    }
  }

  // Helper function to build detail rows with icons and bold labels
  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
