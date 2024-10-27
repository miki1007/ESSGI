import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/services/database/database_service.dart';
import 'package:random_string/random_string.dart';

class CreateTicketDialog extends StatefulWidget {
  final Function() onTicketCreated; // Callback function to refresh ticket list

  CreateTicketDialog({required this.onTicketCreated});

  @override
  _CreateTicketDialogState createState() => _CreateTicketDialogState();
}

class _CreateTicketDialogState extends State<CreateTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();

  // Ticket fields
  String _title = '';
  String _description = '';
  String _priority = 'Normal';
  String _problemType = 'General';
  String _urgency = 'Medium';
  String _location = '';
  String _assignedTo = ''; // This can be updated based on your logic
  String _imageUrl = ''; // Set this based on your image upload logic

  // Create a new ticket
  void _createTicket() async {
    String id = randomAlphaNumeric(10);
    if (_formKey.currentState!.validate()) {
      MaintenanceTicket newTicket = MaintenanceTicket(
        ticketID: id, // Unique ID
        title: _title,
        description: _description,
        priority: _priority,
        problemType: _problemType,
        urgency: _urgency,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        status: 'Pending',
        assignedTo: _assignedTo,
        location: _location,
        requestBy: 'User', // Update based on your user logic
        imageUrl: _imageUrl, // Set based on your logic
      );

      await _databaseService.createTicket(newTicket);

      Navigator.pop(context); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400, // Set maximum width
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Create Ticket',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Title'),
                        onChanged: (value) => _title = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a title' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        onChanged: (value) => _description = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a description' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Location'),
                        onChanged: (value) => _location = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a location' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Assigned To'),
                        onChanged: (value) => _assignedTo = value,
                        validator: (value) => value!.isEmpty
                            ? 'Enter a person to assign to'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _priority,
                        items: ['Normal', 'High', 'Low']
                            .map((priority) => DropdownMenuItem(
                                  value: priority,
                                  child: Text(priority),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _priority = value!),
                        decoration:
                            const InputDecoration(labelText: 'Priority'),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _problemType,
                        items: ['General', 'Electrical', 'Plumbing']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _problemType = value!),
                        decoration:
                            const InputDecoration(labelText: 'Problem Type'),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _urgency,
                        items: ['Medium', 'High', 'Low']
                            .map((urgency) => DropdownMenuItem(
                                  value: urgency,
                                  child: Text(urgency),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _urgency = value!),
                        decoration: const InputDecoration(labelText: 'Urgency'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Close dialog
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _createTicket,
                      child: const Text('Create Ticket'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
