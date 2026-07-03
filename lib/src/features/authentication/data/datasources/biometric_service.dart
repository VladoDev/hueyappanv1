import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service that encapsulates biometric authentication (local_auth)
/// and secure credential storage (flutter_secure_storage).
class BiometricService {
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;

  static const _keyEmail = 'biometric_email';
  static const _keyPassword = 'biometric_password';
  static const _keyEnabled = 'biometric_enabled';

  BiometricService({
    LocalAuthentication? localAuth,
    FlutterSecureStorage? secureStorage,
  }) : _localAuth = localAuth ?? LocalAuthentication(),
       _secureStorage =
           secureStorage ??
           const FlutterSecureStorage(
             aOptions: AndroidOptions(encryptedSharedPreferences: true),
           );

  /// Check if the device supports biometric authentication.
  Future<bool> canCheckBiometrics() async {
    try {
      final canAuth = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canAuth && isDeviceSupported;
    } on PlatformException catch (e) {
      debugPrint('❌ [Biometrics] canCheckBiometrics error: $e');
      return false;
    }
  }

  /// Get list of available biometric types on the device.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint('❌ [Biometrics] getAvailableBiometrics error: $e');
      return [];
    }
  }

  /// Prompt the user for biometric authentication.
  Future<bool> authenticate(String localizedReason) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('❌ [Biometrics] authenticate error: $e');
      return false;
    }
  }

  /// Save user credentials securely.
  Future<void> saveCredentials(String email, String password) async {
    await _secureStorage.write(key: _keyEmail, value: email);
    await _secureStorage.write(key: _keyPassword, value: password);
  }

  /// Retrieve stored credentials. Returns null if not available.
  Future<({String email, String password})?> getCredentials() async {
    final email = await _secureStorage.read(key: _keyEmail);
    final password = await _secureStorage.read(key: _keyPassword);
    if (email == null || password == null) return null;
    return (email: email, password: password);
  }

  /// Check if credentials are stored.
  Future<bool> hasStoredCredentials() async {
    final email = await _secureStorage.read(key: _keyEmail);
    final password = await _secureStorage.read(key: _keyPassword);
    return email != null && password != null;
  }

  /// Clear stored credentials.
  Future<void> clearCredentials() async {
    await _secureStorage.delete(key: _keyEmail);
    await _secureStorage.delete(key: _keyPassword);
    await _secureStorage.delete(key: _keyEnabled);
  }

  /// Set biometric login preference.
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(key: _keyEnabled, value: enabled.toString());
  }

  /// Check if user has enabled biometric login.
  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _keyEnabled);
    return value == 'true';
  }
}
