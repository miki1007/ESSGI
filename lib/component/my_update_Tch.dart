import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';

class UpdateTicketDialogTch extends StatefulWidget {
  final MaintenanceTicket ticket;
  final Function(MaintenanceTicket) onUpdate;

  const UpdateTicketDialogTch({
    Key? key,
    required this.ticket,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _UpdateTicketDialogTchState createState() => _UpdateTicketDialogTchState();
}

class _UpdateTicketDialogTchState extends State<UpdateTicketDialogTch> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown for status options
  final List<String> statusOptions = ['Open', 'In Progress', 'Completed'];
  String? status; // Nullable status for dropdown selection

  @override
  void initState() {
    super.initState();

    // Initialize status with the ticket's current status or default to the first option
    status = statusOptions.contains(widget.ticket.status)
        ? widget.ticket.status
        : statusOptions.first;
  }

  void updateTicketStatus() {
    if (_formKey.currentState!.validate()) {
      // Create an updated ticket object with only the modified status
      final updatedTicket = MaintenanceTicket(
        ticketID: widget.ticket.ticketID,
        title: widget.ticket.title, // Keep existing title
        description: widget.ticket.description, // Keep existing description
        priority: widget.ticket.priority, // Keep existing priority
        urgency: widget.ticket.urgency, // Keep existing urgency
        location: widget.ticket.location, // Keep existing location
        assignedTo: widget.ticket.assignedTo, // Keep existing assignment
        createdAt: widget.ticket.createdAt, // Keep existing creation date
        updatedAt: Timestamp.now(), // Update the timestamp to now
        status: status ?? 'Open', // Use the new status or default to 'Open'
        problemType: widget.ticket.problemType, // Keep existing problem type
        requestBy: widget.ticket.requestBy, // Keep existing requestBy
        imageUrl: widget.ticket.imageUrl, // Keep existing imageUrl
      );

      widget.onUpdate(updatedTicket); // Call the update function
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Ticket Status'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dropdown for updating the ticket status
            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  status = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: updateTicketStatus,
          child: const Text('Update'),
        ),
      ],
    );
  }
}
