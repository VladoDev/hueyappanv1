import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../data/datasources/notifications_datasource.dart';
import '../../data/repositories/notifications_repository_impl.dart';

final notificationsDatasourceProvider = Provider<NotificationsDatasource>((
  ref,
) {
  return NotificationsDatasource();
});

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  final datasource = ref.watch(notificationsDatasourceProvider);
  return NotificationsRepositoryImpl(datasource);
});

final notificationsProvider = StreamProvider<List<NotificationEntity>>((ref) {
  final user = ref.watch(firebaseUserProvider).value;
  if (user == null) return Stream.value([]);

  final repository = ref.watch(notificationsRepositoryProvider);
  return repository.watchNotifications(user.uid);
});
