import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrUpdateUser(User user) async {
    final userRef = _firestore.collection('users').doc(user.uid);

    await userRef.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? '',
      'photoUrl': user.photoURL,
      'lastLoginAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
