import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jako/features/people/data/people_repository.dart';
import 'package:jako/features/people/domain/person.dart';

final peopleRepositoryProvider = Provider<PeopleRepository>((ref) {
  return PeopleRepository();
});

final peopleStreamProvider = StreamProvider<List<Person>>((ref) {
  return ref.read(peopleRepositoryProvider).watchPeople();
});
