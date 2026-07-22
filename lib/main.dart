import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/router/router.dart';
import 'src/core/theme/vecinal_theme.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'src/features/security_events/domain/entities/security_event_entity.dart';
import 'package:shake/shake.dart';
import 'package:screenshot/screenshot.dart';
import 'src/features/feedback/presentation/widgets/shake_report_dialog.dart';

// Entry points are now in main_development.dart and main_production.dart

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late ScreenshotCallback screenshotCallback;
  late ShakeDetector shakeDetector;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    initScreenshotCallback();
    initShakeDetector();
  }

  void initShakeDetector() {
    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: (_) {
        screenshotController.capture().then((screenshotBytes) {
          if (!mounted) return;
          final context = ref.read(routerProvider).routerDelegate.navigatorKey.currentContext;
          if (context != null && context.mounted) {
            HapticFeedback.heavyImpact();
            showDialog(
              context: context,
              builder: (ctx) => ShakeReportDialog(screenshotBytes: screenshotBytes),
            );
          }
        });
      },
    );
  }

  void initScreenshotCallback() {
    screenshotCallback = ScreenshotCallback();
    screenshotCallback.addListener(() async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // Log to Crashlytics so we can see this in prod dashboard
          FirebaseCrashlytics.instance.log(
            'Screenshot detected but no authenticated user found',
          );
          return;
        }

        String userName =
            user.displayName ?? user.email ?? 'Nombre no disponible';

        try {
          // Fetch name from residents collection
          final doc = await FirebaseFirestore.instance
              .collection('residents')
              .doc(user.uid)
              .get();
          if (doc.exists && doc.data() != null) {
            final data = doc.data()!;
            if (data.containsKey('name') && data['name'] != null) {
              userName = data['name'] as String;
            }
          }
        } catch (e) {
          // Non-fatal: continue with fallback name
          FirebaseCrashlytics.instance.log('Error fetching resident name: $e');
        }

        final event = SecurityEventEntity(
          id: '',
          userId: user.uid,
          userName: userName,
          eventType: 'SCREENSHOT_TAKEN',
          timestamp: DateTime.now(),
        );

        // Write directly to Firestore instead of going through the
        // Riverpod provider chain, which can be unreliable when called
        // from a platform callback outside the widget lifecycle.
        try {
          await FirebaseFirestore.instance
              .collection('screenshot_logs')
              .doc()
              .set(event.toMap());
        } catch (e, stack) {
          FirebaseCrashlytics.instance.recordError(
            e,
            stack,
            reason: 'Failed to log screenshot event to Firestore',
          );
        }
      } catch (e, stack) {
        FirebaseCrashlytics.instance.recordError(
          e,
          stack,
          reason: 'Unexpected error in screenshot callback',
        );
      }
    });
  }

  @override
  void dispose() {
    screenshotCallback.dispose();
    shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return Screenshot(
      controller: screenshotController,
      child: MaterialApp.router(
        title: 'Hueyappan',
        theme: vecinalLightTheme(),
        darkTheme: vecinalDarkTheme(),
        themeMode: ThemeMode.system,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
