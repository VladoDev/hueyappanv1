// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentTransactionModel {

 String get id; String get housingPaymentId; double get amount; double get extraAmount; String get type;@TimestampConverter() DateTime get createdAt; String get createdBy; String? get notes; String? get housingUnit; String? get conceptTitle; String? get conceptId; bool get isConfirmed;@NullableTimestampConverter() DateTime? get confirmedAt;
/// Create a copy of PaymentTransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentTransactionModelCopyWith<PaymentTransactionModel> get copyWith => _$PaymentTransactionModelCopyWithImpl<PaymentTransactionModel>(this as PaymentTransactionModel, _$identity);

  /// Serializes this PaymentTransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.housingPaymentId, housingPaymentId) || other.housingPaymentId == housingPaymentId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.extraAmount, extraAmount) || other.extraAmount == extraAmount)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.housingUnit, housingUnit) || other.housingUnit == housingUnit)&&(identical(other.conceptTitle, conceptTitle) || other.conceptTitle == conceptTitle)&&(identical(other.conceptId, conceptId) || other.conceptId == conceptId)&&(identical(other.isConfirmed, isConfirmed) || other.isConfirmed == isConfirmed)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,housingPaymentId,amount,extraAmount,type,createdAt,createdBy,notes,housingUnit,conceptTitle,conceptId,isConfirmed,confirmedAt);

@override
String toString() {
  return 'PaymentTransactionModel(id: $id, housingPaymentId: $housingPaymentId, amount: $amount, extraAmount: $extraAmount, type: $type, createdAt: $createdAt, createdBy: $createdBy, notes: $notes, housingUnit: $housingUnit, conceptTitle: $conceptTitle, conceptId: $conceptId, isConfirmed: $isConfirmed, confirmedAt: $confirmedAt)';
}


}

/// @nodoc
abstract mixin class $PaymentTransactionModelCopyWith<$Res>  {
  factory $PaymentTransactionModelCopyWith(PaymentTransactionModel value, $Res Function(PaymentTransactionModel) _then) = _$PaymentTransactionModelCopyWithImpl;
@useResult
$Res call({
 String id, String housingPaymentId, double amount, double extraAmount, String type,@TimestampConverter() DateTime createdAt, String createdBy, String? notes, String? housingUnit, String? conceptTitle, String? conceptId, bool isConfirmed,@NullableTimestampConverter() DateTime? confirmedAt
});




}
/// @nodoc
class _$PaymentTransactionModelCopyWithImpl<$Res>
    implements $PaymentTransactionModelCopyWith<$Res> {
  _$PaymentTransactionModelCopyWithImpl(this._self, this._then);

  final PaymentTransactionModel _self;
  final $Res Function(PaymentTransactionModel) _then;

/// Create a copy of PaymentTransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? housingPaymentId = null,Object? amount = null,Object? extraAmount = null,Object? type = null,Object? createdAt = null,Object? createdBy = null,Object? notes = freezed,Object? housingUnit = freezed,Object? conceptTitle = freezed,Object? conceptId = freezed,Object? isConfirmed = null,Object? confirmedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,housingPaymentId: null == housingPaymentId ? _self.housingPaymentId : housingPaymentId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,extraAmount: null == extraAmount ? _self.extraAmount : extraAmount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,housingUnit: freezed == housingUnit ? _self.housingUnit : housingUnit // ignore: cast_nullable_to_non_nullable
as String?,conceptTitle: freezed == conceptTitle ? _self.conceptTitle : conceptTitle // ignore: cast_nullable_to_non_nullable
as String?,conceptId: freezed == conceptId ? _self.conceptId : conceptId // ignore: cast_nullable_to_non_nullable
as String?,isConfirmed: null == isConfirmed ? _self.isConfirmed : isConfirmed // ignore: cast_nullable_to_non_nullable
as bool,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentTransactionModel].
extension PaymentTransactionModelPatterns on PaymentTransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentTransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentTransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentTransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentTransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentTransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentTransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String housingPaymentId,  double amount,  double extraAmount,  String type, @TimestampConverter()  DateTime createdAt,  String createdBy,  String? notes,  String? housingUnit,  String? conceptTitle,  String? conceptId,  bool isConfirmed, @NullableTimestampConverter()  DateTime? confirmedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentTransactionModel() when $default != null:
return $default(_that.id,_that.housingPaymentId,_that.amount,_that.extraAmount,_that.type,_that.createdAt,_that.createdBy,_that.notes,_that.housingUnit,_that.conceptTitle,_that.conceptId,_that.isConfirmed,_that.confirmedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String housingPaymentId,  double amount,  double extraAmount,  String type, @TimestampConverter()  DateTime createdAt,  String createdBy,  String? notes,  String? housingUnit,  String? conceptTitle,  String? conceptId,  bool isConfirmed, @NullableTimestampConverter()  DateTime? confirmedAt)  $default,) {final _that = this;
switch (_that) {
case _PaymentTransactionModel():
return $default(_that.id,_that.housingPaymentId,_that.amount,_that.extraAmount,_that.type,_that.createdAt,_that.createdBy,_that.notes,_that.housingUnit,_that.conceptTitle,_that.conceptId,_that.isConfirmed,_that.confirmedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String housingPaymentId,  double amount,  double extraAmount,  String type, @TimestampConverter()  DateTime createdAt,  String createdBy,  String? notes,  String? housingUnit,  String? conceptTitle,  String? conceptId,  bool isConfirmed, @NullableTimestampConverter()  DateTime? confirmedAt)?  $default,) {final _that = this;
switch (_that) {
case _PaymentTransactionModel() when $default != null:
return $default(_that.id,_that.housingPaymentId,_that.amount,_that.extraAmount,_that.type,_that.createdAt,_that.createdBy,_that.notes,_that.housingUnit,_that.conceptTitle,_that.conceptId,_that.isConfirmed,_that.confirmedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentTransactionModel implements PaymentTransactionModel {
  const _PaymentTransactionModel({required this.id, required this.housingPaymentId, required this.amount, this.extraAmount = 0.0, required this.type, @TimestampConverter() required this.createdAt, required this.createdBy, this.notes, this.housingUnit, this.conceptTitle, this.conceptId, this.isConfirmed = true, @NullableTimestampConverter() this.confirmedAt});
  factory _PaymentTransactionModel.fromJson(Map<String, dynamic> json) => _$PaymentTransactionModelFromJson(json);

@override final  String id;
@override final  String housingPaymentId;
@override final  double amount;
@override@JsonKey() final  double extraAmount;
@override final  String type;
@override@TimestampConverter() final  DateTime createdAt;
@override final  String createdBy;
@override final  String? notes;
@override final  String? housingUnit;
@override final  String? conceptTitle;
@override final  String? conceptId;
@override@JsonKey() final  bool isConfirmed;
@override@NullableTimestampConverter() final  DateTime? confirmedAt;

/// Create a copy of PaymentTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentTransactionModelCopyWith<_PaymentTransactionModel> get copyWith => __$PaymentTransactionModelCopyWithImpl<_PaymentTransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentTransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.housingPaymentId, housingPaymentId) || other.housingPaymentId == housingPaymentId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.extraAmount, extraAmount) || other.extraAmount == extraAmount)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.housingUnit, housingUnit) || other.housingUnit == housingUnit)&&(identical(other.conceptTitle, conceptTitle) || other.conceptTitle == conceptTitle)&&(identical(other.conceptId, conceptId) || other.conceptId == conceptId)&&(identical(other.isConfirmed, isConfirmed) || other.isConfirmed == isConfirmed)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,housingPaymentId,amount,extraAmount,type,createdAt,createdBy,notes,housingUnit,conceptTitle,conceptId,isConfirmed,confirmedAt);

@override
String toString() {
  return 'PaymentTransactionModel(id: $id, housingPaymentId: $housingPaymentId, amount: $amount, extraAmount: $extraAmount, type: $type, createdAt: $createdAt, createdBy: $createdBy, notes: $notes, housingUnit: $housingUnit, conceptTitle: $conceptTitle, conceptId: $conceptId, isConfirmed: $isConfirmed, confirmedAt: $confirmedAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentTransactionModelCopyWith<$Res> implements $PaymentTransactionModelCopyWith<$Res> {
  factory _$PaymentTransactionModelCopyWith(_PaymentTransactionModel value, $Res Function(_PaymentTransactionModel) _then) = __$PaymentTransactionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String housingPaymentId, double amount, double extraAmount, String type,@TimestampConverter() DateTime createdAt, String createdBy, String? notes, String? housingUnit, String? conceptTitle, String? conceptId, bool isConfirmed,@NullableTimestampConverter() DateTime? confirmedAt
});




}
/// @nodoc
class __$PaymentTransactionModelCopyWithImpl<$Res>
    implements _$PaymentTransactionModelCopyWith<$Res> {
  __$PaymentTransactionModelCopyWithImpl(this._self, this._then);

  final _PaymentTransactionModel _self;
  final $Res Function(_PaymentTransactionModel) _then;

/// Create a copy of PaymentTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? housingPaymentId = null,Object? amount = null,Object? extraAmount = null,Object? type = null,Object? createdAt = null,Object? createdBy = null,Object? notes = freezed,Object? housingUnit = freezed,Object? conceptTitle = freezed,Object? conceptId = freezed,Object? isConfirmed = null,Object? confirmedAt = freezed,}) {
  return _then(_PaymentTransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,housingPaymentId: null == housingPaymentId ? _self.housingPaymentId : housingPaymentId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,extraAmount: null == extraAmount ? _self.extraAmount : extraAmount // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,housingUnit: freezed == housingUnit ? _self.housingUnit : housingUnit // ignore: cast_nullable_to_non_nullable
as String?,conceptTitle: freezed == conceptTitle ? _self.conceptTitle : conceptTitle // ignore: cast_nullable_to_non_nullable
as String?,conceptId: freezed == conceptId ? _self.conceptId : conceptId // ignore: cast_nullable_to_non_nullable
as String?,isConfirmed: null == isConfirmed ? _self.isConfirmed : isConfirmed // ignore: cast_nullable_to_non_nullable
as bool,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
