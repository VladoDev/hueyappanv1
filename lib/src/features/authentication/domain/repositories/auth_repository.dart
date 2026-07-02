import '../entities/resident_entity.dart';

abstract class AuthRepository {
  Stream<ResidentEntity?> get authStateChanges;
  Future<ResidentEntity> loginWithEmail(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logout();
  Future<ResidentEntity?> getCurrentResident();

  Future<ResidentEntity> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String lot,
    required String house,
    required String residentType,
    required String phone,
  });
}
