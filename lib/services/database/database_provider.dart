// ignore_for_file: unused_field, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:pro/Models/user.dart';
import 'package:pro/services/Auth/auth_services.dart';
import 'package:pro/services/database/database_service.dart';


class DatabaseProvider extends ChangeNotifier {
  /*
  SERVICES
  */
  //get the db & Auth service
  final _Auth = AuthService();
  final _db = DatabaseService();

  //get user profile with given uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);
}
