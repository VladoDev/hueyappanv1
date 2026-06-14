import 'package:flutter_test/flutter_test.dart';
import 'package:hueyappanv1/src/features/authentication/domain/entities/resident_entity.dart';
import 'package:hueyappanv1/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:hueyappanv1/src/features/authentication/domain/usecases/login_with_email_usecase.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Stream<ResidentEntity?> get authStateChanges => throw UnimplementedError();

  @override
  Future<ResidentEntity> loginWithEmail(String email, String password) async {
    return ResidentEntity(
      uid: '123',
      name: 'John Doe',
      email: email,
      lot: '148',
      house: 'A',
      accountStatus: 'Active',
      role: 'vecino',
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<ResidentEntity?> getCurrentResident() async => null;

  @override
  Future<ResidentEntity> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String lot,
    required String house,
    required String residentType,
    required String phone,
  }) async {
    return ResidentEntity(
      uid: '123',
      name: '$firstName $lastName',
      email: email,
      lot: lot,
      house: house,
      accountStatus: 'Active',
      phone: phone,
      residentType: residentType,
      role: 'vecino',
    );
  }
}

void main() {
  late MockAuthRepository mockRepository;
  late LoginWithEmailUsecase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginWithEmailUsecase(mockRepository);
  });

  group('LoginWithEmailUsecase tests', () {
    test('Should authenticate successfully with valid inputs', () async {
      final result = await usecase.execute('test@example.com', 'password123');
      expect(result.email, 'test@example.com');
      expect(result.name, 'John Doe');
    });

    test('Should throw ArgumentError if email is invalid', () {
      expect(
        () => usecase.execute('invalid-email', 'password123'),
        throwsArgumentError,
      );
    });

    test('Should throw ArgumentError if password is empty', () {
      expect(
        () => usecase.execute('test@example.com', ''),
        throwsArgumentError,
      );
    });

    test('Should throw ArgumentError if password is under 6 characters', () {
      expect(
        () => usecase.execute('test@example.com', '12345'),
        throwsArgumentError,
      );
    });
  });
}
