import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/resident_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/datasources/auth_firebase_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_with_email_usecase.dart';
import '../../domain/usecases/send_password_reset_usecase.dart';
import '../../data/datasources/biometric_service.dart';
import 'biometric_provider.dart';

final authFirebaseDatasourceProvider = Provider<AuthFirebaseDatasource>((ref) {
  return AuthFirebaseDatasource();
});

final firebaseUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(authFirebaseDatasourceProvider).authStateChanges;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(authFirebaseDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

final authStateProvider = StreamProvider<ResidentEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final loginWithEmailUsecaseProvider = Provider<LoginWithEmailUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginWithEmailUsecase(repository);
});

final sendPasswordResetUsecaseProvider = Provider<SendPasswordResetUsecase>((
  ref,
) {
  final repository = ref.watch(authRepositoryProvider);
  return SendPasswordResetUsecase(repository);
});

class AuthController extends Notifier<AsyncValue<ResidentEntity?>> {
  @override
  AsyncValue<ResidentEntity?> build() {
    return const AsyncValue.data(null);
  }

  /// Standard email/password login.
  /// Returns the email/password used on success (for biometric save flow).
  Future<({bool success, String email, String password})?> login(
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();
    try {
      // Invalidate providers before logging in to guarantee clean state
      ref.invalidate(authStateProvider);
      ref.invalidate(firebaseUserProvider);

      final loginUsecase = ref.read(loginWithEmailUsecaseProvider);
      final user = await loginUsecase.execute(email, password);
      if (ref.mounted) {
        state = AsyncValue.data(user);
      }
      return (success: true, email: email, password: password);
    } catch (e, stack) {
      if (ref.mounted) {
        state = AsyncValue.error(e, stack);
      }
      return null;
    }
  }

  /// Login using stored biometric credentials.
  Future<bool> loginWithBiometrics(
    BiometricService biometricService,
    String localizedReason,
  ) async {
    state = const AsyncValue.loading();
    try {
      // 1. Authenticate with biometrics
      final authenticated = await biometricService.authenticate(
        localizedReason,
      );
      if (!authenticated) {
        if (ref.mounted) {
          state = const AsyncValue.data(null);
        }
        return false;
      }

      // 2. Retrieve stored credentials
      final credentials = await biometricService.getCredentials();
      if (credentials == null) {
        if (ref.mounted) {
          state = AsyncValue.error(
            Exception('No stored credentials found.'),
            StackTrace.current,
          );
        }
        return false;
      }

      // 3. Login with Firebase using stored credentials
      ref.invalidate(authStateProvider);
      ref.invalidate(firebaseUserProvider);

      final loginUsecase = ref.read(loginWithEmailUsecaseProvider);
      final user = await loginUsecase.execute(
        credentials.email,
        credentials.password,
      );
      if (ref.mounted) {
        state = AsyncValue.data(user);
      }
      return true;
    } catch (e, stack) {
      if (ref.mounted) {
        state = AsyncValue.error(e, stack);
      }
      return false;
    }
  }

  /// Send password reset email.
  Future<bool> sendPasswordReset(String email) async {
    try {
      final usecase = ref.read(sendPasswordResetUsecaseProvider);
      await usecase.execute(email);
      return true;
    } catch (e, stack) {
      if (ref.mounted) {
        state = AsyncValue.error(e, stack);
      }
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String lot,
    required String house,
    required String residentType,
    required String phone,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.registerWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        lot: lot,
        house: house,
        residentType: residentType,
        phone: phone,
      );
      if (ref.mounted) {
        state = AsyncValue.data(user);
      }
      return true;
    } catch (e, stack) {
      if (ref.mounted) {
        state = AsyncValue.error(e, stack);
      }
      return false;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      if (ref.mounted) {
        state = const AsyncValue.data(null);
        // Invalidate providers on logout to clear session profile
        ref.invalidate(authStateProvider);
        ref.invalidate(firebaseUserProvider);
      }
    } catch (e, stack) {
      if (ref.mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }
}

final authControllerProvider =
    NotifierProvider.autoDispose<AuthController, AsyncValue<ResidentEntity?>>(
      AuthController.new,
    );
