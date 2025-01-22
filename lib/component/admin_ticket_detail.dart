import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/Models/user.dart';
import 'package:pro/component/my_update.dart';
import 'package:pro/services/database/database_service.dart';
import 'package:pro/services/image_picker.dart/full_image_view.dart';

class AdminTicketDetail extends StatefulWidget {
  final MaintenanceTicket ticket;

  const AdminTicketDetail({super.key, required this.ticket});

  @override
  _AdminTicketDetailState createState() => _AdminTicketDetailState();
}

class _AdminTicketDetailState extends State<AdminTicketDetail> {
  final DatabaseService _databaseService = DatabaseService();
  List<UserProfile> _technicians = [];
  bool _isLoading = true;
  String? _assignedTo;

  @override
  void initState() {
    super.initState();
    fetchTechnicians();
    _assignedTo = widget.ticket.assignedTo;
  }

  Future<void> fetchTechnicians() async {
    _technicians = await _databaseService.getTechnicians();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteTicket(BuildContext context) async {
    await _databaseService.deleteTicket(widget.ticket.ticketID);
    if (context.mounted) {
      Navigator.popAndPushNamed(context, '/TicketListPage');
    }
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => UpdateTicketDialog(
        ticket: widget.ticket,
        onUpdate: (updatedTicket) async {
          await _databaseService.updateTicket(updatedTicket);
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext);
          }
        },
      ),
    );
  }

  Future<void> _updateAssignedTechnician(String technicianName) async {
    try {
      setState(() {
        _assignedTo = technicianName;
      });

      final updatedTicket = MaintenanceTicket(
        ticketID: widget.ticket.ticketID,
        title: widget.ticket.title,
        description: widget.ticket.description,
        priority: widget.ticket.priority,
        problemType: widget.ticket.problemType,
        urgency: widget.ticket.urgency,
        status: widget.ticket.status,
        createdAt: widget.ticket.createdAt,
        updatedAt: Timestamp.now(),
        assignedTo: technicianName,
        requestBy: '',
        imageUrl: widget.ticket.imageUrl,
        location: widget.ticket.location,
      );

      await _databaseService.updateTicket(updatedTicket);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assigned technician updated successfully'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update assigned technician: $error'),
        ),
      );
    }
  }

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

        if (snapshot.hasError || !snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.popAndPushNamed(context, '/TicketListPage');
          });
          return Container();
        }

        final ticket = snapshot.data!;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: AppBar(
            title: Text(ticket.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Ticket'),
                      content: const Text(
                          'Are you sure you want to delete this ticket?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteTicket(context);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ticket Title
                  _buildSectionCard(
                    title: 'Title',
                    content: ticket.title,
                    icon: Icons.title,
                    fontSize: 24,
                  ),
                  const SizedBox(height: 20),

                  // Description
                  _buildSectionCard(
                    title: 'Description',
                    content: ticket.description,
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 20),

                  // Ticket Image
                  GestureDetector(
                    onTap: () {
                      if (ticket.imageUrl.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImageView(
                              imageUrl: ticket.imageUrl,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
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
                                image: AssetImage('assets/img/about.png'),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Information Sections
                  _buildInfoRow(context, 'Requested By', ticket.requestBy),
                  _buildInfoRow(context, 'Priority', ticket.priority),
                  _buildInfoRow(context, 'Problem Type', ticket.problemType),
                  _buildInfoRow(context, 'Urgency', ticket.urgency),
                  _buildInfoRow(context, 'Status', ticket.status),
                  _buildInfoRow(context, 'Location', ticket.location),
                  _buildInfoRow(
                    context,
                    'Created At',
                    ticket.createdAt.toDate().toString(),
                  ),
                  _buildInfoRow(
                    context,
                    'Updated At',
                    ticket.updatedAt.toDate().toString(),
                  ),

                  const SizedBox(height: 20),
                  _buildInfoRow(context, 'Assigned To', _assignedTo ?? 'None',
                      icon: Icons.person),

                  const SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.yellow[400],
                        )
                      : DropdownButtonFormField<String>(
                          value: _technicians
                                  .any((tech) => tech.name == _assignedTo)
                              ? _assignedTo
                              : null,
                          items: _technicians.map((tech) {
                            return DropdownMenuItem<String>(
                              value: tech.name,
                              child: Text(tech.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _updateAssignedTechnician(value);
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Assign Technician',
                            border: OutlineInputBorder(),
                          ),
                          hint: const Text('Select Technician'),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
    double fontSize = 18,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.teal),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
