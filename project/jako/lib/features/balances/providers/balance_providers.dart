import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jako/features/auth/providers/auth_providers.dart';
import 'package:jako/features/expenses/providers/expenses_providers.dart';

final balancesProvider = Provider<Map<String, double>>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  final authAsync = ref.watch(authStateProvider);

  final user = authAsync.value;
  final expenses = expensesAsync.value;

  if (user == null || expenses == null) {
    return {};
  }

  final rawBalances = <String, double>{};

  for (final expense in expenses) {
    final participants = expense.participantIds;
    if (participants.isEmpty) continue;

    final share = expense.amount / participants.length;

    // Each participant owes their share
    for (final participantId in participants) {
      rawBalances[participantId] = (rawBalances[participantId] ?? 0) - share;
    }

    // Payer paid full amount
    rawBalances[expense.paidByPersonId] =
        (rawBalances[expense.paidByPersonId] ?? 0) + expense.amount;
  }

  // Build balances relative to YOU
  final result = <String, double>{};

  for (final entry in rawBalances.entries) {
    if (entry.key == user.uid) continue;
    result[entry.key] = -entry.value;
  }

  // Clean up near-zero balances
  const epsilon = 0.01;
  for (final entry in result.entries.toList()) {
    if (entry.value.abs() < epsilon) {
      result[entry.key] = 0.0;
    }
  }

  return result;
});
