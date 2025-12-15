import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jako/features/user/data/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userSetupProvider = FutureProvider<void>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await ref.read(userRepositoryProvider).createOrUpdateUser(user);
});
