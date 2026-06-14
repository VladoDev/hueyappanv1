import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsDatasource _dataSource;

  NotificationsRepositoryImpl(this._dataSource);

  @override
  Stream<List<NotificationEntity>> watchNotifications(String uid) {
    return _dataSource.watchNotifications(uid).map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<void> markAsRead(String uid, String notificationId) {
    return _dataSource.markAsRead(uid, notificationId);
  }
}
