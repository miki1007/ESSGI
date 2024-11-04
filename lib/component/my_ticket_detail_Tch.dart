import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/my_update_Tch.dart';
import 'package:pro/services/database/database_service.dart';

class TicketDetailPageTch extends StatelessWidget {
  final MaintenanceTicket ticket;

  TicketDetailPageTch({required this.ticket});

  final DatabaseService _databaseService = DatabaseService();

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => UpdateTicketDialogTch(
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
          return const Center(child: CircularProgressIndicator());
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
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            title: Center(
              child: Text(
                'TICKET ID: ${ticket.ticketID}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _showUpdateDialog(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.9),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.9),
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
                    _buildDetailRow(
                      context,
                      Icons.title,
                      'Title',
                      ticket.title,
                      titleSize: 25,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      context,
                      Icons.description,
                      'Description',
                      ticket.description,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.priority_high,
                      'Priority',
                      ticket.priority,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.bug_report,
                      'Problem Type',
                      ticket.problemType,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.speed,
                      'Urgency',
                      ticket.urgency,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.check_circle_outline,
                      'Status',
                      ticket.status,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.calendar_today,
                      'Created At',
                      ticket.createdAt.toDate().toString(),
                    ),
                    _buildDetailRow(
                      context,
                      Icons.update,
                      'Updated At',
                      ticket.updatedAt.toDate().toString(),
                    ),
                    _buildDetailRow(
                      context,
                      Icons.person,
                      'Assigned To',
                      ticket.assignedTo,
                    ),
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

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String content,
      {double titleSize = 20}) {
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w500,
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
