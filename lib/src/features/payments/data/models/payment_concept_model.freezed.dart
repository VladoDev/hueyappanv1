// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_concept_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentConceptModel {

 String get id; String get title; String? get description; double get totalAmount; int get totalUnits; double get amountPerUnit; String get status;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt; double get recordedExpense;
/// Create a copy of PaymentConceptModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentConceptModelCopyWith<PaymentConceptModel> get copyWith => _$PaymentConceptModelCopyWithImpl<PaymentConceptModel>(this as PaymentConceptModel, _$identity);

  /// Serializes this PaymentConceptModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentConceptModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.totalUnits, totalUnits) || other.totalUnits == totalUnits)&&(identical(other.amountPerUnit, amountPerUnit) || other.amountPerUnit == amountPerUnit)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.recordedExpense, recordedExpense) || other.recordedExpense == recordedExpense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,totalAmount,totalUnits,amountPerUnit,status,createdAt,updatedAt,recordedExpense);

@override
String toString() {
  return 'PaymentConceptModel(id: $id, title: $title, description: $description, totalAmount: $totalAmount, totalUnits: $totalUnits, amountPerUnit: $amountPerUnit, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, recordedExpense: $recordedExpense)';
}


}

/// @nodoc
abstract mixin class $PaymentConceptModelCopyWith<$Res>  {
  factory $PaymentConceptModelCopyWith(PaymentConceptModel value, $Res Function(PaymentConceptModel) _then) = _$PaymentConceptModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, double totalAmount, int totalUnits, double amountPerUnit, String status,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, double recordedExpense
});




}
/// @nodoc
class _$PaymentConceptModelCopyWithImpl<$Res>
    implements $PaymentConceptModelCopyWith<$Res> {
  _$PaymentConceptModelCopyWithImpl(this._self, this._then);

  final PaymentConceptModel _self;
  final $Res Function(PaymentConceptModel) _then;

/// Create a copy of PaymentConceptModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? totalAmount = null,Object? totalUnits = null,Object? amountPerUnit = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? recordedExpense = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,totalUnits: null == totalUnits ? _self.totalUnits : totalUnits // ignore: cast_nullable_to_non_nullable
as int,amountPerUnit: null == amountPerUnit ? _self.amountPerUnit : amountPerUnit // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,recordedExpense: null == recordedExpense ? _self.recordedExpense : recordedExpense // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentConceptModel].
extension PaymentConceptModelPatterns on PaymentConceptModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentConceptModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentConceptModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentConceptModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentConceptModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentConceptModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentConceptModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  double totalAmount,  int totalUnits,  double amountPerUnit,  String status, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  double recordedExpense)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentConceptModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.totalAmount,_that.totalUnits,_that.amountPerUnit,_that.status,_that.createdAt,_that.updatedAt,_that.recordedExpense);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  double totalAmount,  int totalUnits,  double amountPerUnit,  String status, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  double recordedExpense)  $default,) {final _that = this;
switch (_that) {
case _PaymentConceptModel():
return $default(_that.id,_that.title,_that.description,_that.totalAmount,_that.totalUnits,_that.amountPerUnit,_that.status,_that.createdAt,_that.updatedAt,_that.recordedExpense);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  double totalAmount,  int totalUnits,  double amountPerUnit,  String status, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  double recordedExpense)?  $default,) {final _that = this;
switch (_that) {
case _PaymentConceptModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.totalAmount,_that.totalUnits,_that.amountPerUnit,_that.status,_that.createdAt,_that.updatedAt,_that.recordedExpense);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentConceptModel implements PaymentConceptModel {
  const _PaymentConceptModel({required this.id, required this.title, this.description, required this.totalAmount, required this.totalUnits, required this.amountPerUnit, required this.status, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt, this.recordedExpense = 0.0});
  factory _PaymentConceptModel.fromJson(Map<String, dynamic> json) => _$PaymentConceptModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override final  double totalAmount;
@override final  int totalUnits;
@override final  double amountPerUnit;
@override final  String status;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;
@override@JsonKey() final  double recordedExpense;

/// Create a copy of PaymentConceptModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentConceptModelCopyWith<_PaymentConceptModel> get copyWith => __$PaymentConceptModelCopyWithImpl<_PaymentConceptModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentConceptModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentConceptModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.totalUnits, totalUnits) || other.totalUnits == totalUnits)&&(identical(other.amountPerUnit, amountPerUnit) || other.amountPerUnit == amountPerUnit)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.recordedExpense, recordedExpense) || other.recordedExpense == recordedExpense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,totalAmount,totalUnits,amountPerUnit,status,createdAt,updatedAt,recordedExpense);

@override
String toString() {
  return 'PaymentConceptModel(id: $id, title: $title, description: $description, totalAmount: $totalAmount, totalUnits: $totalUnits, amountPerUnit: $amountPerUnit, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, recordedExpense: $recordedExpense)';
}


}

/// @nodoc
abstract mixin class _$PaymentConceptModelCopyWith<$Res> implements $PaymentConceptModelCopyWith<$Res> {
  factory _$PaymentConceptModelCopyWith(_PaymentConceptModel value, $Res Function(_PaymentConceptModel) _then) = __$PaymentConceptModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, double totalAmount, int totalUnits, double amountPerUnit, String status,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, double recordedExpense
});




}
/// @nodoc
class __$PaymentConceptModelCopyWithImpl<$Res>
    implements _$PaymentConceptModelCopyWith<$Res> {
  __$PaymentConceptModelCopyWithImpl(this._self, this._then);

  final _PaymentConceptModel _self;
  final $Res Function(_PaymentConceptModel) _then;

/// Create a copy of PaymentConceptModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? totalAmount = null,Object? totalUnits = null,Object? amountPerUnit = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? recordedExpense = null,}) {
  return _then(_PaymentConceptModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,totalUnits: null == totalUnits ? _self.totalUnits : totalUnits // ignore: cast_nullable_to_non_nullable
as int,amountPerUnit: null == amountPerUnit ? _self.amountPerUnit : amountPerUnit // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,recordedExpense: null == recordedExpense ? _self.recordedExpense : recordedExpense // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
