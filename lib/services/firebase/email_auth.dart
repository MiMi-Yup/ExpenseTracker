import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  static Future<UserCredential?> createUserWithPassword(
      {required String email, required String password}) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential?> signInWithPassword(
      {required String email, required String password}) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
