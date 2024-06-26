
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flatter_app_android/domain/user.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<MyUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        return MyUser.fromFirebase(user);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<MyUser?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        return MyUser.fromFirebase(user);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<MyUser?> get currentUser {
    return _fAuth.authStateChanges().map((User? user) {
      return user != null ? MyUser.fromFirebase(user) : null;
    });
  }
}