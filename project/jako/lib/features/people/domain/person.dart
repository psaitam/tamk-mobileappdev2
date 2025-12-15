import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
abstract class Person with _$Person {
  const Person._();

  const factory Person({
    required String id,
    required String name,
    String? email,
  }) = _Person;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  factory Person.fromFirestore(String id, Map<String, dynamic> data) {
    return Person.fromJson({...data, 'id': id});
  }
}
