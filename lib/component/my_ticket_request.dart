import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/services/database/database_service.dart';

class CreateTicketDialog extends StatefulWidget {
  final Function onTicketCreated;

  CreateTicketDialog({required this.onTicketCreated});

  @override
  _CreateTicketDialogState createState() => _CreateTicketDialogState();
}

class _CreateTicketDialogState extends State<CreateTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();
  final ImagePicker _picker = ImagePicker();

  // Ticket fields
  String _title = '';
  String _description = '';
  String _priority = 'Normal';
  String _problemType = 'General';
  String _urgency = 'Medium';
  String _location = '';
  String _imageUrl = '';
  File? _selectedImage; // Holds the selected image file

  String generateRandomNumericString(int length) {
    final Random random = Random();
    return List.generate(length, (_) => random.nextInt(10).toString()).join();
  }

  Future<void> pickImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null && mounted) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                  if (mounted) Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null && mounted) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                  if (mounted) Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> createTicket() async {
    if (_formKey.currentState!.validate()) {
      String id = generateRandomNumericString(10);

      // Upload the image to Firestore if selected
      if (_selectedImage != null) {
        _imageUrl = await _databaseService.uploadImage(_selectedImage!);
      }

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
        location: _location,
        requestBy: 'User',
        imageUrl: _imageUrl,
        assignedTo: '',
      );

      await _databaseService.createTicket(newTicket);
      widget.onTicketCreated();
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
                      const SizedBox(height: 20),
                      // Image Picker and Preview
                      _selectedImage != null
                          ? Image.file(_selectedImage!, height: 100)
                          : const Text("No image selected"),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: pickImage,
                        child: const Text("Pick Image"),
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
                      onPressed: createTicket,
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
