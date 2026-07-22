import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceBlockLocalDatasource {
  static const _isBlockedKey = 'device_is_blocked';
  final FlutterSecureStorage _secureStorage;

  DeviceBlockLocalDatasource({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  Future<bool> isDeviceBlockedLocally() async {
    final value = await _secureStorage.read(key: _isBlockedKey);
    return value == 'true';
  }

  Future<void> setDeviceBlocked(bool isBlocked) async {
    if (isBlocked) {
      await _secureStorage.write(key: _isBlockedKey, value: 'true');
    } else {
      await _secureStorage.delete(key: _isBlockedKey);
    }
  }
}
