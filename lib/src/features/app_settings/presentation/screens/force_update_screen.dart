import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../providers/app_settings_provider.dart';

class ForceUpdateScreen extends ConsumerWidget {
  const ForceUpdateScreen({super.key});

  Future<void> _launchStore(String? androidUrl, String? iosUrl) async {
    String? urlString;
    if (Platform.isIOS) {
      urlString = iosUrl;
    } else if (Platform.isAndroid) {
      urlString = androidUrl;
    }

    if (urlString != null && urlString.isNotEmpty) {
      final uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final settingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      backgroundColor: vc.surfacePrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                Icons.system_update_rounded,
                size: 100,
                color: vc.primaryDefault,
              ),
              const SizedBox(height: 32),
              Text(
                'Actualización Requerida',
                style: VecinalTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: vc.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Hemos lanzado una nueva versión con mejoras importantes. Por favor, actualiza la aplicación para continuar.',
                style: VecinalTextStyles.bodyLarge.copyWith(
                  color: vc.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              settingsAsync.when(
                data: (settings) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vc.primaryDefault,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: settings != null
                          ? () => _launchStore(settings.storeUrlAndroid, settings.storeUrlIos)
                          : null,
                      child: const Text(
                        'Actualizar en la Tienda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, st) => const Text('Error al cargar la información'),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
