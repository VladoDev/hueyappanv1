// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resident_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResidentModel {

 String get uid; String get name; String get email; String get lot; String get house; String get accountStatus; String? get phone; String? get residentType; String get role; bool get isPhoneVerified;
/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentModelCopyWith<ResidentModel> get copyWith => _$ResidentModelCopyWithImpl<ResidentModel>(this as ResidentModel, _$identity);

  /// Serializes this ResidentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.lot, lot) || other.lot == lot)&&(identical(other.house, house) || other.house == house)&&(identical(other.accountStatus, accountStatus) || other.accountStatus == accountStatus)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.residentType, residentType) || other.residentType == residentType)&&(identical(other.role, role) || other.role == role)&&(identical(other.isPhoneVerified, isPhoneVerified) || other.isPhoneVerified == isPhoneVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,email,lot,house,accountStatus,phone,residentType,role,isPhoneVerified);

@override
String toString() {
  return 'ResidentModel(uid: $uid, name: $name, email: $email, lot: $lot, house: $house, accountStatus: $accountStatus, phone: $phone, residentType: $residentType, role: $role, isPhoneVerified: $isPhoneVerified)';
}


}

/// @nodoc
abstract mixin class $ResidentModelCopyWith<$Res>  {
  factory $ResidentModelCopyWith(ResidentModel value, $Res Function(ResidentModel) _then) = _$ResidentModelCopyWithImpl;
@useResult
$Res call({
 String uid, String name, String email, String lot, String house, String accountStatus, String? phone, String? residentType, String role, bool isPhoneVerified
});




}
/// @nodoc
class _$ResidentModelCopyWithImpl<$Res>
    implements $ResidentModelCopyWith<$Res> {
  _$ResidentModelCopyWithImpl(this._self, this._then);

  final ResidentModel _self;
  final $Res Function(ResidentModel) _then;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? name = null,Object? email = null,Object? lot = null,Object? house = null,Object? accountStatus = null,Object? phone = freezed,Object? residentType = freezed,Object? role = null,Object? isPhoneVerified = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,lot: null == lot ? _self.lot : lot // ignore: cast_nullable_to_non_nullable
as String,house: null == house ? _self.house : house // ignore: cast_nullable_to_non_nullable
as String,accountStatus: null == accountStatus ? _self.accountStatus : accountStatus // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,residentType: freezed == residentType ? _self.residentType : residentType // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isPhoneVerified: null == isPhoneVerified ? _self.isPhoneVerified : isPhoneVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ResidentModel].
extension ResidentModelPatterns on ResidentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResidentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResidentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResidentModel value)  $default,){
final _that = this;
switch (_that) {
case _ResidentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResidentModel value)?  $default,){
final _that = this;
switch (_that) {
case _ResidentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String name,  String email,  String lot,  String house,  String accountStatus,  String? phone,  String? residentType,  String role,  bool isPhoneVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResidentModel() when $default != null:
return $default(_that.uid,_that.name,_that.email,_that.lot,_that.house,_that.accountStatus,_that.phone,_that.residentType,_that.role,_that.isPhoneVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String name,  String email,  String lot,  String house,  String accountStatus,  String? phone,  String? residentType,  String role,  bool isPhoneVerified)  $default,) {final _that = this;
switch (_that) {
case _ResidentModel():
return $default(_that.uid,_that.name,_that.email,_that.lot,_that.house,_that.accountStatus,_that.phone,_that.residentType,_that.role,_that.isPhoneVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String name,  String email,  String lot,  String house,  String accountStatus,  String? phone,  String? residentType,  String role,  bool isPhoneVerified)?  $default,) {final _that = this;
switch (_that) {
case _ResidentModel() when $default != null:
return $default(_that.uid,_that.name,_that.email,_that.lot,_that.house,_that.accountStatus,_that.phone,_that.residentType,_that.role,_that.isPhoneVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResidentModel implements ResidentModel {
  const _ResidentModel({required this.uid, required this.name, required this.email, this.lot = '', this.house = '', required this.accountStatus, this.phone, this.residentType, this.role = 'vecino', this.isPhoneVerified = false});
  factory _ResidentModel.fromJson(Map<String, dynamic> json) => _$ResidentModelFromJson(json);

@override final  String uid;
@override final  String name;
@override final  String email;
@override@JsonKey() final  String lot;
@override@JsonKey() final  String house;
@override final  String accountStatus;
@override final  String? phone;
@override final  String? residentType;
@override@JsonKey() final  String role;
@override@JsonKey() final  bool isPhoneVerified;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResidentModelCopyWith<_ResidentModel> get copyWith => __$ResidentModelCopyWithImpl<_ResidentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResidentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResidentModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.lot, lot) || other.lot == lot)&&(identical(other.house, house) || other.house == house)&&(identical(other.accountStatus, accountStatus) || other.accountStatus == accountStatus)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.residentType, residentType) || other.residentType == residentType)&&(identical(other.role, role) || other.role == role)&&(identical(other.isPhoneVerified, isPhoneVerified) || other.isPhoneVerified == isPhoneVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,email,lot,house,accountStatus,phone,residentType,role,isPhoneVerified);

@override
String toString() {
  return 'ResidentModel(uid: $uid, name: $name, email: $email, lot: $lot, house: $house, accountStatus: $accountStatus, phone: $phone, residentType: $residentType, role: $role, isPhoneVerified: $isPhoneVerified)';
}


}

/// @nodoc
abstract mixin class _$ResidentModelCopyWith<$Res> implements $ResidentModelCopyWith<$Res> {
  factory _$ResidentModelCopyWith(_ResidentModel value, $Res Function(_ResidentModel) _then) = __$ResidentModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String name, String email, String lot, String house, String accountStatus, String? phone, String? residentType, String role, bool isPhoneVerified
});




}
/// @nodoc
class __$ResidentModelCopyWithImpl<$Res>
    implements _$ResidentModelCopyWith<$Res> {
  __$ResidentModelCopyWithImpl(this._self, this._then);

  final _ResidentModel _self;
  final $Res Function(_ResidentModel) _then;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? name = null,Object? email = null,Object? lot = null,Object? house = null,Object? accountStatus = null,Object? phone = freezed,Object? residentType = freezed,Object? role = null,Object? isPhoneVerified = null,}) {
  return _then(_ResidentModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,lot: null == lot ? _self.lot : lot // ignore: cast_nullable_to_non_nullable
as String,house: null == house ? _self.house : house // ignore: cast_nullable_to_non_nullable
as String,accountStatus: null == accountStatus ? _self.accountStatus : accountStatus // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,residentType: freezed == residentType ? _self.residentType : residentType // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isPhoneVerified: null == isPhoneVerified ? _self.isPhoneVerified : isPhoneVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
