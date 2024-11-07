import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/services/database/database_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TechnicianTicketDetail extends StatefulWidget {
  final MaintenanceTicket ticket;

  TechnicianTicketDetail({required this.ticket});

  @override
  _TechnicianTicketDetailState createState() => _TechnicianTicketDetailState();
}

class _TechnicianTicketDetailState extends State<TechnicianTicketDetail> {
  final DatabaseService _databaseService = DatabaseService();

  late final TextEditingController _descriptionController;
  late final TextEditingController _solutionStepsController;
  String _status = '';
  String? _pdfUrl;

  @override
  void initState() {
    super.initState();
    _status = widget.ticket.status;
    _descriptionController =
        TextEditingController(text: widget.ticket.description);
    _solutionStepsController =
        TextEditingController(text: widget.ticket.solutionSteps ?? '');
    _pdfUrl =
        widget.ticket.solutionPdfUrl; // Load existing PDF URL if available
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _solutionStepsController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'ppt'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;

        final storageRef =
            FirebaseStorage.instance.ref().child('solutionsPDF/$fileName');
        final uploadTask = storageRef.putFile(File(filePath));
        final downloadUrl = await (await uploadTask).ref.getDownloadURL();

        setState(() {
          _pdfUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('PDF uploaded successfully')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No file selected')));
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error occurred while picking/uploading file: $e')),
      );
    }
  }

  //method to view the upload file
  Future<void> _launchPdfUrl() async {
    if (_pdfUrl != null) {
      final Uri pdfUri = Uri.parse(_pdfUrl!);

      if (await canLaunchUrl(pdfUri)) {
        await launchUrl(pdfUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch PDF URL')),
        );
      }
    }
  }

  Future<void> _saveUpdates() async {
    try {
      final updatedTicket = MaintenanceTicket(
        ticketID: widget.ticket.ticketID,
        title: widget.ticket.title,
        description: _descriptionController.text,
        priority: widget.ticket.priority,
        problemType: widget.ticket.problemType,
        urgency: widget.ticket.urgency,
        status: _status,
        createdAt: widget.ticket.createdAt,
        updatedAt: Timestamp.now(),
        assignedTo: widget.ticket.assignedTo,
        requestBy: widget.ticket.requestBy,
        imageUrl: widget.ticket.imageUrl,
        location: widget.ticket.location,
        solutionDescription: _descriptionController.text,
        solutionSteps: _solutionStepsController.text,
        solutionPdfUrl: _pdfUrl, // Save PDF URL
      );

      await _databaseService.updateTicket(updatedTicket);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update ticket: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: Text(widget.ticket.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Solution Steps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _solutionStepsController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Solution Steps',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Solution PDF',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickAndUploadPdf,
              child: const Text('Upload File'),
            ),
            if (_pdfUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {
                    // Optionally, you could use a package like url_launcher to open the PDF link
                  },
                  child: const Text(
                    'View File',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _status,
              items: ['Pending', 'In Progress', 'Completed'].map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (newStatus) {
                setState(() {
                  _status = newStatus!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Status',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveUpdates,
              child: const Text('Save Updates'),
            ),
          ],
        ),
      ),
    );
  }
}
