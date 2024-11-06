import 'package:flutter/material.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/component/my_ticket_detail.dart';

class TicketCard extends StatelessWidget {
  final MaintenanceTicket ticket;

  const TicketCard({super.key, required this.ticket});

  // Function to get the appropriate icon and color for the status
  Widget _getStatusIcon() {
    switch (ticket.status) {
      case 'Pending':
        return Icon(
          Icons.hourglass_top,
          color: Colors.orangeAccent,
          size: 20,
        );
      case 'In Progress':
        return Icon(
          Icons.work_outline,
          color: Colors.blueAccent,
          size: 20,
        );
      case 'Completed':
        return Icon(
          Icons.check_circle_outline,
          color: Colors.greenAccent,
          size: 20,
        );
      default:
        return Icon(
          Icons.info_outline,
          color: Colors.grey,
          size: 20,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
            Theme.of(context).colorScheme.secondary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Ticket ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    ticket.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  'ID: ${ticket.ticketID}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Urgency
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orangeAccent,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  'Urgency: ${ticket.urgency}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Assigned To
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  'Assigned To: ${ticket.assignedTo}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Status with dynamic icon and color
            Row(
              children: [
                _getStatusIcon(),
                const SizedBox(width: 5),
                Text(
                  'Status: ${ticket.status}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Read More Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: Icon(
                    Icons.read_more,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  label: const Text(
                    "Read More",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    // Navigate to ticket detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketDetailPage(ticket: ticket),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
