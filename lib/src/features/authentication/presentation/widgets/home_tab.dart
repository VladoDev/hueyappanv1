import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../providers/auth_provider.dart';
import '../../../payments/domain/entities/payment_transaction_entity.dart';
import '../../../payments/presentation/providers/payments_provider.dart';

class HomeTab extends ConsumerWidget {
  final String residentName;
  final String housingUnit;

  const HomeTab({
    super.key,
    required this.residentName,
    required this.housingUnit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: Consumer(
          builder: (context, ref, child) {
            final transactionsAsync = ref.watch(neighborTransactionsStreamProvider(housingUnit));
            return transactionsAsync.when(
              data: (transactions) {
                final pending = transactions.where((t) => !t.isConfirmed).toList();
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_none, color: vc.primaryDefault, size: 26),
                      onPressed: () => _showNotificationsBottomSheet(context, ref, pending),
                    ),
                    if (pending.isNotEmpty)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: vc.destructive,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${pending.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
              loading: () => IconButton(
                icon: Icon(Icons.notifications_none, color: vc.primaryDefault, size: 26),
                onPressed: () => _showNotificationsBottomSheet(context, ref, []),
              ),
              error: (err, stack) => IconButton(
                icon: Icon(Icons.notifications_none, color: vc.primaryDefault, size: 26),
                onPressed: () => _showNotificationsBottomSheet(context, ref, []),
              ),
            );
          },
        ),
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
            colors: [vc.primaryContainer.withValues(alpha: 0.15), vc.surfaceTertiary],
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
              Text(
                l10n.recentActivity,
                style: VecinalTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: vc.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildActivityItem(
                l10n.activityMaintenance,
                l10n.activityMaintenanceTime,
                Icons.build_circle,
                vc,
              ),
              _buildActivityItem(
                l10n.activityAssembly,
                l10n.activityAssemblyTime,
                Icons.description,
                vc,
              ),
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
                residentName,
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
                l10n.housingUnitValue(housingUnit),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.lg)),
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

  Widget _buildActivityItem(String text, String time, IconData icon, VecinalSemanticColors vc) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: vc.primaryContainer,
          child: Icon(icon, color: vc.onPrimaryContainer),
        ),
        title: Text(
          text,
          style: VecinalTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
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

  void _showEmergencyDialog(BuildContext context, WidgetRef ref, VecinalSemanticColors vc) {
    bool isDialogLoading = false;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: vc.destructive, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    l10n.emergencyAlertTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, color: vc.destructive),
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
                        child: Text(l10n.cancel, style: TextStyle(color: vc.textSecondary, fontWeight: FontWeight.w600)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isDialogLoading = true;
                          });

                          try {
                            final datasource = ref.read(authFirebaseDatasourceProvider);
                            final currentUser = datasource.currentUser;
                            if (currentUser != null) {
                              final profile = await datasource.getResidentProfile(currentUser.uid);
                              final name = profile?.name ?? currentUser.email ?? 'Vecino';
                              await datasource.triggerEmergencyAlarm(currentUser.uid, name);
                            }
                            
                            if (context.mounted) {
                              Navigator.of(context).pop(); // Cerrar el diálogo
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.alarmActivatedSuccess),
                                  backgroundColor: vc.destructive,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
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
                                  content: Text(l10n.alarmActivatedError(e.toString())),
                                  backgroundColor: vc.surfacePrimary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vc.destructive,
                          foregroundColor: vc.textOnPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
                        ),
                        child: Text(l10n.activateAlarm, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  void _showNotificationsBottomSheet(
      BuildContext context, WidgetRef ref, List<PaymentTransactionEntity> pending) {
    final vc = context.vecinalColors;
    showModalBottomSheet(
      context: context,
      backgroundColor: vc.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notificaciones',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                if (pending.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.notifications_none, size: 48, color: vc.textHint),
                          const SizedBox(height: 12),
                          Text(
                            'No tienes pagos por confirmar',
                            style: TextStyle(color: vc.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: pending.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final t = pending[index];
                        final dateStr = '${t.createdAt.day}/${t.createdAt.month}/${t.createdAt.year}';
                        return ListTile(
                          leading: Icon(Icons.payment, color: vc.primaryDefault),
                          title: Text(t.conceptTitle ?? 'Pago Pendiente', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Registrado el $dateStr'),
                          trailing: Icon(Icons.chevron_right, color: vc.textHint),
                          onTap: () {
                            Navigator.pop(context);
                            _showConfirmDetailDialog(context, ref, t, vc);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmDetailDialog(
      BuildContext context, WidgetRef ref, PaymentTransactionEntity t, VecinalSemanticColors vc) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Confirmar Pago', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Concepto:',
                style: TextStyle(fontWeight: FontWeight.bold, color: vc.textSecondary, fontSize: 13),
              ),
              Text(
                t.conceptTitle ?? 'Sin concepto',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                'Monto a Confirmar:',
                style: TextStyle(fontWeight: FontWeight.bold, color: vc.textSecondary, fontSize: 13),
              ),
              Text(
                '\$${t.amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: vc.destructive),
              ),
              if (t.extraAmount > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '+ \$${t.extraAmount.toStringAsFixed(2)} extra',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: vc.primaryDefault),
                ),
              ],
              if (t.notes != null && t.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Notas del administrador:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: vc.textSecondary, fontSize: 13),
                ),
                Text(
                  t.notes!,
                  style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text('Cancelar', style: TextStyle(color: vc.textSecondary, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(dialogCtx);
                Navigator.pop(dialogCtx);
                messenger.showSnackBar(
                  const SnackBar(content: Text('Confirmando pago...')),
                );
                final success = await ref
                    .read(paymentsControllerProvider.notifier)
                    .confirmPaymentTransaction(
                      housingPaymentId: t.housingPaymentId,
                      transactionId: t.id,
                    );
                if (success) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Pago confirmado con éxito')),
                  );
                } else {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Error al confirmar el pago')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: vc.primaryDefault,
                foregroundColor: vc.textOnPrimary,
              ),
              child: const Text('Confirmar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
