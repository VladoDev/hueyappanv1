import '../entities/app_settings_entity.dart';

abstract class AppSettingsRepository {
  Stream<AppSettingsEntity?> watchAppSettings();
}
