// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'concept_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConceptItemModel {

 String get id; String get conceptId; String get label; double? get amount; int get order;
/// Create a copy of ConceptItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConceptItemModelCopyWith<ConceptItemModel> get copyWith => _$ConceptItemModelCopyWithImpl<ConceptItemModel>(this as ConceptItemModel, _$identity);

  /// Serializes this ConceptItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConceptItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.conceptId, conceptId) || other.conceptId == conceptId)&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conceptId,label,amount,order);

@override
String toString() {
  return 'ConceptItemModel(id: $id, conceptId: $conceptId, label: $label, amount: $amount, order: $order)';
}


}

/// @nodoc
abstract mixin class $ConceptItemModelCopyWith<$Res>  {
  factory $ConceptItemModelCopyWith(ConceptItemModel value, $Res Function(ConceptItemModel) _then) = _$ConceptItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String conceptId, String label, double? amount, int order
});




}
/// @nodoc
class _$ConceptItemModelCopyWithImpl<$Res>
    implements $ConceptItemModelCopyWith<$Res> {
  _$ConceptItemModelCopyWithImpl(this._self, this._then);

  final ConceptItemModel _self;
  final $Res Function(ConceptItemModel) _then;

/// Create a copy of ConceptItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conceptId = null,Object? label = null,Object? amount = freezed,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conceptId: null == conceptId ? _self.conceptId : conceptId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConceptItemModel].
extension ConceptItemModelPatterns on ConceptItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConceptItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConceptItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConceptItemModel value)  $default,){
final _that = this;
switch (_that) {
case _ConceptItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConceptItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _ConceptItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conceptId,  String label,  double? amount,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConceptItemModel() when $default != null:
return $default(_that.id,_that.conceptId,_that.label,_that.amount,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conceptId,  String label,  double? amount,  int order)  $default,) {final _that = this;
switch (_that) {
case _ConceptItemModel():
return $default(_that.id,_that.conceptId,_that.label,_that.amount,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conceptId,  String label,  double? amount,  int order)?  $default,) {final _that = this;
switch (_that) {
case _ConceptItemModel() when $default != null:
return $default(_that.id,_that.conceptId,_that.label,_that.amount,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConceptItemModel implements ConceptItemModel {
  const _ConceptItemModel({required this.id, required this.conceptId, required this.label, this.amount, required this.order});
  factory _ConceptItemModel.fromJson(Map<String, dynamic> json) => _$ConceptItemModelFromJson(json);

@override final  String id;
@override final  String conceptId;
@override final  String label;
@override final  double? amount;
@override final  int order;

/// Create a copy of ConceptItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConceptItemModelCopyWith<_ConceptItemModel> get copyWith => __$ConceptItemModelCopyWithImpl<_ConceptItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConceptItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConceptItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.conceptId, conceptId) || other.conceptId == conceptId)&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conceptId,label,amount,order);

@override
String toString() {
  return 'ConceptItemModel(id: $id, conceptId: $conceptId, label: $label, amount: $amount, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ConceptItemModelCopyWith<$Res> implements $ConceptItemModelCopyWith<$Res> {
  factory _$ConceptItemModelCopyWith(_ConceptItemModel value, $Res Function(_ConceptItemModel) _then) = __$ConceptItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String conceptId, String label, double? amount, int order
});




}
/// @nodoc
class __$ConceptItemModelCopyWithImpl<$Res>
    implements _$ConceptItemModelCopyWith<$Res> {
  __$ConceptItemModelCopyWithImpl(this._self, this._then);

  final _ConceptItemModel _self;
  final $Res Function(_ConceptItemModel) _then;

/// Create a copy of ConceptItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conceptId = null,Object? label = null,Object? amount = freezed,Object? order = null,}) {
  return _then(_ConceptItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conceptId: null == conceptId ? _self.conceptId : conceptId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
