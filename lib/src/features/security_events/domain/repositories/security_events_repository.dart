import 'package:hueyappanv1/src/features/security_events/domain/entities/security_event_entity.dart';

abstract class SecurityEventsRepository {
  Future<void> logEvent(SecurityEventEntity event);
}
