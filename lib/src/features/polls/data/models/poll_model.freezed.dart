// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollModel {

 String get id; String get title; String get description; List<PollOptionModel> get options; Map<String, String> get votedHouseholds;@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) DateTime get createdAt; String get createdBy; bool get isActive;
/// Create a copy of PollModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollModelCopyWith<PollModel> get copyWith => _$PollModelCopyWithImpl<PollModel>(this as PollModel, _$identity);

  /// Serializes this PollModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.votedHouseholds, votedHouseholds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(votedHouseholds),createdAt,createdBy,isActive);

@override
String toString() {
  return 'PollModel(id: $id, title: $title, description: $description, options: $options, votedHouseholds: $votedHouseholds, createdAt: $createdAt, createdBy: $createdBy, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $PollModelCopyWith<$Res>  {
  factory $PollModelCopyWith(PollModel value, $Res Function(PollModel) _then) = _$PollModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, List<PollOptionModel> options, Map<String, String> votedHouseholds,@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) DateTime createdAt, String createdBy, bool isActive
});




}
/// @nodoc
class _$PollModelCopyWithImpl<$Res>
    implements $PollModelCopyWith<$Res> {
  _$PollModelCopyWithImpl(this._self, this._then);

  final PollModel _self;
  final $Res Function(PollModel) _then;

/// Create a copy of PollModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? options = null,Object? votedHouseholds = null,Object? createdAt = null,Object? createdBy = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<PollOptionModel>,votedHouseholds: null == votedHouseholds ? _self.votedHouseholds : votedHouseholds // ignore: cast_nullable_to_non_nullable
as Map<String, String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PollModel].
extension PollModelPatterns on PollModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollModel value)  $default,){
final _that = this;
switch (_that) {
case _PollModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollModel value)?  $default,){
final _that = this;
switch (_that) {
case _PollModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<PollOptionModel> options,  Map<String, String> votedHouseholds, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)  DateTime createdAt,  String createdBy,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.options,_that.votedHouseholds,_that.createdAt,_that.createdBy,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<PollOptionModel> options,  Map<String, String> votedHouseholds, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)  DateTime createdAt,  String createdBy,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _PollModel():
return $default(_that.id,_that.title,_that.description,_that.options,_that.votedHouseholds,_that.createdAt,_that.createdBy,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  List<PollOptionModel> options,  Map<String, String> votedHouseholds, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)  DateTime createdAt,  String createdBy,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _PollModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.options,_that.votedHouseholds,_that.createdAt,_that.createdBy,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollModel extends PollModel {
  const _PollModel({required this.id, required this.title, required this.description, final  List<PollOptionModel> options = const [], final  Map<String, String> votedHouseholds = const {}, @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) required this.createdAt, required this.createdBy, this.isActive = true}): _options = options,_votedHouseholds = votedHouseholds,super._();
  factory _PollModel.fromJson(Map<String, dynamic> json) => _$PollModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
 final  List<PollOptionModel> _options;
@override@JsonKey() List<PollOptionModel> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  Map<String, String> _votedHouseholds;
@override@JsonKey() Map<String, String> get votedHouseholds {
  if (_votedHouseholds is EqualUnmodifiableMapView) return _votedHouseholds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_votedHouseholds);
}

@override@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) final  DateTime createdAt;
@override final  String createdBy;
@override@JsonKey() final  bool isActive;

/// Create a copy of PollModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollModelCopyWith<_PollModel> get copyWith => __$PollModelCopyWithImpl<_PollModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._options, _options)&&const DeepCollectionEquality().equals(other._votedHouseholds, _votedHouseholds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_options),const DeepCollectionEquality().hash(_votedHouseholds),createdAt,createdBy,isActive);

@override
String toString() {
  return 'PollModel(id: $id, title: $title, description: $description, options: $options, votedHouseholds: $votedHouseholds, createdAt: $createdAt, createdBy: $createdBy, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$PollModelCopyWith<$Res> implements $PollModelCopyWith<$Res> {
  factory _$PollModelCopyWith(_PollModel value, $Res Function(_PollModel) _then) = __$PollModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, List<PollOptionModel> options, Map<String, String> votedHouseholds,@JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp) DateTime createdAt, String createdBy, bool isActive
});




}
/// @nodoc
class __$PollModelCopyWithImpl<$Res>
    implements _$PollModelCopyWith<$Res> {
  __$PollModelCopyWithImpl(this._self, this._then);

  final _PollModel _self;
  final $Res Function(_PollModel) _then;

/// Create a copy of PollModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? options = null,Object? votedHouseholds = null,Object? createdAt = null,Object? createdBy = null,Object? isActive = null,}) {
  return _then(_PollModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<PollOptionModel>,votedHouseholds: null == votedHouseholds ? _self._votedHouseholds : votedHouseholds // ignore: cast_nullable_to_non_nullable
as Map<String, String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PollOptionModel {

 String get id; String get text; int get votesCount;
/// Create a copy of PollOptionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollOptionModelCopyWith<PollOptionModel> get copyWith => _$PollOptionModelCopyWithImpl<PollOptionModel>(this as PollOptionModel, _$identity);

  /// Serializes this PollOptionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollOptionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.votesCount, votesCount) || other.votesCount == votesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,votesCount);

@override
String toString() {
  return 'PollOptionModel(id: $id, text: $text, votesCount: $votesCount)';
}


}

/// @nodoc
abstract mixin class $PollOptionModelCopyWith<$Res>  {
  factory $PollOptionModelCopyWith(PollOptionModel value, $Res Function(PollOptionModel) _then) = _$PollOptionModelCopyWithImpl;
@useResult
$Res call({
 String id, String text, int votesCount
});




}
/// @nodoc
class _$PollOptionModelCopyWithImpl<$Res>
    implements $PollOptionModelCopyWith<$Res> {
  _$PollOptionModelCopyWithImpl(this._self, this._then);

  final PollOptionModel _self;
  final $Res Function(PollOptionModel) _then;

/// Create a copy of PollOptionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? votesCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,votesCount: null == votesCount ? _self.votesCount : votesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PollOptionModel].
extension PollOptionModelPatterns on PollOptionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollOptionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollOptionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollOptionModel value)  $default,){
final _that = this;
switch (_that) {
case _PollOptionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollOptionModel value)?  $default,){
final _that = this;
switch (_that) {
case _PollOptionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  int votesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollOptionModel() when $default != null:
return $default(_that.id,_that.text,_that.votesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  int votesCount)  $default,) {final _that = this;
switch (_that) {
case _PollOptionModel():
return $default(_that.id,_that.text,_that.votesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  int votesCount)?  $default,) {final _that = this;
switch (_that) {
case _PollOptionModel() when $default != null:
return $default(_that.id,_that.text,_that.votesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollOptionModel extends PollOptionModel {
  const _PollOptionModel({required this.id, required this.text, this.votesCount = 0}): super._();
  factory _PollOptionModel.fromJson(Map<String, dynamic> json) => _$PollOptionModelFromJson(json);

@override final  String id;
@override final  String text;
@override@JsonKey() final  int votesCount;

/// Create a copy of PollOptionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollOptionModelCopyWith<_PollOptionModel> get copyWith => __$PollOptionModelCopyWithImpl<_PollOptionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollOptionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollOptionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.votesCount, votesCount) || other.votesCount == votesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,votesCount);

@override
String toString() {
  return 'PollOptionModel(id: $id, text: $text, votesCount: $votesCount)';
}


}

/// @nodoc
abstract mixin class _$PollOptionModelCopyWith<$Res> implements $PollOptionModelCopyWith<$Res> {
  factory _$PollOptionModelCopyWith(_PollOptionModel value, $Res Function(_PollOptionModel) _then) = __$PollOptionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, int votesCount
});




}
/// @nodoc
class __$PollOptionModelCopyWithImpl<$Res>
    implements _$PollOptionModelCopyWith<$Res> {
  __$PollOptionModelCopyWithImpl(this._self, this._then);

  final _PollOptionModel _self;
  final $Res Function(_PollOptionModel) _then;

/// Create a copy of PollOptionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? votesCount = null,}) {
  return _then(_PollOptionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,votesCount: null == votesCount ? _self.votesCount : votesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
