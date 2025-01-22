// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/services/database/database_service.dart';
import 'package:pro/services/image_picker.dart/full_image_view.dart';
import 'package:pro/component/my_button.dart';
import 'package:pro/component/technician_ticket_detail.dart';

class TechnicianTicketDetailView extends StatefulWidget {
  final MaintenanceTicket ticket;

  const TechnicianTicketDetailView({super.key, required this.ticket});

  @override
  _TechnicianTicketDetailViewState createState() =>
      _TechnicianTicketDetailViewState();
}

class _TechnicianTicketDetailViewState
    extends State<TechnicianTicketDetailView> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MaintenanceTicket>(
      stream: _databaseService.getTicketStream(widget.ticket.ticketID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.popAndPushNamed(context, '/TicketListPage');
          });
          return Container();
        }

        if (!snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.popAndPushNamed(context, '/TicketListPage');
          });
          return Container();
        }

        final ticket = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Ticket Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              ]),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildInfoCard(
                      context,
                      'Title',
                      ticket.title,
                      Icons.title,
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              ticket.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                if (ticket.imageUrl.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenImageView(
                                          imageUrl: ticket.imageUrl),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[200],
                                  image: ticket.imageUrl.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(ticket.imageUrl),
                                          fit: BoxFit.cover,
                                        )
                                      : const DecorationImage(
                                          image: AssetImage(
                                              'assets/placeholder.png'),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoCard(
                      context,
                      'Requested By',
                      ticket.requestBy,
                      Icons.person,
                    ),
                    _buildInfoCard(
                      context,
                      'Priority',
                      ticket.priority,
                      Icons.priority_high,
                    ),
                    _buildInfoCard(
                      context,
                      'Problem Type',
                      ticket.problemType,
                      Icons.bug_report,
                    ),
                    _buildInfoCard(
                      context,
                      'Urgency',
                      ticket.urgency,
                      Icons.warning,
                    ),
                    _buildInfoCard(
                      context,
                      'Status',
                      ticket.status,
                      Icons.info,
                    ),
                    _buildInfoCard(
                      context,
                      'Location',
                      ticket.location,
                      Icons.location_on,
                    ),
                    _buildInfoCard(
                      context,
                      'Created At',
                      ticket.createdAt.toDate().toString(),
                      Icons.calendar_today,
                    ),
                    _buildInfoCard(
                      context,
                      'Updated At',
                      ticket.updatedAt.toDate().toString(),
                      Icons.update,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: ticket.ticketID,
                        width: 200,
                        height: 80,
                        drawText: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: MyButton(
                        text: 'Update',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TechnicianTicketDetail(ticket: ticket),
                            ),
                          );
                        },
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

  Widget _buildInfoCard(
      BuildContext context, String label, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.deepPurple,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
