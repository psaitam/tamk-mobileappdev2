import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class Expense with _$Expense {
  const Expense._();

  const factory Expense({
    required String id,
    required String title,
    required double amount,
    required String paidByPersonId,
    required List<String> participantIds,

    String? attachmentUrl,

    String? note,

    @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
    DateTime? createdAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  factory Expense.fromFirestore(String id, Map<String, dynamic> data) {
    return Expense.fromJson({...data, 'id': id});
  }
}

// Firestore helpers
DateTime? _timestampToDateTime(dynamic value) {
  if (value == null) return null;
  return (value as Timestamp).toDate();
}

dynamic _dateTimeToTimestamp(DateTime? value) {
  if (value == null) return null;
  return Timestamp.fromDate(value);
}
