import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const _persistentDeviceIdKey = 'persistent_device_id';
  final FlutterSecureStorage _secureStorage;
  final DeviceInfoPlugin _deviceInfo;

  DeviceIdService({
    FlutterSecureStorage? secureStorage,
    DeviceInfoPlugin? deviceInfo,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        ),
        _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  Future<String> getOrCreatePersistentDeviceId() async {
    // 1. Try to read existing ID from SecureStorage (Keychain on iOS)
    var deviceId = await _secureStorage.read(key: _persistentDeviceIdKey);
    if (deviceId != null && deviceId.isNotEmpty) {
      return deviceId;
    }

    // 2. If it doesn't exist, generate a new one and save it
    if (Platform.isAndroid) {
      // On Android, use Android ID as it persists across reinstalls (unless factory reset)
      final androidInfo = await _deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else {
      // On iOS, generate a UUID and save it to Keychain (persists across reinstalls)
      deviceId = const Uuid().v4();
    }

    await _secureStorage.write(key: _persistentDeviceIdKey, value: deviceId);
    return deviceId;
  }
}
