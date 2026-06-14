import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/water_status_entity.dart';
import '../../domain/repositories/water_status_repository.dart';
import '../../data/datasources/water_status_firebase_datasource.dart';
import '../../data/repositories/water_status_repository_impl.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

final waterStatusDatasourceProvider = Provider<WaterStatusFirebaseDatasource>((ref) {
  return WaterStatusFirebaseDatasource();
});

final waterStatusRepositoryProvider = Provider<WaterStatusRepository>((ref) {
  final datasource = ref.watch(waterStatusDatasourceProvider);
  return WaterStatusRepositoryImpl(datasource);
});

final waterStatusProvider = StreamProvider<WaterStatusEntity>((ref) {
  final repository = ref.watch(waterStatusRepositoryProvider);
  return repository.watchWaterStatus();
});

final updateWaterStatusProvider = FutureProvider.family<void, String>((ref, status) async {
  final repository = ref.watch(waterStatusRepositoryProvider);
  final currentUser = ref.read(authStateProvider).value;
  if (currentUser != null) {
    await repository.updateWaterStatus(status, currentUser.uid);
  }
});
