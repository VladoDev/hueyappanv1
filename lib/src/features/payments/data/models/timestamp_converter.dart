import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    } else if (json is Map) {
      // Handles cases where Timestamp is serialized as Map in some environments
      final seconds = json['_seconds'] as int?;
      final nanoseconds = json['_nanoseconds'] as int?;
      if (seconds != null) {
        return Timestamp(seconds, nanoseconds ?? 0).toDate();
      }
    }
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime date) => Timestamp.fromDate(date);
}

class NullableTimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    } else if (json is Map) {
      final seconds = json['_seconds'] as int?;
      final nanoseconds = json['_nanoseconds'] as int?;
      if (seconds != null) {
        return Timestamp(seconds, nanoseconds ?? 0).toDate();
      }
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? date) => date != null ? Timestamp.fromDate(date) : null;
}
