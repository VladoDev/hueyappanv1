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

  Stream<DeviceBlockStatus> watchBlockStatus() async* {
    final deviceId = await getDeviceId();
    
    // 1. Initial local status (handles offline and immediate start)
    final isLocallyBlocked = await _localDatasource.isDeviceBlockedLocally();
    yield DeviceBlockStatus(isBlocked: isLocallyBlocked, deviceId: deviceId);
    
    // 2. Yield from remote stream and sync to local storage
    yield* _remoteDatasource.watchDeviceBlocked(deviceId).map((isRemotelyBlocked) {
      _localDatasource.setDeviceBlocked(isRemotelyBlocked); // Always sync latest
      return DeviceBlockStatus(isBlocked: isRemotelyBlocked, deviceId: deviceId);
    });
  }

  Future<void> syncDeviceIdForUser(String uid) async {
    final deviceId = await getDeviceId();
    await _remoteDatasource.saveDeviceIdToResident(uid, deviceId);
  }
}
