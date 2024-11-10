// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';

class UpdateTicketDialog extends StatefulWidget {
  final MaintenanceTicket ticket;
  final Function(MaintenanceTicket) onUpdate;

  const UpdateTicketDialog({
    Key? key,
    required this.ticket,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _UpdateTicketDialogState createState() => _UpdateTicketDialogState();
}

class _UpdateTicketDialogState extends State<UpdateTicketDialog> {
  final _formKey = GlobalKey<FormState>();

  // Fields for each property
  late String title;
  late String description;
  String? selectedPriority;
  String? selectedUrgency;
  late String location;
  late String assignedTo;
  String? selectedProblemType; // Change this to use for dropdown
  String? status; // Now nullable

  // Dropdown options
  final List<String> priorityOptions = ['Low', 'Medium', 'High'];
  final List<String> urgencyOptions = ['Low', 'Medium', 'High'];
  final List<String> statusOptions = ['Open', 'In Progress', 'Completed'];
  final List<String> problemTypeOptions = [
    'General',
    'Software',
    'Hardware',
  ];

  @override
  void initState() {
    super.initState();
    title = widget.ticket.title;
    description = widget.ticket.description;

    // Use fallback values if the ticket values are not in the dropdown options
    selectedPriority = priorityOptions.contains(widget.ticket.priority)
        ? widget.ticket.priority
        : priorityOptions.first;

    selectedUrgency = urgencyOptions.contains(widget.ticket.urgency)
        ? widget.ticket.urgency
        : urgencyOptions.first;

    location = widget.ticket.location;
    assignedTo = widget.ticket.assignedTo;

    // Similar check for status
    status = statusOptions.contains(widget.ticket.status)
        ? widget.ticket.status
        : statusOptions.first;

    // Set selectedProblemType from ticket or default to first option
    selectedProblemType = problemTypeOptions.contains(widget.ticket.problemType)
        ? widget.ticket.problemType
        : problemTypeOptions.first;
  }

  void updateTicket() {
    if (_formKey.currentState!.validate()) {
      final updatedTicket = MaintenanceTicket(
        ticketID: widget.ticket.ticketID,
        title: title,
        description: description,
        priority: selectedPriority ?? '',
        urgency: selectedUrgency ?? '',
        location: location,
        assignedTo: assignedTo,
        createdAt: widget.ticket.createdAt,
        updatedAt: Timestamp.now(),
        status: status ?? 'Open',
        problemType: selectedProblemType ?? '',
        requestBy: widget.ticket.requestBy,
        imageUrl: widget.ticket.imageUrl,
      );

      widget.onUpdate(updatedTicket);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Ticket'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: priorityOptions.map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a priority';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedUrgency,
                decoration: const InputDecoration(labelText: 'Urgency'),
                items: urgencyOptions.map((String urgency) {
                  return DropdownMenuItem<String>(
                    value: urgency,
                    child: Text(urgency),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUrgency = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an urgency level';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: location,
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (value) => location = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),

              // Dropdown for problem type
              DropdownButtonFormField<String>(
                value: selectedProblemType,
                decoration: const InputDecoration(labelText: 'Problem Type'),
                items: problemTypeOptions.map((String problemType) {
                  return DropdownMenuItem<String>(
                    value: problemType,
                    child: Text(problemType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProblemType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a problem type';
                  }
                  return null;
                },
              ),
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
                    status = value!;
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: updateTicket,
          child: const Text('Update'),
        ),
      ],
    );
  }
}
