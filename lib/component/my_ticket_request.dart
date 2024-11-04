import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/Models/user.dart';
import 'package:pro/services/database/database_service.dart';
// Import your UserProfile model

class CreateTicketDialog extends StatefulWidget {
  final Function onTicketCreated;

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
  String _assignedTo = '';
  String _imageUrl = '';
  List<UserProfile> _technicians = []; // List to hold technicians
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchTechnicians(); // Fetch technicians when dialog is opened
  }

  Future<void> fetchTechnicians() async {
    _technicians = await _databaseService.getTechnicians();
    setState(() {
      _isLoading = false; // Set loading to false after fetching
    });
  }

  String generateRandomNumericString(int length) {
    final Random random = Random();
    return List.generate(length, (_) => random.nextInt(10).toString()).join();
  }

  void createTicket() async {
    String id = generateRandomNumericString(10);

    if (_formKey.currentState!.validate()) {
      MaintenanceTicket newTicket = MaintenanceTicket(
        ticketID: id,
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
        requestBy: 'User',
        imageUrl: _imageUrl,
      );

      await _databaseService.createTicket(newTicket);
      widget.onTicketCreated(); // Trigger the callback
      Navigator.pop(context);
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
            constraints: BoxConstraints(maxWidth: 400),
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
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                      // Dropdown for selecting Technician
                      _isLoading
                          ? CircularProgressIndicator() // Show loading indicator
                          : DropdownButtonFormField<String>(
                              value:
                                  _assignedTo.isNotEmpty ? _assignedTo : null,
                              items: _technicians.map((technician) {
                                return DropdownMenuItem<String>(
                                  value:
                                      technician.name, // Use uid as the value
                                  child: Text(technician.name), // Display name
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _assignedTo = value!; // Update assignedTo
                                });
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Assigned To'),
                              hint:
                                  const Text('Select Technician'), // Hint text
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: createTicket, // Call the internal method
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
