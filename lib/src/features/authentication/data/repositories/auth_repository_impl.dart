import '../../domain/entities/resident_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_firebase_datasource.dart';
import '../models/resident_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDatasource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Stream<ResidentEntity?> get authStateChanges {
    return _dataSource.authStateChanges.asyncExpand((user) {
      if (user == null) {
        return Stream.value(null);
      }
      return _dataSource
          .watchResidentProfile(user.uid)
          .map((profile) => profile?.toEntity());
    });
  }

  @override
  Future<ResidentEntity> loginWithEmail(String email, String password) async {
    final userCredential =
        await _dataSource.signInWithEmailAndPassword(email, password);
    final uid = userCredential.user!.uid;

    final profile = await _dataSource.getResidentProfile(uid);
    if (profile == null) {
      throw Exception('Resident profile not found in database.');
    }

    await _dataSource.registerDeviceToken(uid);
    return profile.toEntity();
  }

  @override
  Future<void> logout() async {
    final user = _dataSource.currentUser;
    if (user != null) {
      await _dataSource.unregisterDeviceToken(user.uid);
    }
    await _dataSource.signOut();
  }

  @override
  Future<ResidentEntity?> getCurrentResident() async {
    final user = _dataSource.currentUser;
    if (user == null) return null;
    final profile = await _dataSource.getResidentProfile(user.uid);
    return profile?.toEntity();
  }

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
    // 1. Create the user in Firebase Auth if not already pre-authenticated
    final existingUser = _dataSource.currentUser;
    final String uid;
    if (existingUser != null) {
      uid = existingUser.uid;
    } else {
      final credential = await _dataSource.createUserWithEmailAndPassword(email, password);
      uid = credential.user!.uid;
    }

    // 2. Format names and address
    final fullName = '${firstName.trim()} ${lastName.trim()}';
    final housingUnit = 'Lote $lot - Casa $house';

    // 3. Create the model
    final profile = ResidentModel(
      uid: uid,
      name: fullName,
      email: email.trim(),
      housingUnit: housingUnit,
      accountStatus: 'Active',
      phone: phone.trim(),
      residentType: residentType,
    );

    // 4. Save to Firestore
    await _dataSource.saveResidentProfile(uid, profile);

    // 5. Register device token for push notifications
    await _dataSource.registerDeviceToken(uid);

    return profile.toEntity();
  }
}
