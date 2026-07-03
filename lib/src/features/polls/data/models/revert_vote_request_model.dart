import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/revert_vote_request_entity.dart';

part 'revert_vote_request_model.freezed.dart';
part 'revert_vote_request_model.g.dart';

@freezed
abstract class RevertVoteRequestModel with _$RevertVoteRequestModel {
  const RevertVoteRequestModel._();

  const factory RevertVoteRequestModel({
    required String id,
    required String pollId,
    required String pollTitle,
    required String userId,
    required String userName,
    required String houseId,
    required String previousOptionId,
    @Default('pending') String status,
    @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
  }) = _RevertVoteRequestModel;

  factory RevertVoteRequestModel.fromJson(Map<String, dynamic> json) => _$RevertVoteRequestModelFromJson(json);

  RevertVoteRequestEntity toEntity() {
    return RevertVoteRequestEntity(
      id: id,
      pollId: pollId,
      pollTitle: pollTitle,
      userId: userId,
      userName: userName,
      houseId: houseId,
      previousOptionId: previousOptionId,
      status: _stringToStatus(status),
      createdAt: createdAt,
    );
  }

  factory RevertVoteRequestModel.fromEntity(RevertVoteRequestEntity entity) {
    return RevertVoteRequestModel(
      id: entity.id,
      pollId: entity.pollId,
      pollTitle: entity.pollTitle,
      userId: entity.userId,
      userName: entity.userName,
      houseId: entity.houseId,
      previousOptionId: entity.previousOptionId,
      status: _statusToString(entity.status),
      createdAt: entity.createdAt,
    );
  }
}

DateTime _timestampToDateTime(Timestamp timestamp) => timestamp.toDate();
Timestamp _dateTimeToTimestamp(DateTime dateTime) => Timestamp.fromDate(dateTime);

RevertRequestStatus _stringToStatus(String status) {
  switch (status) {
    case 'approved':
      return RevertRequestStatus.approved;
    case 'rejected':
      return RevertRequestStatus.rejected;
    case 'pending':
    default:
      return RevertRequestStatus.pending;
  }
}

String _statusToString(RevertRequestStatus status) {
  switch (status) {
    case RevertRequestStatus.approved:
      return 'approved';
    case RevertRequestStatus.rejected:
      return 'rejected';
    case RevertRequestStatus.pending:
    default:
      return 'pending';
  }
}
