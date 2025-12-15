import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jako/features/expenses/presentation/expenses_page.dart';
import 'package:jako/features/home/providers/navigation_notifier.dart';
import 'package:jako/features/people/presentation/people_page.dart';
import 'package:jako/features/profile/presentation/profile_page.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavProvider);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [ExpensesPage(), PeoplePage(), ProfilePage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (newIndex) {
          ref.read(bottomNavProvider.notifier).setIndex(newIndex);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          NavigationDestination(icon: Icon(Icons.people), label: 'Friends'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
