// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'revert_vote_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RevertVoteRequestModel {

 String get id; String get pollId; String get pollTitle; String get userId; String get userName; String get houseId; String get previousOptionId; String get status;@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) DateTime get createdAt;
/// Create a copy of RevertVoteRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevertVoteRequestModelCopyWith<RevertVoteRequestModel> get copyWith => _$RevertVoteRequestModelCopyWithImpl<RevertVoteRequestModel>(this as RevertVoteRequestModel, _$identity);

  /// Serializes this RevertVoteRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RevertVoteRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pollId, pollId) || other.pollId == pollId)&&(identical(other.pollTitle, pollTitle) || other.pollTitle == pollTitle)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.houseId, houseId) || other.houseId == houseId)&&(identical(other.previousOptionId, previousOptionId) || other.previousOptionId == previousOptionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pollId,pollTitle,userId,userName,houseId,previousOptionId,status,createdAt);

@override
String toString() {
  return 'RevertVoteRequestModel(id: $id, pollId: $pollId, pollTitle: $pollTitle, userId: $userId, userName: $userName, houseId: $houseId, previousOptionId: $previousOptionId, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RevertVoteRequestModelCopyWith<$Res>  {
  factory $RevertVoteRequestModelCopyWith(RevertVoteRequestModel value, $Res Function(RevertVoteRequestModel) _then) = _$RevertVoteRequestModelCopyWithImpl;
@useResult
$Res call({
 String id, String pollId, String pollTitle, String userId, String userName, String houseId, String previousOptionId, String status,@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) DateTime createdAt
});




}
/// @nodoc
class _$RevertVoteRequestModelCopyWithImpl<$Res>
    implements $RevertVoteRequestModelCopyWith<$Res> {
  _$RevertVoteRequestModelCopyWithImpl(this._self, this._then);

  final RevertVoteRequestModel _self;
  final $Res Function(RevertVoteRequestModel) _then;

/// Create a copy of RevertVoteRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pollId = null,Object? pollTitle = null,Object? userId = null,Object? userName = null,Object? houseId = null,Object? previousOptionId = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as String,pollTitle: null == pollTitle ? _self.pollTitle : pollTitle // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,houseId: null == houseId ? _self.houseId : houseId // ignore: cast_nullable_to_non_nullable
as String,previousOptionId: null == previousOptionId ? _self.previousOptionId : previousOptionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RevertVoteRequestModel].
extension RevertVoteRequestModelPatterns on RevertVoteRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RevertVoteRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RevertVoteRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RevertVoteRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _RevertVoteRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RevertVoteRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _RevertVoteRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String pollId,  String pollTitle,  String userId,  String userName,  String houseId,  String previousOptionId,  String status, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RevertVoteRequestModel() when $default != null:
return $default(_that.id,_that.pollId,_that.pollTitle,_that.userId,_that.userName,_that.houseId,_that.previousOptionId,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String pollId,  String pollTitle,  String userId,  String userName,  String houseId,  String previousOptionId,  String status, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RevertVoteRequestModel():
return $default(_that.id,_that.pollId,_that.pollTitle,_that.userId,_that.userName,_that.houseId,_that.previousOptionId,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String pollId,  String pollTitle,  String userId,  String userName,  String houseId,  String previousOptionId,  String status, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RevertVoteRequestModel() when $default != null:
return $default(_that.id,_that.pollId,_that.pollTitle,_that.userId,_that.userName,_that.houseId,_that.previousOptionId,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RevertVoteRequestModel extends RevertVoteRequestModel {
  const _RevertVoteRequestModel({required this.id, required this.pollId, required this.pollTitle, required this.userId, required this.userName, required this.houseId, required this.previousOptionId, this.status = 'pending', @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) required this.createdAt}): super._();
  factory _RevertVoteRequestModel.fromJson(Map<String, dynamic> json) => _$RevertVoteRequestModelFromJson(json);

@override final  String id;
@override final  String pollId;
@override final  String pollTitle;
@override final  String userId;
@override final  String userName;
@override final  String houseId;
@override final  String previousOptionId;
@override@JsonKey() final  String status;
@override@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) final  DateTime createdAt;

/// Create a copy of RevertVoteRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RevertVoteRequestModelCopyWith<_RevertVoteRequestModel> get copyWith => __$RevertVoteRequestModelCopyWithImpl<_RevertVoteRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RevertVoteRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RevertVoteRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pollId, pollId) || other.pollId == pollId)&&(identical(other.pollTitle, pollTitle) || other.pollTitle == pollTitle)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.houseId, houseId) || other.houseId == houseId)&&(identical(other.previousOptionId, previousOptionId) || other.previousOptionId == previousOptionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pollId,pollTitle,userId,userName,houseId,previousOptionId,status,createdAt);

@override
String toString() {
  return 'RevertVoteRequestModel(id: $id, pollId: $pollId, pollTitle: $pollTitle, userId: $userId, userName: $userName, houseId: $houseId, previousOptionId: $previousOptionId, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RevertVoteRequestModelCopyWith<$Res> implements $RevertVoteRequestModelCopyWith<$Res> {
  factory _$RevertVoteRequestModelCopyWith(_RevertVoteRequestModel value, $Res Function(_RevertVoteRequestModel) _then) = __$RevertVoteRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String pollId, String pollTitle, String userId, String userName, String houseId, String previousOptionId, String status,@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) DateTime createdAt
});




}
/// @nodoc
class __$RevertVoteRequestModelCopyWithImpl<$Res>
    implements _$RevertVoteRequestModelCopyWith<$Res> {
  __$RevertVoteRequestModelCopyWithImpl(this._self, this._then);

  final _RevertVoteRequestModel _self;
  final $Res Function(_RevertVoteRequestModel) _then;

/// Create a copy of RevertVoteRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pollId = null,Object? pollTitle = null,Object? userId = null,Object? userName = null,Object? houseId = null,Object? previousOptionId = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_RevertVoteRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as String,pollTitle: null == pollTitle ? _self.pollTitle : pollTitle // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,houseId: null == houseId ? _self.houseId : houseId // ignore: cast_nullable_to_non_nullable
as String,previousOptionId: null == previousOptionId ? _self.previousOptionId : previousOptionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
