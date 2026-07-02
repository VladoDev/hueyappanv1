import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/biometric_service.dart';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

/// Whether the device supports biometric authentication.
final biometricAvailableProvider = FutureProvider<bool>((ref) {
  return ref.watch(biometricServiceProvider).canCheckBiometrics();
});

/// Whether the user has opted-in to biometric login.
final biometricEnabledProvider = FutureProvider<bool>((ref) {
  return ref.watch(biometricServiceProvider).isBiometricEnabled();
});

/// Whether there are stored credentials available for biometric login.
final hasStoredCredentialsProvider = FutureProvider<bool>((ref) {
  return ref.watch(biometricServiceProvider).hasStoredCredentials();
});
