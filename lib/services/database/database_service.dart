// ignore_for_file: non_constant_identifier_names, avoid_print, body_might_complete_normally_nullable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pro/Models/ticket_request.dart';
import 'package:pro/Models/user.dart';

class DatabaseService {
  //get the instance of firestore db and Auth
  final _db = FirebaseFirestore.instance;
  final _Auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;

  //save user info
  Future<void> saveUserInfoInFirebase(
      {required String name,
      required String role,
      required String email}) async {
    //get the current uid
    String uid = _Auth.currentUser!.uid;
    //Extract the username from the email
    String username = email.split('@')[0];
    //create user profile
    UserProfile user = UserProfile(
        uid: uid,
        name: name,
        email: email,
        username: username,
        skill: '',
        role: role);
    //convert user user into a map
    final userMap = user.toMap();
    //save user info to the firebase
    await _db.collection("Users").doc(uid).set(userMap);
  }

  //Get user info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      //retrieve the user doc from the firebase
      DocumentSnapshot UserDoc = await _db.collection("Users").doc(uid).get();
      //Convert doc to the user profile
      return UserProfile.fromdocument(UserDoc);
    } catch (e) {
      print(e);
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
      // Retrieve the document for the user with the given UID
      DocumentSnapshot snapshot = await _db.collection('Users').doc(uid).get();

      // Check if the document exists and retrieve the 'role' field
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        print("data:$data");
        return data['role'] as String?;
      } else {
        print("User document not found or has no data for UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error retrieving user role: $e");
      return null;
    }
  }

  //search the ticket
  Future<List<DocumentSnapshot>> searchTickets(String query) async {
    if (query.isEmpty) return []; // Return empty list if query is empty

    try {
      // Adjust the collection name as per your Firestore structure
      QuerySnapshot snapshot = await _db
          .collection(
              'tickets') // Replace 'tickets' with your actual collection name
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      return snapshot.docs; // Return the list of documents found
    } catch (e) {
      print("Error searching tickets: $e");
      return []; // Return an empty list in case of error
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

  // Method to get the list of technician IDs (assuming technicians are stored in a "technicians" collection)
  Stream<List<String>> getTechnicianIds() {
    return _db.collection('technicians').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<List<MaintenanceTicket>> fetchTicketsByTechnician(
      String assignedTo) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('tickets')
          .where('assignedTo', isEqualTo: assignedTo)
          .get();

      return snapshot.docs.map((doc) {
        return MaintenanceTicket.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  //function to delete the user in the firestore database and in the authservice

  Future<void> deleteUserAccount() async {
    try {
      // Get the current user
      User? user = _Auth.currentUser;

      if (user != null) {
        await _db.collection('Users').doc(user.uid).delete();

        await user.delete();
      }
    } catch (e) {
      throw Exception("Failed to delete account. Please try again.");
    }
  }

//method to upload the image to the firebase
  Future<String> uploadImage(File image) async {
    String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref = _storage.ref().child(fileName);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  // Method to assign a ticket to a technician
  Future<void> assignTicketToTechnician(
      String ticketId, String technicianId) async {
    try {
      await _db.collection('tickets').doc(ticketId).update({
        'assignedTo': technicianId,
        'status': 'Assigned',
      });
    } catch (e) {
      throw Exception("Failed to assign ticket: $e");
    }
  }
}
