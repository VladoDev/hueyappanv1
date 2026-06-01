import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: l10n.navHome,
      ),
      _FloatingTabBarItem(
        icon: Icons.campaign_outlined,
        selectedIcon: Icons.campaign,
        label: l10n.navNews,
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                                  const SizedBox(width: 8),
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
