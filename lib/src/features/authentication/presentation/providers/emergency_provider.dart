import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'auth_provider.dart';

class EmergencyState {
  final Map<String, dynamic>? activeEmergency;
  final Set<String> dismissedEmergencyIds;
  final bool isPlayingAlarm;

  const EmergencyState({
    this.activeEmergency,
    required this.dismissedEmergencyIds,
    required this.isPlayingAlarm,
  });

  EmergencyState copyWith({
    Map<String, dynamic>? activeEmergency,
    bool clearActiveEmergency = false,
    Set<String>? dismissedEmergencyIds,
    bool? isPlayingAlarm,
  }) {
    return EmergencyState(
      activeEmergency: clearActiveEmergency ? null : (activeEmergency ?? this.activeEmergency),
      dismissedEmergencyIds: dismissedEmergencyIds ?? this.dismissedEmergencyIds,
      isPlayingAlarm: isPlayingAlarm ?? this.isPlayingAlarm,
    );
  }
}

class EmergencyNotifier extends Notifier<EmergencyState> {
  StreamSubscription<Map<String, dynamic>?>? _subscription;

  @override
  EmergencyState build() {
    // Start listening on provider initialization
    _listenToEmergencies();

    // Clean up when the provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
      _stopAlarm();
    });

    return const EmergencyState(
      dismissedEmergencyIds: {},
      isPlayingAlarm: false,
    );
  }

  void _listenToEmergencies() {
    final datasource = ref.read(authFirebaseDatasourceProvider);
    _subscription = datasource.watchEmergencies().listen((emergency) {
      if (emergency == null) return;

      final String id = emergency['id'] as String;
      final String triggeredBy = emergency['triggeredBy'] as String;
      final String status = emergency['status'] as String? ?? '';

      if (status != 'active') {
        _stopAlarm();
        state = state.copyWith(clearActiveEmergency: true, isPlayingAlarm: false);
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

      if (triggeredBy != currentUid) {
        if (!state.dismissedEmergencyIds.contains(id) && isRecent) {
          state = state.copyWith(
            activeEmergency: emergency,
          );
          _startAlarm();
        }
      } else {
        // If we triggered it ourselves, don't show the warning screen
        state = state.copyWith(clearActiveEmergency: true);
      }
    });
  }

  void silenceAlarm(String id) {
    _stopAlarm();
    final updatedDismissed = Set<String>.from(state.dismissedEmergencyIds)..add(id);
    state = state.copyWith(
      dismissedEmergencyIds: updatedDismissed,
      isPlayingAlarm: false,
      clearActiveEmergency: true, // Also hide overlay immediately
    );
  }

  void _startAlarm() {
    if (!state.isPlayingAlarm) {
      state = state.copyWith(isPlayingAlarm: true);
      FlutterRingtonePlayer().playAlarm(looping: true, asAlarm: true);
    }
  }

  void _stopAlarm() {
    if (state.isPlayingAlarm) {
      FlutterRingtonePlayer().stop();
    }
  }
}

final emergencyProvider = NotifierProvider<EmergencyNotifier, EmergencyState>(EmergencyNotifier.new);
