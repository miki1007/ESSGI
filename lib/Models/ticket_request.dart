import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceTicket {
  final String ticketID;
  final String title;
  final String description;
  final String problemType;
  final String urgency;
  final String priority;
  final String status;
  final String requestBy;
  final String assignedTo;
  final String imageUrl;
  final String location;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  MaintenanceTicket({
    required this.ticketID,
    required this.title,
    required this.description,
    required this.problemType,
    required this.urgency,
    required this.priority,
    required this.status,
    required this.requestBy,
    required this.assignedTo,
    required this.imageUrl,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert the MaintenanceTicket object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'ticketID': ticketID,
      'title': title,
      'description': description,
      'problemType': problemType,
      'urgency': urgency,
      'priority': priority,
      'status': status,
      'requestBy': requestBy,
      'assignedTo': assignedTo,
      'imageUrl': imageUrl,
      'location': location,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Create a MaintenanceTicket object from a map
  factory MaintenanceTicket.fromMap(Map<String, dynamic> map, String id) {
    return MaintenanceTicket(
      ticketID: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      problemType: map['problemType'] ?? '',
      urgency: map['urgency'] ?? '',
      priority: map['priority'] ?? '',
      status: map['status'] ?? '',
      requestBy: map['requestBy'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      location: map['location'] ?? '',
      createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: map['updatedAt'] as Timestamp? ?? Timestamp.now(),
    );
  }
}
