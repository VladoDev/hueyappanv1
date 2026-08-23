import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
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
      activeEmergency: clearActiveEmergency
          ? null
          : (activeEmergency ?? this.activeEmergency),
      dismissedEmergencyIds:
          dismissedEmergencyIds ?? this.dismissedEmergencyIds,
      isPlayingAlarm: isPlayingAlarm ?? this.isPlayingAlarm,
    );
  }
}

class EmergencyNotifier extends Notifier<EmergencyState> {
  StreamSubscription<Map<String, dynamic>?>? _subscription;
  AppLifecycleListener? _lifecycleListener;

  @override
  EmergencyState build() {
    // Start listening on provider initialization
    _listenToEmergencies();

    // Force-kill any lingering alarm audio every time the app comes back to
    // the foreground. This is a safety net for the case where the alarm was
    // left looping in the background (see _forceStopAlarm for why the state
    // flag alone isn't reliable enough to trust here).
    _lifecycleListener = AppLifecycleListener(onResume: _forceStopAlarm);

    // Clean up when the provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
      _lifecycleListener?.dispose();
      _forceStopAlarm();
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
        _forceStopAlarm();
        state = state.copyWith(
          clearActiveEmergency: true,
          isPlayingAlarm: false,
        );
        return;
      }

      // Check if it's recent (less than 2 minutes old)
      final timestampField = emergency['timestamp'];
      DateTime? triggeredAt;
      if (timestampField is Timestamp) {
        triggeredAt = timestampField.toDate();
      }

      final now = DateTime.now();
      final isRecent =
          triggeredAt == null ||
          now.difference(triggeredAt).inMinutes.abs() < 2;

      // Don't alert if we triggered it ourselves, or if it is already dismissed, or if it is old
      final currentUid = ref
          .read(authFirebaseDatasourceProvider)
          .currentUser
          ?.uid;

      if (triggeredBy != currentUid) {
        if (!state.dismissedEmergencyIds.contains(id) && isRecent) {
          state = state.copyWith(activeEmergency: emergency);
          _startAlarm();
        }
      } else {
        // If we triggered it ourselves, don't show the warning screen
        state = state.copyWith(clearActiveEmergency: true);
      }
    }, onError: (error) {
      // Handle permission denied or other stream errors safely
      // instead of throwing an unhandled exception.
      state = state.copyWith(clearActiveEmergency: true, isPlayingAlarm: false);
      _forceStopAlarm();
    });
  }

  void silenceAlarm(String id) {
    _forceStopAlarm();
    final updatedDismissed = Set<String>.from(state.dismissedEmergencyIds)
      ..add(id);
    state = state.copyWith(
      dismissedEmergencyIds: updatedDismissed,
      isPlayingAlarm: false,
      clearActiveEmergency: true, // Also hide overlay immediately
    );
  }

  AudioPlayer _audioPlayer = AudioPlayer();

  void _startAlarm() async {
    if (state.isPlayingAlarm) return;
    state = state.copyWith(isPlayingAlarm: true);
    // Capture the instance so a concurrent _forceStopAlarm() swap can't make
    // the two calls below land on two different players.
    final player = _audioPlayer;
    try {
      // Ensure it loops continuously
      await player.setReleaseMode(ReleaseMode.loop);
      await player.play(AssetSource('audio/siren.wav'), volume: 1.0);
    } catch (_) {
      // Playback never actually started: don't leave the flag stuck as
      // "playing", or a real silence request later would be a no-op.
      if (state.isPlayingAlarm) {
        state = state.copyWith(isPlayingAlarm: false);
      }
    }
  }

  /// Unconditionally stops and tears down the alarm player, regardless of
  /// [state.isPlayingAlarm]. `play()` on Android can still be preparing the
  /// asset when this is called (the siren file is ~2.6MB), so a stop that
  /// only fires while the flag says "playing" can race the async start and
  /// silently no-op — leaving the siren looping with no way to silence it
  /// short of killing the app. Recreating the player guarantees a clean
  /// native session for the next alarm.
  Future<void> _forceStopAlarm() async {
    final player = _audioPlayer;
    _audioPlayer = AudioPlayer();
    try {
      await player.stop();
    } finally {
      await player.dispose();
    }
    if (state.isPlayingAlarm) {
      state = state.copyWith(isPlayingAlarm: false);
    }
  }
}

final emergencyProvider = NotifierProvider<EmergencyNotifier, EmergencyState>(
  EmergencyNotifier.new,
);
