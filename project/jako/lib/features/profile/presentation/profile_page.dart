import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jako/features/auth/providers/auth_providers.dart';
import 'package:jako/features/expenses/providers/expenses_providers.dart';
import 'package:jako/features/people/providers/people_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value;
    final peopleAsync = ref.watch(peopleStreamProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);

    if (auth == null) {
      return const Center(child: Text('Not signed in'));
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage: auth.photoURL != null
                      ? NetworkImage(auth.photoURL!)
                      : null,
                  child: auth.photoURL == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: colorScheme.onPrimaryContainer,
                        )
                      : null,
                ),
                const SizedBox(height: 12),

                Text(
                  resolveDisplayName(auth),
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 4),
                Text(
                  auth.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          _ProfileCard(
            title: 'Your stats',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatTile(
                  label: 'Friends',
                  value: peopleAsync.maybeWhen(
                    data: (people) => people.length.toString(),
                    orElse: () => '–',
                  ),
                ),
                _StatTile(
                  label: 'Expenses',
                  value: expensesAsync.maybeWhen(
                    data: (expenses) => expenses.length.toString(),
                    orElse: () => '–',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _ProfileCard(
            title: 'Actions',
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign out'),
                  onTap: () async {
                    await ref.read(authRepositoryProvider).signOut();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              'Jako • Expense tracking\nVersion 1.0',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ProfileCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

String resolveDisplayName(User user) {
  if (user.displayName != null && user.displayName!.isNotEmpty) {
    return user.displayName!;
  }

  final googleProfile = user.providerData.firstWhere(
    (p) => p.providerId == 'google.com',
    orElse: () => user.providerData.first,
  );

  if (googleProfile.displayName != null &&
      googleProfile.displayName!.isNotEmpty) {
    return googleProfile.displayName!;
  }

  if (user.email != null && user.email!.contains('@')) {
    return user.email!.split('@').first;
  }

  return 'User';
}
