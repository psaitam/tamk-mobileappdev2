import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jako/features/expenses/data/expenses_repository.dart';
import 'package:jako/features/expenses/domain/expense.dart';

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  return ExpensesRepository();
});

final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  return ref.read(expensesRepositoryProvider).watchExpenses();
});
