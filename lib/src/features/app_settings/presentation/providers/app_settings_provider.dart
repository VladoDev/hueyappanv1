import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../data/repositories/app_settings_repository_impl.dart';

final appSettingsProvider = StreamProvider<AppSettingsEntity?>((ref) {
  final repository = ref.watch(appSettingsRepositoryProvider);
  return repository.watchAppSettings();
});
