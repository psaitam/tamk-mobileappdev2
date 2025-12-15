import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jako/features/auth/providers/auth_providers.dart';
import 'package:jako/features/balances/providers/balance_providers.dart';
import 'package:jako/features/expenses/providers/expenses_providers.dart';
import 'package:jako/features/people/domain/person.dart';
import 'package:jako/features/people/providers/people_providers.dart';

class PeoplePage extends ConsumerWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peopleAsync = ref.watch(peopleStreamProvider);
    final balances = ref.watch(balancesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Friends')),
      body: peopleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (people) {
          if (people.isEmpty) {
            return const Center(child: Text('No friends yet'));
          }

          return ListView.separated(
            itemCount: people.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final person = people[index];
              final balance = balances[person.id] ?? 0;
              final normalizedBalance = balance.abs() < 0.01 ? 0.0 : balance;

              final balanceText = normalizedBalance == 0
                  ? 'Settled up'
                  : normalizedBalance > 0
                  ? 'Owes you ${balance.toStringAsFixed(2)} €'
                  : 'You owe ${(-balance).toStringAsFixed(2)} €';

              final scheme = Theme.of(context).colorScheme;
              final balanceColor = normalizedBalance > 0
                  ? scheme.tertiary
                  : normalizedBalance < 0
                  ? scheme.error
                  : scheme.onSurfaceVariant;

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    person.name.isNotEmpty ? person.name[0].toUpperCase() : '?',
                  ),
                ),
                title: Text(
                  person.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  balanceText,
                  style: TextStyle(color: balanceColor),
                ),
                trailing: balance != 0
                    ? FilledButton.tonal(
                        onPressed: () {
                          _showSettleUpDialog(
                            context,
                            ref,
                            personId: person.id,
                            personName: person.name,
                            amount: balance.abs(),
                            youAreOwed: balance > 0,
                          );
                        },
                        child: const Text('Settle up'),
                      )
                    : null,
                onLongPress: () {
                  _confirmDeletePerson(context, ref, person);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => _showAddPersonDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDeletePerson(
    BuildContext context,
    WidgetRef ref,
    Person person,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove friend'),
          content: Text(
            'Remove ${person.name}? Past expenses will remain.',
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
                    .read(peopleRepositoryProvider)
                    .deletePerson(person.id);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _showSettleUpDialog(
    BuildContext context,
    WidgetRef ref, {
    required String personId,
    required String personName,
    required double amount,
    required bool youAreOwed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Settle up'),
          content: Text(
            youAreOwed
                ? '$personName owes you ${amount.toStringAsFixed(2)} €'
                : 'You owe $personName ${amount.toStringAsFixed(2)} €',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final auth = ref.read(authStateProvider).value;
                if (auth == null) return;

                final repo = ref.read(expensesRepositoryProvider);
                final expenseRef = repo.createExpenseRef();

                await repo.addExpenseWithRef(
                  ref: expenseRef,
                  title: 'Settlement',
                  amount: amount,
                  paidByPersonId: youAreOwed ? personId : auth.uid,
                  participantIds: youAreOwed ? [auth.uid] : [personId],
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPersonDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add friend'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                autofocus: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (optional)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                await ref
                    .read(peopleRepositoryProvider)
                    .addPerson(
                      name: name,
                      email: emailController.text.trim().isEmpty
                          ? null
                          : emailController.text.trim(),
                    );

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
