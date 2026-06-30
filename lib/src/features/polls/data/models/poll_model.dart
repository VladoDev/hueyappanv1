import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/poll_entity.dart';

part 'poll_model.freezed.dart';
part 'poll_model.g.dart';

@freezed
abstract class PollModel with _$PollModel {
  const PollModel._();

  const factory PollModel({
    required String id,
    required String title,
    required String description,
    @Default([]) List<PollOptionModel> options,
    @Default({}) Map<String, String> votedHouseholds,
    @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    required String createdBy,
    @Default(true) bool isActive,
  }) = _PollModel;

  factory PollModel.fromJson(Map<String, dynamic> json) => _$PollModelFromJson(json);

  PollEntity toEntity() {
    return PollEntity(
      id: id,
      title: title,
      description: description,
      options: options.map((o) => o.toEntity()).toList(),
      votedHouseholds: votedHouseholds,
      createdAt: createdAt,
      createdBy: createdBy,
      isActive: isActive,
    );
  }

  factory PollModel.fromEntity(PollEntity entity) {
    return PollModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      options: entity.options.map((o) => PollOptionModel.fromEntity(o)).toList(),
      votedHouseholds: entity.votedHouseholds,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      isActive: entity.isActive,
    );
  }
}

@freezed
abstract class PollOptionModel with _$PollOptionModel {
  const PollOptionModel._();

  const factory PollOptionModel({
    required String id,
    required String text,
    @Default(0) int votesCount,
  }) = _PollOptionModel;

  factory PollOptionModel.fromJson(Map<String, dynamic> json) => _$PollOptionModelFromJson(json);

  PollOptionEntity toEntity() {
    return PollOptionEntity(
      id: id,
      text: text,
      votesCount: votesCount,
    );
  }

  factory PollOptionModel.fromEntity(PollOptionEntity entity) {
    return PollOptionModel(
      id: entity.id,
      text: entity.text,
      votesCount: entity.votesCount,
    );
  }
}

DateTime _timestampToDateTime(Timestamp timestamp) => timestamp.toDate();
Timestamp _dateTimeToTimestamp(DateTime dateTime) => Timestamp.fromDate(dateTime);
