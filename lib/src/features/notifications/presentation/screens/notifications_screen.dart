import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import 'package:intl/intl.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/entities/notification_entity.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.navNotifications,
          style: TextStyle(color: vc.primaryDefault, fontWeight: FontWeight.bold),
        ),
      ),
      body: notificationsAsync.when(
              data: (notifications) {
                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 64, color: vc.textSecondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noNotifications,
                          style: TextStyle(color: vc.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _NotificationCard(notification: notification);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(
                child: Text('Error al cargar notificaciones: $e', style: TextStyle(color: vc.destructive)),
              ),
            ),

    );
  }
}

class _NotificationCard extends ConsumerWidget {
  final NotificationEntity notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final dateStr = dateFormat.format(notification.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? vc.surfaceCard.withValues(alpha: 0.7) : vc.surfaceCard.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isRead ? vc.surfaceCard.withValues(alpha: 0.3) : vc.primaryDefault.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            // Marcar como leída
            if (!notification.isRead) {
              final user = ref.read(firebaseUserProvider).value;
              if (user != null) {
                ref.read(notificationsRepositoryProvider).markAsRead(user.uid, notification.id);
              }
            }

            // Si es OTP, mostrar el diálogo
            if (notification.type == 'otp_verification') {
              _showOtpDialog(context, notification, vc, l10n);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: notification.type == 'otp_verification' ? vc.primaryContainer : vc.surfaceSecondary,
                  child: Icon(
                    notification.type == 'otp_verification' ? Icons.security : Icons.notifications,
                    color: notification.type == 'otp_verification' ? vc.primaryDefault : vc.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                                color: vc.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: vc.primaryDefault,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: TextStyle(color: vc.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dateStr,
                        style: TextStyle(color: vc.textSecondary.withValues(alpha: 0.7), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOtpDialog(BuildContext context, NotificationEntity notification, VecinalSemanticColors vc, AppLocalizations l10n) {
    final name = notification.data['requesterName'] ?? '';
    final lot = notification.data['requesterLot'] ?? '';
    final house = notification.data['requesterHouse'] ?? '';
    final otp = notification.data['otp'] ?? '';
    final phone = notification.data['requesterPhone'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.adminOtpDialogTitle(name),
            style: TextStyle(color: vc.textPrimary, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.adminOtpDialogBody(name, lot, house),
                style: TextStyle(color: vc.textSecondary, fontSize: 14),
              ),
              if (phone.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
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
              ],
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: vc.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  otp,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    color: vc.primaryDefault,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.adminOtpDialogInstruction,
                textAlign: TextAlign.center,
                style: TextStyle(color: vc.textSecondary, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }
}
