import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/resident_model.dart';

class AuthFirebaseDatasource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;
  final FirebaseAnalytics _analytics;

  AuthFirebaseDatasource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseMessaging? messaging,
    FirebaseAnalytics? analytics,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _messaging = messaging ?? FirebaseMessaging.instance,
       _analytics = analytics ?? FirebaseAnalytics.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> saveResidentProfile(String uid, ResidentModel profile) {
    // Exclude 'uid' from the saved document payload to keep Firestore clean
    final data = profile.toJson()..remove('uid');
    return _firestore.collection('residents').doc(uid).set(data);
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<ResidentModel?> getResidentProfile(String uid) async {
    final doc = await _firestore.collection('residents').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;

    final data = Map<String, dynamic>.from(doc.data()!);
    data.putIfAbsent('uid', () => uid);
    return ResidentModel.fromJson(data);
  }

  Stream<ResidentModel?> watchResidentProfile(String uid) {
    return _firestore.collection('residents').doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      final data = Map<String, dynamic>.from(doc.data()!);
      data.putIfAbsent('uid', () => uid);
      return ResidentModel.fromJson(data);
    });
  }

  Future<void> registerDeviceToken(String uid) async {
    try {
      // Request permission for notifications
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        criticalAlert: true,
      );
      debugPrint(
        '🔔 [Notifications] Permission status: ${settings.authorizationStatus}',
      );

      // Get APNs token for iOS diagnostics
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _messaging.getAPNSToken();
        debugPrint('🔔 [Notifications] iOS APNs Token: $apnsToken');
        if (apnsToken == null) {
          debugPrint(
            '⚠️ [Notifications] APNs Token is null. Push notifications will NOT arrive. Check Provisioning Profiles and capabilities in Xcode.',
          );
        }
      }

      final token = await _messaging.getToken();
      debugPrint('🔔 [Notifications] FCM Device Token: $token');
      if (token == null) return;

      // Subscribe to emergencies topic
      await _messaging.subscribeToTopic('emergencies');
      await _messaging.subscribeToTopic('payments');
      debugPrint(
        '🔔 [Notifications] Subscribed to topic: emergencies and payments',
      );

      await _firestore
          .collection('residents')
          .doc(uid)
          .collection('devices')
          .doc(token)
          .set({
            'token': token,
            'platform': _getPlatformName(),
            'updatedAt': FieldValue.serverTimestamp(),
            'isActive': true,
          }, SetOptions(merge: true));
    } catch (e, stackTrace) {
      debugPrint('❌ [Notifications] Error registering device token: $e');
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'registerDeviceToken failed',
      );
    }
  }

  Future<void> unregisterDeviceToken(String uid) async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;

      // Unsubscribe from emergencies topic
      await _messaging.unsubscribeFromTopic('emergencies');
      await _messaging.unsubscribeFromTopic('payments');

      await _firestore
          .collection('residents')
          .doc(uid)
          .collection('devices')
          .doc(token)
          .update({
            'isActive': false,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e, stackTrace) {
      debugPrint('Error unregistering device token: $e');
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'unregisterDeviceToken failed',
      );
    }
  }

  String _getPlatformName() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      default:
        return 'unknown';
    }
  }

  Future<void> triggerEmergencyAlarm(
    String uid,
    String name,
    String lot,
    String house,
  ) async {
    try {
      // 1. Write the emergency event to Firestore
      await _firestore.collection('emergencies').add({
        'triggeredBy': uid,
        'triggeredByName': name,
        'triggeredByLot': lot,
        'triggeredByHouse': house,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      // Log success event to Analytics
      await _analytics.logEvent(
        name: 'trigger_emergency',
        parameters: {'triggered_by_uid': uid, 'triggered_by_name': name},
      );

      // Note: We used to send a direct legacy FCM push here as a fallback,
      // but legacy FCM HTTP API does not support APNs critical flags (it ignores the 'apns' root object).
      // We now rely exclusively on the Firebase Cloud Function 'broadcastEmergencyAlert'
      // which uses the Firebase Admin SDK (FCM HTTP v1 API) to properly format and send critical alerts.
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Failed to trigger emergency alarm',
      );
      rethrow;
    }
  }

  Stream<Map<String, dynamic>?> watchEmergencies() {
    return _firestore
        .collection('emergencies')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          final doc = snapshot.docs.first;
          final data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
          return data;
        });
  }

  Future<void> requestPhoneVerification(
    String uid,
    String phone,
    String name,
    String lot,
    String house,
  ) async {
    await _firestore.collection('phone_verifications').doc(uid).set({
      'phone': phone,
      'name': name,
      'lot': lot,
      'house': house,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> verifyPhoneOtp(String uid, String otp) async {
    try {
      // Usar HTTPS callable function o llamar al endpoint HTTP de la cloud function 'verifyOtp'
      // Dado que implementaremos las funciones como http endpoints o callable, asumiremos la URL.
      // Por simplicidad si no usamos cloud_functions package, podemos guardar el otp ingresado
      // en el documento y que una function lo procese, pero es asíncrono.
      // La mejor opción es escribir a Firestore y escuchar el resultado, o usar un endpoint HTTP.
      // Para efectos de este código, simularemos la llamada HTTP a la función `verifyOtp`.
      // En un entorno real de Firebase sin paquete cloud_functions, tendrías la URL de tu function.
      // Para simplificar, implementaremos la verificación de OTP comprobando el Firestore
      // asumiendo que la Cloud Function actualizó el perfil del usuario si es correcto.
      // Pero como el backend lo haremos como Cloud Function HTTP, escribiremos el request.
      // Como no conocemos la URL, una alternativa válida es que la app modifique un campo
      // 'submittedOtp' en el documento phone_verifications, y escuche los cambios.

      // Enfoque Firestore listener:
      final docRef = _firestore.collection('phone_verifications').doc(uid);
      await docRef.update({
        'submittedOtp': otp,
        'submittedAt': FieldValue.serverTimestamp(),
      });

      // Esperar hasta 10 segundos para ver si la Cloud Function lo marca como 'verified'
      // o 'failed'.
      // Alternativa más robusta:
      int retries = 0;
      while (retries < 20) {
        await Future.delayed(const Duration(milliseconds: 500));
        final snapshot = await docRef.get();
        final status = snapshot.data()?['status'] as String?;
        if (status == 'verified') {
          return true;
        } else if (status == 'failed') {
          return false;
        }
        retries++;
      }
      return false; // Timeout
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
      return false;
    }
  }
}
