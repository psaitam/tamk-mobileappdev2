import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jako/features/auth/providers/auth_providers.dart';
import 'package:jako/features/expenses/domain/expense.dart';
import 'package:jako/features/expenses/presentation/add_expense_page.dart';
import 'package:jako/features/expenses/providers/expenses_providers.dart';
import 'package:jako/features/people/providers/people_providers.dart';

class ExpenseDetailsPage extends ConsumerWidget {
  final Expense expense;

  const ExpenseDetailsPage({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peopleAsync = ref.watch(peopleStreamProvider);
    final auth = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddExpensePage(existingExpense: expense),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: peopleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (people) {
          final peopleMap = {
            for (final p in people) p.id: p.name,
            if (auth != null) auth.uid: 'You',
          };

          final payerName = peopleMap[expense.paidByPersonId] ?? 'Unknown';

          final participants = expense.participantIds;
          final share = expense.amount / participants.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Section(
                  title: expense.title,
                  child: Text(
                    '${expense.amount.toStringAsFixed(2)} €',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                _Section(title: 'Paid by', child: Text(payerName)),

                _Section(
                  title: 'Participants',
                  child: Column(
                    children: participants.map((id) {
                      final name = peopleMap[id] ?? 'Unknown';
                      return ListTile(
                        dense: true,
                        title: Text(name),
                        trailing: Text('${share.toStringAsFixed(2)} €'),
                      );
                    }).toList(),
                  ),
                ),

                if (expense.attachmentUrl != null)
                  _Section(
                    title: 'Receipt',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => _FullScreenImage(
                              imageUrl: expense.attachmentUrl!,
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          expense.attachmentUrl!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete expense'),
          content: Text(
            'This will permanently delete the expense and its receipt (if any).',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () async {
                await ref
                    .read(expensesRepositoryProvider)
                    .deleteExpense(expense);

                if (context.mounted) {
                  Navigator.pop(context); // dialog
                  Navigator.pop(context); // details page
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: InteractiveViewer(
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
