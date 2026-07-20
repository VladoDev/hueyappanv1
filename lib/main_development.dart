import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options_development.dart';
import 'main.dart';
import 'src/features/app_settings/presentation/providers/package_info_provider.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    await dotenv.load(fileName: ".env.development");

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Firebase already initialized: $e');
    }

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    try {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      debugPrint('FCM initialization error: $e');
    }

    final packageInfo = await PackageInfo.fromPlatform();

    runApp(
      ProviderScope(
        overrides: [packageInfoProvider.overrideWithValue(packageInfo)],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Fatal initialization error: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Error de inicialización:\n\n$e\n\n$stackTrace',
                style: const TextStyle(color: Colors.red, fontSize: 12),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
