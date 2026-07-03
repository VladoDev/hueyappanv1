// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PollModel _$PollModelFromJson(Map<String, dynamic> json) => _PollModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => PollOptionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  votedHouseholds:
      (json['votedHouseholds'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  createdAt: _timestampToDateTime(json['createdAt'] as Timestamp),
  createdBy: json['createdBy'] as String,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$PollModelToJson(_PollModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'options': instance.options,
      'votedHouseholds': instance.votedHouseholds,
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'createdBy': instance.createdBy,
      'isActive': instance.isActive,
    };

_PollOptionModel _$PollOptionModelFromJson(Map<String, dynamic> json) =>
    _PollOptionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      votesCount: (json['votesCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PollOptionModelToJson(_PollOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'votesCount': instance.votesCount,
    };
