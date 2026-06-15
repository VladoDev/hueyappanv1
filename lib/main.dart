import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'src/core/router/router.dart';
import 'src/core/theme/vecinal_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'src/features/app_settings/presentation/providers/package_info_provider.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'src/features/security_events/domain/entities/security_event_entity.dart';
import 'src/features/security_events/presentation/providers/security_events_provider.dart';

// Entry points are now in main_development.dart and main_production.dart

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late ScreenshotCallback screenshotCallback;

  @override
  void initState() {
    super.initState();
    initScreenshotCallback();
  }

  void initScreenshotCallback() {
    screenshotCallback = ScreenshotCallback();
    screenshotCallback.addListener(() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userName = user.displayName ?? user.email ?? 'Nombre no disponible';
        
        try {
          // Fetch name from residents collection
          final doc = await FirebaseFirestore.instance.collection('residents').doc(user.uid).get();
          if (doc.exists && doc.data() != null) {
            final data = doc.data()!;
            if (data.containsKey('name') && data['name'] != null) {
              userName = data['name'] as String;
            }
          }
        } catch (e) {
          debugPrint('Error fetching resident name: $e');
        }

        final event = SecurityEventEntity(
          id: '',
          userId: user.uid,
          userName: userName,
          eventType: 'SCREENSHOT_TAKEN',
          timestamp: DateTime.now(),
        );
        
        try {
          final repository = ref.read(securityEventsRepositoryProvider);
          await repository.logEvent(event);
        } catch (e) {
          debugPrint('Error logging screenshot: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    screenshotCallback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Hueyappan',
      theme: vecinalLightTheme(),
      darkTheme: vecinalDarkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
