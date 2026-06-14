import 'package:cloud_firestore/cloud_firestore.dart';

class SecurityEventEntity {
  final String id;
  final String userId;
  final String? userName;
  final String eventType;
  final DateTime timestamp;

  SecurityEventEntity({
    required this.id,
    required this.userId,
    this.userName,
    required this.eventType,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      if (userName != null) 'userName': userName,
      'eventType': eventType,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
