import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../providers/water_status_provider.dart';

class WaterStatusIconWidget extends ConsumerWidget {
  const WaterStatusIconWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final vc = context.vecinalColors;
    final waterStatusAsync = ref.watch(waterStatusProvider);
    final authState = ref.watch(authStateProvider);
    final isAdmin = authState.value?.isAdmin ?? false;

    return waterStatusAsync.when(
      data: (waterStatus) {
        final bool isMaintenance = waterStatus.isMaintenance;
        final bool isAvailable = waterStatus.isWaterAvailableToday;

        Color iconColor;
        IconData icon;
        String statusTitle;
        String funnyMessage;

        if (isMaintenance) {
          iconColor = const Color(0xFFB06000); // Dark orange
          icon = Icons.warning_amber_rounded;
          statusTitle = "Mantenimiento Reportado";
          funnyMessage =
              "Se ha reportado mantenimiento en la red de agua. El servicio externo se encuentra temporalmente interrumpido.";
        } else if (isAvailable) {
          iconColor = const Color(0xFF0D47A1); // Dark blue
          icon = Icons.water_drop;
          statusTitle = "Suministro Activo";
          funnyMessage =
              "De acuerdo al calendario municipal, el suministro de agua se encuentra activo el día de hoy. Le invitamos a hacer un uso responsable.";
        } else {
          iconColor = const Color(0xFF616161); // Dark grey
          icon = Icons.format_color_reset;
          statusTitle = "Sin Suministro Programado";
          funnyMessage =
              "De acuerdo al calendario municipal, hoy no hay suministro de agua programado en la zona. Le sugerimos administrar sus reservas.";
        }

        return IconButton(
          icon: Icon(icon, color: iconColor),
          onPressed: () {
            _showPopupMessage(
              context,
              statusTitle,
              funnyMessage,
              icon,
              iconColor,
              vc,
            );
          },
          onLongPress: isAdmin
              ? () => _showAdminOptions(
                  context,
                  ref,
                  waterStatus.status,
                  l10n,
                  vc,
                )
              : null,
        );
      },
      loading: () => const SizedBox(
        width: 48,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => const SizedBox(width: 48),
    );
  }

  void _showPopupMessage(
    BuildContext context,
    String title,
    String message,
    IconData icon,
    Color color,
    VecinalSemanticColors vc,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: vc.surfacePrimary,
          title: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: vc.textPrimary,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              color: vc.textSecondary,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Entendido',
                style: TextStyle(
                  color: vc.primaryDefault,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAdminOptions(
    BuildContext context,
    WidgetRef ref,
    String currentStatus,
    AppLocalizations l10n,
    VecinalSemanticColors vc,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.waterStatusAdminTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: vc.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildOption(
                  context,
                  ref,
                  'auto',
                  l10n.waterStatusAuto,
                  currentStatus,
                  vc,
                ),
                _buildOption(
                  context,
                  ref,
                  'force_available',
                  l10n.waterStatusForceAvailable,
                  currentStatus,
                  vc,
                ),
                _buildOption(
                  context,
                  ref,
                  'force_unavailable',
                  l10n.waterStatusForceUnavailable,
                  currentStatus,
                  vc,
                ),
                _buildOption(
                  context,
                  ref,
                  'maintenance',
                  l10n.waterStatusForceMaintenance,
                  currentStatus,
                  vc,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context,
    WidgetRef ref,
    String status,
    String label,
    String currentStatus,
    VecinalSemanticColors vc,
  ) {
    final isSelected = status == currentStatus;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? vc.primaryDefault : vc.textPrimary,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: vc.primaryDefault) : null,
      onTap: () {
        ref.read(updateWaterStatusProvider(status));
        Navigator.pop(context);
      },
    );
  }
}
