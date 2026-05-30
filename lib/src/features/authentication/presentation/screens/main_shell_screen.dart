import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/home_tab.dart';
import '../widgets/announcements_tab.dart';
import '../widgets/payments_tab.dart';
import '../widgets/profile_tab.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const MainShellScreen({
    super.key,
    required this.initialIndex,
  });

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  late int _selectedIndex;
  StreamSubscription<Map<String, dynamic>?>? _emergencySubscription;
  Map<String, dynamic>? _activeEmergency;
  final Set<String> _dismissedEmergencyIds = {};
  bool _isPlayingAlarm = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _listenToEmergencies();
  }

  void _listenToEmergencies() {
    final datasource = ref.read(authFirebaseDatasourceProvider);
    _emergencySubscription = datasource.watchEmergencies().listen((emergency) {
      if (emergency == null) return;
      
      final String id = emergency['id'] as String;
      final String triggeredBy = emergency['triggeredBy'] as String;
      final String status = emergency['status'] as String? ?? '';
      
      if (status != 'active') {
        _stopAlarm();
        if (mounted) {
          setState(() {
            _activeEmergency = null;
          });
        }
        return;
      }

      // Check if it's recent (less than 2 minutes old)
      final timestampField = emergency['timestamp'];
      DateTime? triggeredAt;
      if (timestampField is Timestamp) {
        triggeredAt = timestampField.toDate();
      }
      
      final now = DateTime.now();
      final isRecent = triggeredAt == null || now.difference(triggeredAt).inMinutes.abs() < 2;

      // Don't alert if we triggered it ourselves, or if it is already dismissed, or if it is old
      final currentUid = ref.read(authFirebaseDatasourceProvider).currentUser?.uid;
      
      if (mounted) {
        if (triggeredBy != currentUid && !_dismissedEmergencyIds.contains(id) && isRecent) {
          setState(() {
            _activeEmergency = emergency;
          });
          _startAlarm();
        } else {
          setState(() {
            _activeEmergency = emergency;
          });
        }
      }
    });
  }

  void _startAlarm() {
    if (!_isPlayingAlarm) {
      _isPlayingAlarm = true;
      FlutterRingtonePlayer.playAlarm(looping: true, asAlarm: true);
    }
  }

  void _stopAlarm() {
    if (_isPlayingAlarm) {
      _isPlayingAlarm = false;
      FlutterRingtonePlayer.stop();
    }
  }

  @override
  void dispose() {
    _emergencySubscription?.cancel();
    _stopAlarm();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MainShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _selectedIndex = widget.initialIndex;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/announcements');
        break;
      case 2:
        context.go('/payments');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final List<Widget> pages = [
      HomeTab(residentName: user.name, housingUnit: user.housingUnit),
      const AnnouncementsTab(),
      const PaymentsTab(),
      ProfileTab(
        name: user.name,
        email: user.email,
        housingUnit: user.housingUnit,
        status: user.accountStatus,
      ),
    ];

    final hasActiveAlert = _activeEmergency != null &&
        _activeEmergency!['status'] == 'active' &&
        !_dismissedEmergencyIds.contains(_activeEmergency!['id']);

    return Stack(
      children: [
        Scaffold(
          body: pages[_selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFFE8F5E9),
              elevation: 0,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard, color: Color(0xFF2E7D32)),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.campaign_outlined),
                  selectedIcon: Icon(Icons.campaign, color: Color(0xFF2E7D32)),
                  label: 'News',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  selectedIcon: Icon(Icons.account_balance_wallet, color: Color(0xFF2E7D32)),
                  label: 'Payments',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: Color(0xFF2E7D32)),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
        if (hasActiveAlert)
          _buildEmergencyOverlay(user.uid),
      ],
    );
  }

  Widget _buildEmergencyOverlay(String currentUid) {
    final senderName = _activeEmergency?['triggeredByName'] ?? 'Un residente';
    final id = _activeEmergency?['id'] ?? '';

    return Scaffold(
      backgroundColor: Colors.red[900]!.withOpacity(0.85),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _PulsingWarningIcon(),
                  const SizedBox(height: 32),
                  const Text(
                    '¡ALERTA DE EMERGENCIA!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'El residente $senderName ha activado una alerta de emergencia en la comunidad.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: () {
                      _stopAlarm();
                      setState(() {
                        _dismissedEmergencyIds.add(id);
                      });
                    },
                    icon: const Icon(Icons.volume_off, color: Colors.red),
                    label: const Text(
                      'Silenciar Alarma',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red[900],
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

class _PulsingWarningIcon extends StatefulWidget {
  const _PulsingWarningIcon();

  @override
  State<_PulsingWarningIcon> createState() => _PulsingWarningIconState();
}

class _PulsingWarningIconState extends State<_PulsingWarningIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.15).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
          size: 64,
        ),
      ),
    );
  }
}
