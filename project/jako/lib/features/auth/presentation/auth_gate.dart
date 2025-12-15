import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jako/features/auth/presentation/login_page.dart';
import 'package:jako/features/auth/providers/auth_providers.dart';
import 'package:jako/features/home/presentation/home_shell.dart';
import 'package:jako/features/user/providers/user_providers.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) =>
          Scaffold(body: Center(child: Text('Auth error: $err'))),
      data: (user) {
        if (user == null) {
          return const LoginPage();
        }

        // Create / update Firestore user doc
        ref.read(userSetupProvider);

        return const HomeShell();
      },
    );
  }
}
