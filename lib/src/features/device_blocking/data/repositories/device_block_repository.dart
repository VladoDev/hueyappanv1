import 'package:flutter/foundation.dart';
import '../datasources/device_block_datasource.dart';
import '../datasources/device_block_local_datasource.dart';
import '../services/device_id_service.dart';

class DeviceBlockStatus {
  final bool isBlocked;
  final String deviceId;

  const DeviceBlockStatus({required this.isBlocked, required this.deviceId});
}

class DeviceBlockRepository {
  final DeviceIdService _idService;
  final DeviceBlockDatasource _remoteDatasource;
  final DeviceBlockLocalDatasource _localDatasource;

  DeviceBlockRepository({
    DeviceIdService? idService,
    DeviceBlockDatasource? remoteDatasource,
    DeviceBlockLocalDatasource? localDatasource,
  })  : _idService = idService ?? DeviceIdService(),
        _remoteDatasource = remoteDatasource ?? DeviceBlockDatasource(),
        _localDatasource = localDatasource ?? DeviceBlockLocalDatasource();

  Future<String> getDeviceId() async {
    return await _idService.getOrCreatePersistentDeviceId();
  }

  Future<DeviceBlockStatus> checkBlockStatus() async {
    final deviceId = await getDeviceId();
    
    // 1. Check local status first (handles offline case and immediate blocking)
    final isLocallyBlocked = await _localDatasource.isDeviceBlockedLocally();
    
    try {
      // 2. Try to verify with server
      final isRemotelyBlocked = await _remoteDatasource.isDeviceBlocked(deviceId);
      
      // 3. Sync local status with remote
      if (isRemotelyBlocked != isLocallyBlocked) {
        await _localDatasource.setDeviceBlocked(isRemotelyBlocked);
      }
      
      return DeviceBlockStatus(isBlocked: isRemotelyBlocked, deviceId: deviceId);
    } catch (e) {
      debugPrint('Error checking remote block status: $e');
      // If network fails, fallback to local status
      return DeviceBlockStatus(isBlocked: isLocallyBlocked, deviceId: deviceId);
    }
  }

  Future<void> syncDeviceIdForUser(String uid) async {
    final deviceId = await getDeviceId();
    await _remoteDatasource.saveDeviceIdToResident(uid, deviceId);
  }
}
