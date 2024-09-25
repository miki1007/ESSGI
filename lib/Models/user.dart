// ignore_for_file: non_constant_identifier_names

/*
 
 USER PROFILE

 this is what the user profile should have in their profile
 __________________________________________________________________________________

 -uid
 -name
 -email
 -Username
 -Profile photo
 -bio

 */
// lets create the user profile class model
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;

  UserProfile(
      {required this.uid,
      required this.name,
      required this.email,
      required this.username,
      required this.bio});
  /* firebase -> app
     Convert firestore Document to user Profile(so that we can use in our app)
  */
  factory UserProfile.fromdocument(DocumentSnapshot Doc) {
    return UserProfile(
        uid: Doc["uid"],
        name: Doc["name"],
        email: Doc["email"],
        username: Doc["username"],
        bio: Doc["bio"]);
  }
  /*
  app -> firebase
  Convert UserProfile To Map(so that we can store in firebase)
  */
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'bio': bio
    };
  }
}
