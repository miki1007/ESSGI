import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/Models/user.dart';
import 'package:pro/component/my_button.dart';
import 'package:pro/services/Auth/auth_services.dart';
import 'package:pro/services/database/database_provider.dart';
import 'package:pro/services/database/database_service.dart';
import 'package:pro/services/image_picker.dart/piker.dart';
import 'package:provider/provider.dart';

class CreateTicketDialog extends StatefulWidget {
  final Function onTicketCreated;

  CreateTicketDialog({required this.onTicketCreated});

  @override
  _CreateTicketDialogState createState() => _CreateTicketDialogState();
}

class _CreateTicketDialogState extends State<CreateTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();
  File? _selectedImageFile;

  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(currentUserId);
  }

  // Ticket fields
  String _title = '';
  String _description = '';
  String _priority = 'Normal';
  String _problemType = 'General';
  String _urgency = 'Medium';
  String _location = '';
  String _assignedTo = '';

  String generateRandomNumericString(int length) {
    final Random random = Random();
    return List.generate(length, (_) => random.nextInt(10).toString()).join();
  }

  void _createTicket() async {
    String ticketID = generateRandomNumericString(10);

    if (_formKey.currentState!.validate()) {
      try {
        // Upload the image if one is selected and get the download URL
        String imageUrl = '';
        if (_selectedImageFile != null) {
          imageUrl =
              await _databaseService.uploadImage(_selectedImageFile!, ticketID);
        }

        // Create a new ticket object with the image URL
        MaintenanceTicket newTicket = MaintenanceTicket(
          ticketID: ticketID,
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
          requestBy: user!.name,
          imageUrl: imageUrl, // Set the image URL here
        );

        // Save the ticket to Firestore
        await _databaseService.createTicket(newTicket);
        widget.onTicketCreated(); // Trigger the callback
        Navigator.pop(context);
      } catch (e) {
        // Handle errors (show an error message or log it)
        print("Failed to create ticket: $e");
      }
    }
  }

  void _onImagePicked(File imageFile) {
    setState(() {
      _selectedImageFile = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Custom input decoration for borders
    final InputDecoration inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      labelStyle: TextStyle(color: Colors.grey[700]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
    );

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
                        decoration:
                            inputDecoration.copyWith(labelText: 'Title'),
                        onChanged: (value) => _title = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a title' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: inputDecoration.copyWith(
                          labelText: 'Description',
                          alignLabelWithHint: true,
                        ),
                        onChanged: (value) => _description = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a description' : null,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration:
                            inputDecoration.copyWith(labelText: 'Location'),
                        onChanged: (value) => _location = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a location' : null,
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
                            inputDecoration.copyWith(labelText: 'Priority'),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _problemType,
                        items: ['General', 'Software', 'Hardware']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _problemType = value!),
                        decoration:
                            inputDecoration.copyWith(labelText: 'Problem Type'),
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
                        decoration:
                            inputDecoration.copyWith(labelText: 'Urgency'),
                      ),
                      const SizedBox(height: 20),
                      // Image Picker Widget
                      ImagePickerWidget(onImagePicked: _onImagePicked),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      text: 'Cancel',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    MyButton(
                      text: 'Create Ticket',
                      onTap: () {
                        _createTicket();
                        Navigator.pop(context);
                      },
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
