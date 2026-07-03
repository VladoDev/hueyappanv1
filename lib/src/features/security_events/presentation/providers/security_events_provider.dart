import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/src/features/security_events/data/datasources/security_events_firebase_datasource.dart';
import 'package:hueyappanv1/src/features/security_events/data/repositories/security_events_repository_impl.dart';
import 'package:hueyappanv1/src/features/security_events/domain/repositories/security_events_repository.dart';

final securityEventsDatasourceProvider =
    Provider<SecurityEventsFirebaseDatasource>((ref) {
      return SecurityEventsFirebaseDatasource();
    });

final securityEventsRepositoryProvider = Provider<SecurityEventsRepository>((
  ref,
) {
  final datasource = ref.watch(securityEventsDatasourceProvider);
  return SecurityEventsRepositoryImpl(datasource);
});
