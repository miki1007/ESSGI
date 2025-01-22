// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/services/database/database_service.dart';
import 'package:pro/services/image_picker.dart/full_image_view.dart';

class TechnicianReference extends StatefulWidget {
  final MaintenanceTicket ticket;

  const TechnicianReference({super.key, required this.ticket});

  @override
  _TechnicianReferenceState createState() => _TechnicianReferenceState();
}

class _TechnicianReferenceState extends State<TechnicianReference> {
  final DatabaseService _databaseService = DatabaseService();

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
            title: Center(child: Text('Title  ${ticket.title}')),
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
                    child: Container(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      child: Text(
                        textAlign: TextAlign.start,
                        'Title : ${ticket.title}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.all(5),
                        elevation: 5, // Adjust the elevation as needed
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              ticket.description,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
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
                          height: 250,
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
                                    image: AssetImage('assets/placeholder.png'),
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Priority: ${ticket.priority}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Problem Type: ${ticket.problemType}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Urgency: ${ticket.urgency}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${ticket.status}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Location: ${ticket.location}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created At: ${ticket.createdAt.toDate()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Updated At: ${ticket.updatedAt.toDate()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
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
