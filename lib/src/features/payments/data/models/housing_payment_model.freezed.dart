// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'housing_payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HousingPaymentModel {

 String get id; String get conceptId; String get residentUid; String get housingUnit; double get totalDue; double get amountPaid; double get balance; String get paymentStatus; double get extraAmount;@NullableTimestampConverter() DateTime? get paidAt; String? get notes; bool get hasPendingConfirmation;
/// Create a copy of HousingPaymentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HousingPaymentModelCopyWith<HousingPaymentModel> get copyWith => _$HousingPaymentModelCopyWithImpl<HousingPaymentModel>(this as HousingPaymentModel, _$identity);

  /// Serializes this HousingPaymentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HousingPaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.conceptId, conceptId) || other.conceptId == conceptId)&&(identical(other.residentUid, residentUid) || other.residentUid == residentUid)&&(identical(other.housingUnit, housingUnit) || other.housingUnit == housingUnit)&&(identical(other.totalDue, totalDue) || other.totalDue == totalDue)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.extraAmount, extraAmount) || other.extraAmount == extraAmount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.hasPendingConfirmation, hasPendingConfirmation) || other.hasPendingConfirmation == hasPendingConfirmation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conceptId,residentUid,housingUnit,totalDue,amountPaid,balance,paymentStatus,extraAmount,paidAt,notes,hasPendingConfirmation);

@override
String toString() {
  return 'HousingPaymentModel(id: $id, conceptId: $conceptId, residentUid: $residentUid, housingUnit: $housingUnit, totalDue: $totalDue, amountPaid: $amountPaid, balance: $balance, paymentStatus: $paymentStatus, extraAmount: $extraAmount, paidAt: $paidAt, notes: $notes, hasPendingConfirmation: $hasPendingConfirmation)';
}


}

/// @nodoc
abstract mixin class $HousingPaymentModelCopyWith<$Res>  {
  factory $HousingPaymentModelCopyWith(HousingPaymentModel value, $Res Function(HousingPaymentModel) _then) = _$HousingPaymentModelCopyWithImpl;
@useResult
$Res call({
 String id, String conceptId, String residentUid, String housingUnit, double totalDue, double amountPaid, double balance, String paymentStatus, double extraAmount,@NullableTimestampConverter() DateTime? paidAt, String? notes, bool hasPendingConfirmation
});




}
/// @nodoc
class _$HousingPaymentModelCopyWithImpl<$Res>
    implements $HousingPaymentModelCopyWith<$Res> {
  _$HousingPaymentModelCopyWithImpl(this._self, this._then);

  final HousingPaymentModel _self;
  final $Res Function(HousingPaymentModel) _then;

/// Create a copy of HousingPaymentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conceptId = null,Object? residentUid = null,Object? housingUnit = null,Object? totalDue = null,Object? amountPaid = null,Object? balance = null,Object? paymentStatus = null,Object? extraAmount = null,Object? paidAt = freezed,Object? notes = freezed,Object? hasPendingConfirmation = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conceptId: null == conceptId ? _self.conceptId : conceptId // ignore: cast_nullable_to_non_nullable
as String,residentUid: null == residentUid ? _self.residentUid : residentUid // ignore: cast_nullable_to_non_nullable
as String,housingUnit: null == housingUnit ? _self.housingUnit : housingUnit // ignore: cast_nullable_to_non_nullable
as String,totalDue: null == totalDue ? _self.totalDue : totalDue // ignore: cast_nullable_to_non_nullable
as double,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String,extraAmount: null == extraAmount ? _self.extraAmount : extraAmount // ignore: cast_nullable_to_non_nullable
as double,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,hasPendingConfirmation: null == hasPendingConfirmation ? _self.hasPendingConfirmation : hasPendingConfirmation // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HousingPaymentModel].
extension HousingPaymentModelPatterns on HousingPaymentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HousingPaymentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HousingPaymentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HousingPaymentModel value)  $default,){
final _that = this;
switch (_that) {
case _HousingPaymentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HousingPaymentModel value)?  $default,){
final _that = this;
switch (_that) {
case _HousingPaymentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conceptId,  String residentUid,  String housingUnit,  double totalDue,  double amountPaid,  double balance,  String paymentStatus,  double extraAmount, @NullableTimestampConverter()  DateTime? paidAt,  String? notes,  bool hasPendingConfirmation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HousingPaymentModel() when $default != null:
return $default(_that.id,_that.conceptId,_that.residentUid,_that.housingUnit,_that.totalDue,_that.amountPaid,_that.balance,_that.paymentStatus,_that.extraAmount,_that.paidAt,_that.notes,_that.hasPendingConfirmation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conceptId,  String residentUid,  String housingUnit,  double totalDue,  double amountPaid,  double balance,  String paymentStatus,  double extraAmount, @NullableTimestampConverter()  DateTime? paidAt,  String? notes,  bool hasPendingConfirmation)  $default,) {final _that = this;
switch (_that) {
case _HousingPaymentModel():
return $default(_that.id,_that.conceptId,_that.residentUid,_that.housingUnit,_that.totalDue,_that.amountPaid,_that.balance,_that.paymentStatus,_that.extraAmount,_that.paidAt,_that.notes,_that.hasPendingConfirmation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conceptId,  String residentUid,  String housingUnit,  double totalDue,  double amountPaid,  double balance,  String paymentStatus,  double extraAmount, @NullableTimestampConverter()  DateTime? paidAt,  String? notes,  bool hasPendingConfirmation)?  $default,) {final _that = this;
switch (_that) {
case _HousingPaymentModel() when $default != null:
return $default(_that.id,_that.conceptId,_that.residentUid,_that.housingUnit,_that.totalDue,_that.amountPaid,_that.balance,_that.paymentStatus,_that.extraAmount,_that.paidAt,_that.notes,_that.hasPendingConfirmation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HousingPaymentModel implements HousingPaymentModel {
  const _HousingPaymentModel({required this.id, required this.conceptId, required this.residentUid, required this.housingUnit, required this.totalDue, required this.amountPaid, required this.balance, required this.paymentStatus, this.extraAmount = 0.0, @NullableTimestampConverter() this.paidAt, this.notes, this.hasPendingConfirmation = false});
  factory _HousingPaymentModel.fromJson(Map<String, dynamic> json) => _$HousingPaymentModelFromJson(json);

@override final  String id;
@override final  String conceptId;
@override final  String residentUid;
@override final  String housingUnit;
@override final  double totalDue;
@override final  double amountPaid;
@override final  double balance;
@override final  String paymentStatus;
@override@JsonKey() final  double extraAmount;
@override@NullableTimestampConverter() final  DateTime? paidAt;
@override final  String? notes;
@override@JsonKey() final  bool hasPendingConfirmation;

/// Create a copy of HousingPaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HousingPaymentModelCopyWith<_HousingPaymentModel> get copyWith => __$HousingPaymentModelCopyWithImpl<_HousingPaymentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HousingPaymentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HousingPaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.conceptId, conceptId) || other.conceptId == conceptId)&&(identical(other.residentUid, residentUid) || other.residentUid == residentUid)&&(identical(other.housingUnit, housingUnit) || other.housingUnit == housingUnit)&&(identical(other.totalDue, totalDue) || other.totalDue == totalDue)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.extraAmount, extraAmount) || other.extraAmount == extraAmount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.hasPendingConfirmation, hasPendingConfirmation) || other.hasPendingConfirmation == hasPendingConfirmation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conceptId,residentUid,housingUnit,totalDue,amountPaid,balance,paymentStatus,extraAmount,paidAt,notes,hasPendingConfirmation);

@override
String toString() {
  return 'HousingPaymentModel(id: $id, conceptId: $conceptId, residentUid: $residentUid, housingUnit: $housingUnit, totalDue: $totalDue, amountPaid: $amountPaid, balance: $balance, paymentStatus: $paymentStatus, extraAmount: $extraAmount, paidAt: $paidAt, notes: $notes, hasPendingConfirmation: $hasPendingConfirmation)';
}


}

/// @nodoc
abstract mixin class _$HousingPaymentModelCopyWith<$Res> implements $HousingPaymentModelCopyWith<$Res> {
  factory _$HousingPaymentModelCopyWith(_HousingPaymentModel value, $Res Function(_HousingPaymentModel) _then) = __$HousingPaymentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String conceptId, String residentUid, String housingUnit, double totalDue, double amountPaid, double balance, String paymentStatus, double extraAmount,@NullableTimestampConverter() DateTime? paidAt, String? notes, bool hasPendingConfirmation
});




}
/// @nodoc
class __$HousingPaymentModelCopyWithImpl<$Res>
    implements _$HousingPaymentModelCopyWith<$Res> {
  __$HousingPaymentModelCopyWithImpl(this._self, this._then);

  final _HousingPaymentModel _self;
  final $Res Function(_HousingPaymentModel) _then;

/// Create a copy of HousingPaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conceptId = null,Object? residentUid = null,Object? housingUnit = null,Object? totalDue = null,Object? amountPaid = null,Object? balance = null,Object? paymentStatus = null,Object? extraAmount = null,Object? paidAt = freezed,Object? notes = freezed,Object? hasPendingConfirmation = null,}) {
  return _then(_HousingPaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conceptId: null == conceptId ? _self.conceptId : conceptId // ignore: cast_nullable_to_non_nullable
as String,residentUid: null == residentUid ? _self.residentUid : residentUid // ignore: cast_nullable_to_non_nullable
as String,housingUnit: null == housingUnit ? _self.housingUnit : housingUnit // ignore: cast_nullable_to_non_nullable
as String,totalDue: null == totalDue ? _self.totalDue : totalDue // ignore: cast_nullable_to_non_nullable
as double,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String,extraAmount: null == extraAmount ? _self.extraAmount : extraAmount // ignore: cast_nullable_to_non_nullable
as double,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,hasPendingConfirmation: null == hasPendingConfirmation ? _self.hasPendingConfirmation : hasPendingConfirmation // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
