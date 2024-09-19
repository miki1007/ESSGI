// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pro/Models/user.dart';
/*
  DATABASE SERVICE
  this class handle all the data from and on the firebase
  _______________________________________________________________
  -user profile
  -post message
  -like
  -comment
  -account staff(report/delete account and block)
  -follow unfollow
  -search user
 */

class DatabaseService {
  //get the instance of firestore db and Auth
  final _db = FirebaseFirestore.instance;
  final _Auth = FirebaseAuth.instance;

  /*
  USER PROFILE
  when the user register the we can create an account so lates also store
  their details in the databse to display their profile page
  */
  //save user info
  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    //get the current uid
    String uid = _Auth.currentUser!.uid;
    //Extract the username from the email
    String username = email.split('@')[0];
    //create user profile
    UserProfile user = UserProfile(
        uid: uid, name: name, email: email, username: username, bio: '');
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

  /*
  USER MESSAGE
  
  */
  /*
  LIKE
  
  */
  /*
  COMMENTS 
  
  */
  /*
  ACCOUNT STAFF
  
  */
  /*
  FOLLOW
  
  */
}
