import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  late String id;
  late String? email;

  MyUser.fromFirebase(User firebaseUser) {
    id = firebaseUser.uid;
    email = firebaseUser.email;
  }
}