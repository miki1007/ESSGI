// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

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

  List<UserProfile> _technicians = []; // List to hold technicians
  bool _isLoading = true; // Loading state
  String? _assignedTo; // Selected technician

  @override
  void initState() {
    super.initState();
    fetchTechnicians(); // Fetch technicians when the widget is initialized
    _assignedTo = widget
        .ticket.assignedTo; // Initialize with the current assigned technician
  }

  Future<void> fetchTechnicians() async {
    _technicians = await _databaseService.getTechnicians();
    if (mounted) {
      // Check if the widget is still mounted
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

      // Create a new ticket object with the updated assignedTo field
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
        location: widget.ticket.location, // Updated technician name
      );

      // Update the ticket in the database
      await _databaseService.updateTicket(updatedTicket);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Assigned technician updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update assigned technician: $error')),
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
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: AppBar(
            title: Text(ticket.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showUpdateDialog(context),
              ),
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
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Center(
                      child: Text(
                        'Title : ${ticket.title}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        ticket.description,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                        ),
                      ),
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
                          height:
                              250, // Standard height for social media-style views
                          margin: const EdgeInsets.symmetric(vertical: 10),
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
                                        'assets/placeholder.png'), // Provide a local placeholder image
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Requested By: ${ticket.requestBy}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Priority: ${ticket.priority}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Problem Type: ${ticket.problemType}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Urgency: ${ticket.urgency}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${ticket.status}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Location: ${ticket.location}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created At: ${ticket.createdAt.toDate()}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Updated At: ${ticket.updatedAt.toDate()}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Assigned To: ${_assignedTo ?? "None"}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.yellow[400],
                        )
                      : DropdownButtonFormField<String>(
                          value: _technicians.any((technician) =>
                                  technician.name == _assignedTo)
                              ? _assignedTo
                              : null,
                          items: _technicians.map((technician) {
                            return DropdownMenuItem<String>(
                              value: technician.name,
                              child: Text(technician.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _updateAssignedTechnician(value);
                            }
                          },
                          decoration:
                              const InputDecoration(labelText: 'Assigned To'),
                          hint: const Text('Select Technician'),
                        ),
                  const SizedBox(height: 40),
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
}
