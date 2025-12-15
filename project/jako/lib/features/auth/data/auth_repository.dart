import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithGoogle() async {
    final auth = FirebaseAuth.instance;
    final googleProvider = GoogleAuthProvider();

    if (kIsWeb) {
      await auth.signInWithPopup(googleProvider);
    } else {
      await auth.signInWithProvider(googleProvider);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
