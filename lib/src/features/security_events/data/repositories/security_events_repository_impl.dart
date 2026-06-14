import 'package:hueyappanv1/src/features/security_events/data/datasources/security_events_firebase_datasource.dart';
import 'package:hueyappanv1/src/features/security_events/domain/entities/security_event_entity.dart';
import 'package:hueyappanv1/src/features/security_events/domain/repositories/security_events_repository.dart';

class SecurityEventsRepositoryImpl implements SecurityEventsRepository {
  final SecurityEventsFirebaseDatasource _datasource;

  SecurityEventsRepositoryImpl(this._datasource);

  @override
  Future<void> logEvent(SecurityEventEntity event) async {
    await _datasource.logEvent(event);
  }
}
