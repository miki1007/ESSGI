// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:pro/Models/ticket_request.dart';

// class UpdateTicketDialog extends StatefulWidget {
//   final MaintenanceTicket ticket;
//   final Function(MaintenanceTicket) onUpdate;

//   const UpdateTicketDialog({
//     Key? key,
//     required this.ticket,
//     required this.onUpdate,
//   }) : super(key: key);

//   @override
//   _UpdateTicketDialogState createState() => _UpdateTicketDialogState();
// }

// class _UpdateTicketDialogState extends State<UpdateTicketDialog> {
//   final _formKey = GlobalKey<FormState>();
//   late String title;
//   late String description;
//   String? selectedPriority;
//   String? selectedUrgency;

//   // Define options for dropdowns
//   final List<String> priorityOptions = ['Low', 'Medium', 'High'];
//   final List<String> urgencyOptions = ['Low', 'Medium', 'High'];

//   @override
//   void initState() {
//     super.initState();
//     title = widget.ticket.title;
//     description = widget.ticket.description;

//     // Check if the initial priority and urgency values are valid
//     selectedPriority = priorityOptions.contains(widget.ticket.priority)
//         ? widget.ticket.priority
//         : priorityOptions.first; // Set to the first option as fallback

//     selectedUrgency = urgencyOptions.contains(widget.ticket.urgency)
//         ? widget.ticket.urgency
//         : urgencyOptions.first; // Set to the first option as fallback
//   }

//   void updateTicket() {
//     if (_formKey.currentState!.validate()) {
//       final updatedTicket = MaintenanceTicket(
//         ticketID: widget.ticket.ticketID,
//         title: title,
//         description: description,
//         priority: selectedPriority ?? '', // Ensure non-null value
//         urgency: selectedUrgency ?? '', // Ensure non-null value
//         assignedTo: widget.ticket.assignedTo,
//         createdAt: widget.ticket.createdAt,
//         updatedAt: Timestamp.now(), // Update the timestamp
//         status: widget.ticket.status,
//         problemType: widget.ticket.problemType,
//         requestBy: widget.ticket.requestBy,
//         imageUrl: widget.ticket.imageUrl,
//         location: widget.ticket.location,
//       );

//       widget.onUpdate(updatedTicket);
//       Navigator.of(context).pop(); // Close the dialog
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Update Ticket error'),
//       content: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               initialValue: title,
//               decoration: InputDecoration(labelText: 'Title'),
//               onChanged: (value) => title = value,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a title';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               initialValue: description,
//               decoration: InputDecoration(labelText: 'Description'),
//               onChanged: (value) => description = value,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a description';
//                 }
//                 return null;
//               },
//             ),
//             DropdownButtonFormField<String>(
//               value: selectedPriority,
//               decoration: InputDecoration(labelText: 'Priority'),
//               items: priorityOptions.map((String priority) {
//                 return DropdownMenuItem<String>(
//                   value: priority,
//                   child: Text(priority),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedPriority = value; // Update selected priority
//                 });
//               },
//               validator: (value) {
//                 if (value == null) {
//                   return 'Please select a priority';
//                 }
//                 return null;
//               },
//             ),
//             DropdownButtonFormField<String>(
//               value: selectedUrgency,
//               decoration: InputDecoration(labelText: 'Urgency'),
//               items: urgencyOptions.map((String urgency) {
//                 return DropdownMenuItem<String>(
//                   value: urgency,
//                   child: Text(urgency),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedUrgency = value; // Update selected urgency
//                 });
//               },
//               validator: (value) {
//                 if (value == null) {
//                   return 'Please select an urgency level';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: updateTicket,
//           child: Text('Update'),
//         ),
//       ],
//     );
//   }
// }
