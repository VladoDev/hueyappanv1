import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/resident_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/datasources/auth_firebase_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_with_email_usecase.dart';

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


class AuthController extends Notifier<AsyncValue<ResidentEntity?>> {
  @override
  AsyncValue<ResidentEntity?> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final loginUsecase = ref.read(loginWithEmailUsecaseProvider);
      final user = await loginUsecase.execute(email, password);
      state = AsyncValue.data(user);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
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
      state = AsyncValue.data(user);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

}

final authControllerProvider =
    NotifierProvider.autoDispose<AuthController, AsyncValue<ResidentEntity?>>(AuthController.new);

