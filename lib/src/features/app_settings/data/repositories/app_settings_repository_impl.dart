import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../domain/repositories/app_settings_repository.dart';
import '../datasources/app_settings_firebase_datasource.dart';

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepositoryImpl(
    ref.watch(appSettingsFirebaseDatasourceProvider),
  );
});

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsFirebaseDatasource _datasource;

  AppSettingsRepositoryImpl(this._datasource);

  @override
  Stream<AppSettingsEntity?> watchAppSettings() {
    return _datasource.watchAppSettings().map((data) {
      if (data == null) return null;
      try {
        return AppSettingsEntity.fromJson(data);
      } catch (e) {
        return null;
      }
    });
  }
}
