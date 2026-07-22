import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/device_block_repository.dart';

final deviceBlockRepositoryProvider = Provider<DeviceBlockRepository>((ref) {
  return DeviceBlockRepository();
});

final deviceIdProvider = FutureProvider<String>((ref) {
  return ref.watch(deviceBlockRepositoryProvider).getDeviceId();
});

final deviceBlockStatusProvider = StreamProvider<DeviceBlockStatus>((ref) {
  return ref.watch(deviceBlockRepositoryProvider).watchBlockStatus();
});
