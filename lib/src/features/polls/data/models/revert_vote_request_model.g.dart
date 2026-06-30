// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revert_vote_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RevertVoteRequestModel _$RevertVoteRequestModelFromJson(
  Map<String, dynamic> json,
) => _RevertVoteRequestModel(
  id: json['id'] as String,
  pollId: json['pollId'] as String,
  pollTitle: json['pollTitle'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  houseId: json['houseId'] as String,
  previousOptionId: json['previousOptionId'] as String,
  status: json['status'] as String? ?? 'pending',
  createdAt: _timestampToDateTime(json['createdAt'] as Timestamp),
);

Map<String, dynamic> _$RevertVoteRequestModelToJson(
  _RevertVoteRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'pollId': instance.pollId,
  'pollTitle': instance.pollTitle,
  'userId': instance.userId,
  'userName': instance.userName,
  'houseId': instance.houseId,
  'previousOptionId': instance.previousOptionId,
  'status': instance.status,
  'createdAt': _dateTimeToTimestamp(instance.createdAt),
};
