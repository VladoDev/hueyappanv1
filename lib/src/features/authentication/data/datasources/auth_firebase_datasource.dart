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
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _messaging = messaging ?? FirebaseMessaging.instance,
        _analytics = analytics ?? FirebaseAnalytics.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
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
      debugPrint('🔔 [Notifications] Permission status: ${settings.authorizationStatus}');

      // Get APNs token for iOS diagnostics
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _messaging.getAPNSToken();
        debugPrint('🔔 [Notifications] iOS APNs Token: $apnsToken');
        if (apnsToken == null) {
          debugPrint('⚠️ [Notifications] APNs Token is null. Push notifications will NOT arrive. Check Provisioning Profiles and capabilities in Xcode.');
        }
      }

      final token = await _messaging.getToken();
      debugPrint('🔔 [Notifications] FCM Device Token: $token');
      if (token == null) return;

      // Subscribe to emergencies topic
      await _messaging.subscribeToTopic('emergencies');
      await _messaging.subscribeToTopic('payments');
      debugPrint('🔔 [Notifications] Subscribed to topic: emergencies and payments');

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

  Future<void> triggerEmergencyAlarm(String uid, String name, String housingUnit) async {
    try {
      // 1. Write the emergency event to Firestore
      await _firestore.collection('emergencies').add({
        'triggeredBy': uid,
        'triggeredByName': name,
        'triggeredByHousingUnit': housingUnit,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      // Log success event to Analytics
      await _analytics.logEvent(
        name: 'trigger_emergency',
        parameters: {
          'triggered_by_uid': uid,
          'triggered_by_name': name,
        },
      );

      // 2. Try to fetch FCM legacy server key from Firestore config to send push notifications
      try {
        final configDoc = await _firestore.collection('config').doc('fcm').get();
        if (configDoc.exists && configDoc.data() != null) {
          final serverKey = configDoc.data()!['serverKey'] as String?;
          if (serverKey != null && serverKey.isNotEmpty) {
            await _sendDirectFcmPushNotification(serverKey, name, housingUnit);
          }
        }
      } catch (e, stackTrace) {
        debugPrint('FCM config not found or failed to read. Skipping direct push notification: $e');
        // Record non-fatal error in Crashlytics but do not block client
        await FirebaseCrashlytics.instance.recordError(
          e,
          stackTrace,
          reason: 'FCM direct push notification fallback failed',
        );
      }
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Failed to trigger emergency alarm',
      );
      rethrow;
    }
  }

  Future<void> _sendDirectFcmPushNotification(String serverKey, String senderName, String housingUnit) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };
    final body = {
      'to': '/topics/emergencies',
      'priority': 'high',
      'notification': {
        'title': '🚨 ¡ALERTA DE EMERGENCIA! 🚨',
        'body': 'El residente $senderName del lote $housingUnit ha activado una alarma de emergencia.',
        'sound': 'default',
      },
      'android': {
        'priority': 'high',
        'notification': {
          'sound': 'default',
          'channel_id': 'emergency_channel',
        },
      },
      'apns': {
        'payload': {
          'aps': {
            'sound': {
              'critical': 1,
              'name': 'default',
              'volume': 1.0,
            },
            'interruption-level': 'critical',
          },
        },
      },
    };

    try {
      final response = await http.post(url, headers: headers, body: json.encode(body));
      debugPrint('Direct FCM push notification status: ${response.statusCode}');
      debugPrint('Direct FCM response: ${response.body}');
    } catch (e) {
      debugPrint('Failed to send direct FCM push notification: $e');
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
}
