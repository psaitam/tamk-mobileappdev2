import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jako/features/people/domain/person.dart';

class PeopleRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _peopleRef() {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('people');
  }

  Stream<List<Person>> watchPeople() {
    return _peopleRef().orderBy('createdAt').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Person.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addPerson({required String name, String? email}) async {
    await _peopleRef().add({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePerson(String personId) async {
    await _peopleRef().doc(personId).delete();
  }
}
