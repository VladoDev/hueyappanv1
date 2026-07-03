import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../providers/auth_provider.dart';
import '../../../payments/domain/entities/payment_transaction_entity.dart';
import '../../../payments/domain/entities/payment_concept_entity.dart';
import '../../../payments/presentation/providers/payments_provider.dart';
import '../../../water_status/presentation/widgets/water_status_icon.dart';
import '../providers/biometric_provider.dart';
import 'package:local_auth/local_auth.dart';

final _recentEmergencyProvider =
    StreamProvider.autoDispose<Map<String, dynamic>?>((ref) {
      return ref.watch(authFirebaseDatasourceProvider).watchEmergencies();
    });

class HomeTab extends ConsumerStatefulWidget {
  final String residentName;
  final String lot;
  final String house;

  const HomeTab({
    super.key,
    required this.residentName,
    required this.lot,
    required this.house,
  });

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPendingBiometricSetup();
    });
  }

  void _checkPendingBiometricSetup() async {
    final pending = ref.read(pendingBiometricSetupProvider);
    if (pending != null) {
      // Clear it so it doesn't show again
      ref.read(pendingBiometricSetupProvider.notifier).clear();
      await _offerBiometricSetup(pending.email, pending.password);
    }
  }

  Future<void> _offerBiometricSetup(String email, String password) async {
    final biometricService = ref.read(biometricServiceProvider);
    final canUse = await biometricService.canCheckBiometrics();
    if (!canUse) return;

    final alreadyEnabled = await biometricService.isBiometricEnabled();
    if (alreadyEnabled) {
      await biometricService.saveCredentials(email, password);
      return;
    }

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final vc = context.vecinalColors;

    final biometrics = await biometricService.getAvailableBiometrics();
    final IconData biometricIcon = biometrics.contains(BiometricType.face)
        ? Icons.face_rounded
        : Icons.fingerprint_rounded;

    if (!mounted) return;

    final shouldEnable = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: vc.surfaceModal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: vc.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(biometricIcon, size: 40, color: vc.primaryDefault),
        ),
        title: Text(
          l10n.biometricSetupTitle,
          style: VecinalTextStyles.headlineMedium.copyWith(color: vc.textPrimary),
        ),
        content: Text(
          l10n.biometricSetupBody,
          style: VecinalTextStyles.bodyMedium.copyWith(color: vc.textSecondary),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.notNow,
              style: TextStyle(
                color: vc.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: vc.primaryDefault,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              l10n.enableBiometric,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (shouldEnable == true) {
      final authenticated = await biometricService.authenticate(
        l10n.biometricAuthReason,
      );
      if (authenticated) {
        await biometricService.saveCredentials(email, password);
        await biometricService.setBiometricEnabled(true);
        ref.invalidate(biometricEnabledProvider);
        ref.invalidate(hasStoredCredentialsProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: const WaterStatusIconWidget(),
        centerTitle: true,
        title: Text(
          l10n.appName,
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: vc.emergencyBg,
              shape: BoxShape.circle,
              border: Border.all(color: vc.emergencyBorder, width: 1.5),
            ),
            child: IconButton(
              icon: Icon(Icons.campaign, color: vc.emergencyIcon, size: 24),
              tooltip: l10n.emergencyAlertTitle,
              onPressed: () => _showEmergencyDialog(context, ref, vc),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              vc.primaryContainer.withValues(alpha: 0.15),
              vc.surfaceTertiary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(
              left: VecinalSpacing.xl,
              right: VecinalSpacing.xl,
              top: VecinalSpacing.xl,
              bottom: 100,
            ),
            children: [
              _buildWelcomeHeader(context, vc),
              const SizedBox(height: 32),
              _buildFeatureCard(context, vc),
              const SizedBox(height: 24),
              _RecentActivitySection(lot: widget.lot, house: widget.house, vc: vc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.welcomeBack,
                style: VecinalTextStyles.bodyMedium.copyWith(
                  color: vc.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.residentName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: VecinalTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: vc.primaryDefault,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: vc.primaryContainer,
            borderRadius: BorderRadius.circular(VecinalRadius.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, size: 16, color: vc.onPrimaryContainer),
              const SizedBox(width: 4),
              Text(
                l10n.housingUnitValue(widget.lot, widget.house),
                style: VecinalTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: vc.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.lg),
      ),
      color: vc.primaryDark,
      child: Padding(
        padding: const EdgeInsets.all(VecinalSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield, color: vc.textOnPrimary, size: 28),
                const SizedBox(width: 12),
                Text(
                  l10n.homeFeatureTitle,
                  style: VecinalTextStyles.headlineMedium.copyWith(
                    color: vc.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.homeFeatureSubtitle,
              style: VecinalTextStyles.bodyMedium.copyWith(
                color: vc.textOnPrimary.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.homeFeatureBody,
              style: VecinalTextStyles.bodyLarge.copyWith(
                color: vc.textOnPrimary.withValues(alpha: 0.9),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDialog(
    BuildContext context,
    WidgetRef ref,
    VecinalSemanticColors vc,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final datasource = ref.read(authFirebaseDatasourceProvider);
    final currentUser = datasource.currentUser;

    if (currentUser == null) return;

    // Check if phone is verified or if user is an admin
    final profile = await datasource.getResidentProfile(currentUser.uid);
    if (profile == null) return;

    if (profile.isPhoneVerified || profile.role == 'admin') {
      if (context.mounted) {
        _showActiveEmergencyDialog(
          context,
          ref,
          vc,
          l10n,
          currentUser.uid,
          profile.name,
        );
      }
    } else {
      if (context.mounted) {
        _showOtpVerificationDialog(
          context,
          ref,
          vc,
          l10n,
          currentUser.uid,
          profile.name,
          profile.lot,
          profile.house,
          profile.phone ?? '',
        );
      }
    }
  }

  void _showActiveEmergencyDialog(
    BuildContext context,
    WidgetRef ref,
    VecinalSemanticColors vc,
    AppLocalizations l10n,
    String uid,
    String name,
  ) {
    bool isDialogLoading = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: vc.destructive,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.emergencyAlertTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: vc.destructive,
                    ),
                  ),
                ],
              ),
              content: isDialogLoading
                  ? SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(color: vc.destructive),
                      ),
                    )
                  : Text(
                      l10n.emergencyAlertConfirm,
                      style: const TextStyle(fontSize: 15),
                    ),
              actions: isDialogLoading
                  ? null
                  : [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          l10n.cancel,
                          style: TextStyle(
                            color: vc.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isDialogLoading = true;
                          });

                          try {
                            final datasource = ref.read(
                              authFirebaseDatasourceProvider,
                            );
                            final currentUser = datasource.currentUser;
                            if (currentUser != null) {
                              final profile = await datasource
                                  .getResidentProfile(currentUser.uid);
                              final name =
                                  profile?.name ??
                                  currentUser.email ??
                                  'Vecino';
                              final lotVal = profile?.lot ?? widget.lot;
                              final houseVal = profile?.house ?? widget.house;
                              await datasource.triggerEmergencyAlarm(
                                currentUser.uid,
                                name,
                                lotVal,
                                houseVal,
                              );
                            }

                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.alarmActivatedSuccess),
                                  backgroundColor: vc.destructive,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      VecinalRadius.md,
                                    ),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              setState(() {
                                isDialogLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.alarmActivatedError(e.toString()),
                                  ),
                                  backgroundColor: vc.surfacePrimary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      VecinalRadius.md,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vc.destructive,
                          foregroundColor: vc.textOnPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              VecinalRadius.md,
                            ),
                          ),
                        ),
                        child: Text(
                          l10n.activateAlarm,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  void _showOtpVerificationDialog(
    BuildContext context,
    WidgetRef ref,
    VecinalSemanticColors vc,
    AppLocalizations l10n,
    String uid,
    String name,
    String lot,
    String house,
    String phone,
  ) {
    bool isRequesting = false;
    bool isRequested = false;
    bool isVerifying = false;
    final otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                l10n.verifyPhoneRequiredTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: vc.textPrimary,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.verifyPhoneRequiredBody,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  if (isRequested)
                    TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                        labelText: l10n.enterOtp,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !isVerifying,
                    ),
                ],
              ),
              actions: [
                if (!isRequested)
                  TextButton(
                    onPressed: isRequesting
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(color: vc.textSecondary),
                    ),
                  ),
                if (!isRequested)
                  ElevatedButton(
                    onPressed: isRequesting
                        ? null
                        : () async {
                            setState(() => isRequesting = true);
                            try {
                              await ref
                                  .read(authFirebaseDatasourceProvider)
                                  .requestPhoneVerification(
                                    uid,
                                    phone,
                                    name,
                                    lot,
                                    house,
                                  );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.otpRequestedSuccess),
                                  ),
                                );
                                setState(() {
                                  isRequesting = false;
                                  isRequested = true;
                                });
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                                setState(() => isRequesting = false);
                              }
                            }
                          },
                    child: isRequesting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.requestVerification),
                  ),
                if (isRequested)
                  TextButton(
                    onPressed: isVerifying
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(color: vc.textSecondary),
                    ),
                  ),
                if (isRequested)
                  ElevatedButton(
                    onPressed: isVerifying
                        ? null
                        : () async {
                            final otp = otpController.text.trim();
                            if (otp.isEmpty) return;

                            setState(() => isVerifying = true);
                            try {
                              final success = await ref
                                  .read(authFirebaseDatasourceProvider)
                                  .verifyPhoneOtp(uid, otp);
                              if (context.mounted) {
                                if (success) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.otpVerifiedSuccess),
                                      backgroundColor: vc.primaryDefault,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.otpVerificationFailed),
                                      backgroundColor: vc.destructive,
                                    ),
                                  );
                                  setState(() => isVerifying = false);
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                                setState(() => isVerifying = false);
                              }
                            }
                          },
                    child: isVerifying
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.verifyOtp),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _RecentActivitySection extends ConsumerWidget {
  final String lot;
  final String house;
  final VecinalSemanticColors vc;

  const _RecentActivitySection({
    required this.lot,
    required this.house,
    required this.vc,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final emergencyAsync = ref.watch(_recentEmergencyProvider);
    final transactionsAsync = ref.watch(
      neighborTransactionsStreamProvider((lot: lot, house: house)),
    );
    final conceptsAsync = ref.watch(conceptsStreamProvider);

    List<Widget> items = [];

    // 1. Emergency
    emergencyAsync.whenData((emergency) {
      if (emergency != null) {
        final name = emergency['triggeredByName'] ?? 'Usuario';
        final eLot = emergency['triggeredByLot'] ?? '';
        final timestamp = emergency['timestamp'];
        DateTime? dt;
        if (timestamp is Timestamp) {
          dt = timestamp.toDate();
        }

        final timeStr = dt != null
            ? '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}'
            : 'Recientemente';

        items.add(
          _ActivityItemWidget(
            text: 'Alarma crítica: $name (Lote $eLot)',
            time: timeStr,
            icon: Icons.warning_rounded,
            vc: vc,
            iconColor: vc.destructive,
          ),
        );
      }
    });

    // 2. Latest User Payment
    transactionsAsync.whenData((txs) {
      if (txs.isNotEmpty) {
        final latest = txs.first;
        final dt = latest.createdAt;
        final timeStr =
            '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';

        items.add(
          _ActivityItemWidget(
            text: 'Realizaste un pago: ${latest.conceptTitle}',
            time: timeStr,
            icon: Icons.payment,
            vc: vc,
            iconColor: vc.primaryDefault,
          ),
        );
      }
    });

    // 3. Latest Payment Concept
    conceptsAsync.whenData((concepts) {
      if (concepts.isNotEmpty) {
        final sorted = List<PaymentConceptEntity>.from(concepts)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final latest = sorted.first;
        final dt = latest.createdAt;
        final timeStr =
            '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';

        items.add(
          _ActivityItemWidget(
            text: 'Nuevo concepto de pago: ${latest.title}',
            time: timeStr,
            icon: Icons.new_releases,
            vc: vc,
            iconColor: vc.noticeIcon,
          ),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recentActivity,
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No hay actividad reciente',
              style: TextStyle(color: vc.textSecondary),
            ),
          )
        else
          ...items,
      ],
    );
  }
}

class _ActivityItemWidget extends StatelessWidget {
  final String text;
  final String time;
  final IconData icon;
  final VecinalSemanticColors vc;
  final Color? iconColor;

  const _ActivityItemWidget({
    required this.text,
    required this.time,
    required this.icon,
    required this.vc,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = iconColor ?? vc.onPrimaryContainer;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: effectiveColor.withValues(alpha: 0.1),
          child: Icon(icon, color: effectiveColor),
        ),
        title: Text(
          text,
          style: VecinalTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            time,
            style: VecinalTextStyles.bodySmall.copyWith(color: vc.textHint),
          ),
        ),
      ),
    );
  }
}
