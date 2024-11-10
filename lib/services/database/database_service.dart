// ignore_for_file: non_constant_identifier_names, avoid_print, body_might_complete_normally_nullable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/Models/user.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _Auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  //save user info
  Future<void> saveUserInfoInFirebase(
      {required String name,
      required String role,
      required String email}) async {
    String uid = _Auth.currentUser!.uid;

    String username = email.split('@')[0];

    UserProfile user = UserProfile(
        uid: uid,
        name: name,
        email: email,
        username: username,
        skill: '',
        role: role);

    final userMap = user.toMap();

    await _db.collection("Users").doc(uid).set(userMap);
  }

  //Get user info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot UserDoc = await _db.collection("Users").doc(uid).get();

      return UserProfile.fromdocument(UserDoc);
    } catch (e) {
      return null;
    }
  }
  //database service for crud operation
  //=============================================================================

  final CollectionReference ticketCollection =
      FirebaseFirestore.instance.collection('tickets');

  // 1. Create a new ticket
  Future<void> createTicket(MaintenanceTicket ticket) async {
    try {
      await ticketCollection.doc(ticket.ticketID).set(ticket.toMap());
    } catch (e) {
      throw Exception("Failed to create ticket: $e");
    }
  }

  // 2. Read tickets (stream of all tickets)
  Stream<List<MaintenanceTicket>> getTickets() {
    return ticketCollection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MaintenanceTicket.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // 2a. Read a single ticket by ID
  Future<MaintenanceTicket?> getTicketByID(String id) async {
    try {
      DocumentSnapshot doc = await ticketCollection.doc(id).get();
      if (doc.exists) {
        return MaintenanceTicket.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null; // Ticket does not exist
    } catch (e) {
      throw Exception("Failed to fetch ticket: $e");
    }
  }

  // 3. Update an existing ticket
  Future<void> updateTicket(MaintenanceTicket ticket) async {
    try {
      await ticketCollection.doc(ticket.ticketID).update(ticket.toMap());
    } catch (e) {
      throw Exception("Failed to update ticket: $e");
    }
  }

  Stream<MaintenanceTicket> getTicketStream(String ticketID) {
    return ticketCollection.doc(ticketID).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        return MaintenanceTicket.fromMap(
            data as Map<String, dynamic>, snapshot.id);
      } else {
        throw Exception("Ticket data not found");
      }
    });
  }

  // 4. Delete a ticket
  Future<void> deleteTicket(String id) async {
    try {
      await ticketCollection.doc(id).delete();
    } catch (e) {
      throw Exception("Failed to delete ticket: $e");
    }
  }

  //get the number of admin
  Future<int> countAdmins() async {
    QuerySnapshot snapshot =
        await _db.collection('Users').where('role', isEqualTo: 'Admin').get();
    return snapshot.docs.length;
  }

  /// fetch to the role of user
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('Users').doc(uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        return data['role'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //search the ticket
  Future<List<DocumentSnapshot>> searchTickets(String query) async {
    if (query.isEmpty) return [];
    try {
      QuerySnapshot snapshot = await _db
          .collection('tickets')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs;
    } catch (e) {
      return [];
    }
  }

  // Fetch tickets based on status
  Future<List<MaintenanceTicket>> fetchTicketsByStatus(String status) async {
    QuerySnapshot snapshot = await _db
        .collection('tickets') // Adjust the collection name as needed
        .where('status', isEqualTo: status)
        .get();

    return snapshot.docs.map((doc) {
      return MaintenanceTicket.fromMap(
          doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  //get list of app user
  Future<List<UserProfile>> getUsers() async {
    QuerySnapshot snapshot = await _db.collection('Users').get();
    return snapshot.docs.map((doc) => UserProfile.fromdocument(doc)).toList();
  }

  // Method to fetch technicians from Firestore
  Future<List<UserProfile>> getTechnicians() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('Users')
          .where('role', isEqualTo: 'Technician') // Filtering by role
          .get();

      return snapshot.docs.map((doc) => UserProfile.fromdocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  // Method to upload image to Firebase Storage and get download URL
  Future<String> uploadImage(File imageFile, String ticketID) async {
    try {
      Reference storageRef =
          _storage.ref().child('ticket_images/$ticketID.jpg');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask;

      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      rethrow;
    }
  }

  Stream<List<MaintenanceTicket>> getTechnicianTickets(String technicianName) {
    return _db
        .collection('tickets')
        .where('assignedTo', isEqualTo: technicianName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MaintenanceTicket.fromMap(doc.data(), doc.id))
            .toList());
  }
}
