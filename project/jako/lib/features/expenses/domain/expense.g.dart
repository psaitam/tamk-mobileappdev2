// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['id'] as String,
  title: json['title'] as String,
  amount: (json['amount'] as num).toDouble(),
  paidByPersonId: json['paidByPersonId'] as String,
  participantIds: (json['participantIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  attachmentUrl: json['attachmentUrl'] as String?,
  note: json['note'] as String?,
  createdAt: _timestampToDateTime(json['createdAt']),
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'amount': instance.amount,
  'paidByPersonId': instance.paidByPersonId,
  'participantIds': instance.participantIds,
  'attachmentUrl': instance.attachmentUrl,
  'note': instance.note,
  'createdAt': _dateTimeToTimestamp(instance.createdAt),
};
