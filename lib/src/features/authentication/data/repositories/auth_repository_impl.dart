import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
    try {
      final userCredential =
          await _dataSource.signInWithEmailAndPassword(email, password);
      final uid = userCredential.user!.uid;

      final profile = await _dataSource.getResidentProfile(uid);
      if (profile == null) {
        throw Exception('Resident profile not found in database.');
      }

      await _dataSource.registerDeviceToken(uid);

      // Track successful login in Analytics and configure Crashlytics user identifier
      await FirebaseAnalytics.instance.setUserId(id: uid);
      await FirebaseAnalytics.instance.logLogin(loginMethod: 'email');
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'resident_type',
        value: profile.residentType ?? 'unknown',
      );
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'user_role',
        value: profile.role,
      );
      
      await FirebaseCrashlytics.instance.setUserIdentifier(uid);
      await FirebaseCrashlytics.instance.setCustomKey('resident_type', profile.residentType ?? 'unknown');
      await FirebaseCrashlytics.instance.setCustomKey('user_role', profile.role);

      return profile.toEntity();
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Login failed',
      );
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      final user = _dataSource.currentUser;
      if (user != null) {
        try {
          await _dataSource.unregisterDeviceToken(user.uid);
        } catch (e) {
          // Ignore token unregister errors to ensure we always sign out locally
        }
      }
      
      // Clear identifiers in Analytics and Crashlytics
      await FirebaseAnalytics.instance.setUserId(id: null);
      await FirebaseCrashlytics.instance.setUserIdentifier('');
      
      await _dataSource.signOut();
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Logout failed',
      );
      rethrow;
    }
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
    try {
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
      // 3. Create the model
      final profile = ResidentModel(
        uid: uid,
        name: fullName,
        email: email.trim(),
        lot: lot,
        house: house.trim(),
        accountStatus: 'Active',
        phone: phone.trim(),
        residentType: residentType,
        role: 'vecino',
      );

      // 4. Save to Firestore
      await _dataSource.saveResidentProfile(uid, profile);

      // 5. Register device token for push notifications
      await _dataSource.registerDeviceToken(uid);

      // Track successful sign up in Analytics and configure Crashlytics user identifier
      await FirebaseAnalytics.instance.setUserId(id: uid);
      await FirebaseAnalytics.instance.logSignUp(signUpMethod: 'email');
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'resident_type',
        value: residentType,
      );
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'user_role',
        value: 'vecino',
      );

      await FirebaseCrashlytics.instance.setUserIdentifier(uid);
      await FirebaseCrashlytics.instance.setCustomKey('resident_type', residentType);
      await FirebaseCrashlytics.instance.setCustomKey('user_role', 'vecino');

      return profile.toEntity();
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Registration failed',
      );
      rethrow;
    }
  }
}
