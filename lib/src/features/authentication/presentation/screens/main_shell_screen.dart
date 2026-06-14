import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/emergency_provider.dart';
import '../widgets/pulsing_warning_icon.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  @override
  void initState() {
    super.initState();
    
    // Request permission and register token on launch if already logged in
    Future.microtask(() {
      if (mounted) {
        final user = ref.read(authStateProvider).value;
        if (user != null) {
          ref.read(authFirebaseDatasourceProvider).registerDeviceToken(user.uid);
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (!mounted) return;
      
      if (message.data['type'] == 'otp_verification') {
        _handleIncomingMessage(message);
      } else if (message.data['type'] == 'water_maintenance') {
        // Ignorar en foreground, ya que tienen la UI del ícono de agua
        return;
      } else {
        final title = message.notification?.title ?? 'Notificación';
        final body = message.notification?.body;
        
        final vc = context.vecinalColors;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (body != null) ...[
                  const SizedBox(height: 4),
                  Text(body, style: const TextStyle(fontSize: 14)),
                ],
              ],
            ),
            backgroundColor: vc.surfacePrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: vc.primaryDefault.withValues(alpha: 0.5), width: 1.5),
            ),
            margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Cerrar',
              textColor: vc.primaryDefault,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
    
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'otp_verification') {
        _handleIncomingMessage(message);
      }
    });
  }

  void _handleIncomingMessage(RemoteMessage message) {
    if (message.data['type'] == 'otp_verification') {
      final name = message.data['requesterName'] ?? '';
      final lot = message.data['requesterLot'] ?? message.data['lot'] ?? '';
      final house = message.data['requesterHouse'] ?? message.data['house'] ?? '';
      final otp = message.data['otp'] ?? '';
      final phone = message.data['requesterPhone'] ?? '';
      
      String unitInfo = '';
      if (lot.isNotEmpty || house.isNotEmpty) {
        unitInfo = ' (Lote $lot-$house)';
      }
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            final vc = context.vecinalColors;
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
              contentPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              title: Text(
                l10n.adminOtpDialogTitle(name),
                style: TextStyle(color: vc.textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.adminOtpDialogBody(name, unitInfo),
                    style: TextStyle(color: vc.textSecondary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  if (phone.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: vc.surfaceSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.phone, size: 18, color: vc.primaryDefault),
                          const SizedBox(width: 8),
                          Text(
                            phone,
                            style: TextStyle(
                              color: vc.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: vc.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      otp,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 12,
                        color: vc.primaryDefault,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.adminOtpDialogInstruction,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: vc.textSecondary, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.only(right: 24, bottom: 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.close, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final vc = context.vecinalColors;

    // Listen to changes in authState to register device token if/when it loads
    ref.listen(authStateProvider, (previous, next) {
      final newUser = next.value;
      if (newUser != null) {
        ref.read(authFirebaseDatasourceProvider).registerDeviceToken(newUser.uid);
      }
    });

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Watch global emergency state
    final emergencyState = ref.watch(emergencyProvider);
    final hasActiveAlert = emergencyState.activeEmergency != null;

    final l10n = AppLocalizations.of(context)!;
    final List<_FloatingTabBarItem> navItems = [
      _FloatingTabBarItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: l10n.navHome,
      ),
      _FloatingTabBarItem(
        icon: Icons.notifications_outlined,
        selectedIcon: Icons.notifications,
        label: l10n.navNotifications,
      ),
      _FloatingTabBarItem(
        icon: Icons.account_balance_wallet_outlined,
        selectedIcon: Icons.account_balance_wallet,
        label: l10n.navPayments,
      ),
      _FloatingTabBarItem(
        icon: Icons.phone_outlined,
        selectedIcon: Icons.phone,
        label: l10n.navContacts,
      ),
      _FloatingTabBarItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: l10n.navProfile,
      ),
    ];

    return Stack(
      children: [
        // Scaffold with navigation content and floating bottom bar
        Scaffold(
          // Allow body to extend behind the navigation bar
          extendBody: true,
          body: widget.navigationShell,
          // Custom floating bottom navigation bar
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    decoration: BoxDecoration(
                      color: vc.surfacePrimary.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: vc.borderDefault.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(navItems.length, (index) {
                        final item = navItems[index];
                        final isSelected = widget.navigationShell.currentIndex == index;
                        return GestureDetector(
                          onTap: () => _onItemTapped(index),
                          behavior: HitTestBehavior.opaque,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? vc.primaryDefault.withValues(alpha: 0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected ? item.selectedIcon : item.icon,
                                  color: isSelected ? vc.primaryDefault : vc.navUnselected,
                                  size: 24,
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    item.label,
                                    style: VecinalTextStyles.labelMedium.copyWith(
                                      color: vc.primaryDefault,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Full screen emergency overlay
        if (hasActiveAlert)
          _buildEmergencyOverlay(user.uid, vc, emergencyState.activeEmergency),
      ],
    );
  }

  Widget _buildEmergencyOverlay(String currentUid, VecinalSemanticColors vc, Map<String, dynamic>? activeEmergency) {
    final l10n = AppLocalizations.of(context)!;
    final senderName = activeEmergency?['triggeredByName'] ?? 'Un residente';
    final id = activeEmergency?['id'] ?? '';

    return Scaffold(
      backgroundColor: vc.emergencyBg.withValues(alpha: 0.95),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PulsingWarningIcon(),
                  const SizedBox(height: 32),
                  Text(
                    l10n.emergencyOverlayTitle,
                    textAlign: TextAlign.center,
                    style: VecinalTextStyles.displayLarge.copyWith(
                      color: vc.emergencyText,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.emergencyOverlayBody(senderName),
                    textAlign: TextAlign.center,
                    style: VecinalTextStyles.bodyLarge.copyWith(
                      color: vc.emergencyText.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(emergencyProvider.notifier).silenceAlarm(id);
                    },
                    icon: Icon(Icons.volume_off, color: vc.destructive),
                    label: Text(
                      l10n.silenceAlarm,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vc.surfacePrimary,
                      foregroundColor: vc.destructive,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingTabBarItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  _FloatingTabBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
