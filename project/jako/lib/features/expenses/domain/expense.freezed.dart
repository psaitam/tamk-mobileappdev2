// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Expense {

 String get id; String get title; double get amount; String get paidByPersonId; List<String> get participantIds;// ✅ NEW: optional receipt / attachment
 String? get attachmentUrl; String? get note;@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) DateTime? get createdAt;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidByPersonId, paidByPersonId) || other.paidByPersonId == paidByPersonId)&&const DeepCollectionEquality().equals(other.participantIds, participantIds)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,amount,paidByPersonId,const DeepCollectionEquality().hash(participantIds),attachmentUrl,note,createdAt);

@override
String toString() {
  return 'Expense(id: $id, title: $title, amount: $amount, paidByPersonId: $paidByPersonId, participantIds: $participantIds, attachmentUrl: $attachmentUrl, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
 String id, String title, double amount, String paidByPersonId, List<String> participantIds, String? attachmentUrl, String? note,@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) DateTime? createdAt
});




}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? paidByPersonId = null,Object? participantIds = null,Object? attachmentUrl = freezed,Object? note = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paidByPersonId: null == paidByPersonId ? _self.paidByPersonId : paidByPersonId // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  double amount,  String paidByPersonId,  List<String> participantIds,  String? attachmentUrl,  String? note, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.title,_that.amount,_that.paidByPersonId,_that.participantIds,_that.attachmentUrl,_that.note,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  double amount,  String paidByPersonId,  List<String> participantIds,  String? attachmentUrl,  String? note, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.title,_that.amount,_that.paidByPersonId,_that.participantIds,_that.attachmentUrl,_that.note,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  double amount,  String paidByPersonId,  List<String> participantIds,  String? attachmentUrl,  String? note, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.title,_that.amount,_that.paidByPersonId,_that.participantIds,_that.attachmentUrl,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Expense extends Expense {
  const _Expense({required this.id, required this.title, required this.amount, required this.paidByPersonId, required final  List<String> participantIds, this.attachmentUrl, this.note, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) this.createdAt}): _participantIds = participantIds,super._();
  factory _Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

@override final  String id;
@override final  String title;
@override final  double amount;
@override final  String paidByPersonId;
 final  List<String> _participantIds;
@override List<String> get participantIds {
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantIds);
}

// ✅ NEW: optional receipt / attachment
@override final  String? attachmentUrl;
@override final  String? note;
@override@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) final  DateTime? createdAt;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidByPersonId, paidByPersonId) || other.paidByPersonId == paidByPersonId)&&const DeepCollectionEquality().equals(other._participantIds, _participantIds)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,amount,paidByPersonId,const DeepCollectionEquality().hash(_participantIds),attachmentUrl,note,createdAt);

@override
String toString() {
  return 'Expense(id: $id, title: $title, amount: $amount, paidByPersonId: $paidByPersonId, participantIds: $participantIds, attachmentUrl: $attachmentUrl, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, double amount, String paidByPersonId, List<String> participantIds, String? attachmentUrl, String? note,@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) DateTime? createdAt
});




}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? paidByPersonId = null,Object? participantIds = null,Object? attachmentUrl = freezed,Object? note = freezed,Object? createdAt = freezed,}) {
  return _then(_Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paidByPersonId: null == paidByPersonId ? _self.paidByPersonId : paidByPersonId // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
