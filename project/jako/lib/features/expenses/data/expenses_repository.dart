import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jako/features/expenses/domain/expense.dart';

class ExpensesRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _expensesRef() {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('expenses');
  }

  DocumentReference<Map<String, dynamic>> createExpenseRef() {
    return _expensesRef().doc();
  }

  Stream<List<Expense>> watchExpenses() {
    return _expensesRef()
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Expense.fromFirestore(doc.id, doc.data()))
              .toList();
        });
  }

  Future<void> addExpenseWithRef({
    required DocumentReference<Map<String, dynamic>> ref,
    required String title,
    required double amount,
    required String paidByPersonId,
    required List<String> participantIds,
    String? note,
    String? attachmentUrl,
  }) async {
    await ref.set({
      'title': title,
      'amount': amount,
      'paidByPersonId': paidByPersonId,
      'participantIds': participantIds,
      'note': note,
      'attachmentUrl': attachmentUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateExpense({
    required String expenseId,
    required String title,
    required double amount,
    required String paidByPersonId,
    required List<String> participantIds,
    String? attachmentUrl,
  }) async {
    await _expensesRef().doc(expenseId).update({
      'title': title,
      'amount': amount,
      'paidByPersonId': paidByPersonId,
      'participantIds': participantIds,
      'attachmentUrl': attachmentUrl,
    });
  }

  Future<void> deleteExpense(Expense expense) async {
    final uid = _auth.currentUser!.uid;

    if (expense.attachmentUrl != null) {
      try {
        final storageRef = FirebaseStorage.instance.refFromURL(
          expense.attachmentUrl!,
        );
        await storageRef.delete();
      } catch (_) {
        // ignore missing files
      }
    }

    await _expensesRef().doc(expense.id).delete();
  }
}
