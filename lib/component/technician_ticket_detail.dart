// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/my_button.dart';
import 'package:pro/services/database/database_service.dart';

class TechnicianTicketDetail extends StatefulWidget {
  final MaintenanceTicket ticket;

  const TechnicianTicketDetail({super.key, required this.ticket});

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

    _status =
        widget.ticket.status.isNotEmpty ? widget.ticket.status : 'Pending';
    if (!['Pending', 'In Progress', 'Completed'].contains(_status)) {
      _status = 'Pending';
    }

    _descriptionController =
        TextEditingController(text: widget.ticket.description);
    _solutionStepsController =
        TextEditingController(text: widget.ticket.solutionSteps ?? '');
    _pdfUrl = widget.ticket.solutionPdfUrl;
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

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PDF uploaded successfully')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No file selected')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error occurred while picking/uploading file: $e')),
      );
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
        solutionPdfUrl: _pdfUrl,
      );

      await _databaseService.updateTicket(updatedTicket);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket updated successfully')),
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
            _buildSectionHeader(
                context, 'Ticket Description', Icons.description),
            _buildDescriptionCard(),
            const SizedBox(height: 20),
            _buildSectionHeader(context, 'Solution Steps', Icons.list_alt),
            _buildTextField(_solutionStepsController, 'Solution Steps', 5),
            const SizedBox(height: 20),
            _buildSectionHeader(context, 'Solution PDF', Icons.picture_as_pdf),
            const SizedBox(height: 10),
            MyButton(text: 'Upload File', onTap: _pickAndUploadPdf),
            const SizedBox(height: 20),
            _buildStatusDropdown(),
            const SizedBox(height: 30),
            MyButton(text: 'Save Updates', onTap: _saveUpdates),
          ],
        ),
      ),
    );
  }

  // Widget for section header with icon
  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.inversePrimary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ],
    );
  }

  // Widget for read-only description in a card-like view
  Widget _buildDescriptionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _descriptionController.text,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  // Widget for text field with rounded borders and subtle shadow
  Widget _buildTextField(
      TextEditingController controller, String label, int maxLines) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Widget for status dropdown with custom styling
  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
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
          border: InputBorder.none,
        ),
      ),
    );
  }
}
