import '../entities/notification_entity.dart';

abstract class NotificationsRepository {
  Stream<List<NotificationEntity>> watchNotifications(String uid);
  Future<void> markAsRead(String uid, String notificationId);
}
