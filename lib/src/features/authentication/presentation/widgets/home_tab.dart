import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../providers/auth_provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HueyAPPan',
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
              tooltip: 'Activar Alerta de Emergencia',
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
            padding: const EdgeInsets.all(VecinalSpacing.xl),
            children: [
              _buildWelcomeHeader(vc),
              const SizedBox(height: 32),
              _buildFeatureCard(vc),
              const SizedBox(height: 24),
              Text(
                'Recent Activity',
                style: VecinalTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: vc.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildActivityItem(
                'Emergency system maintenance scheduled for next Saturday.',
                '1h ago',
                Icons.build_circle,
                vc,
              ),
              _buildActivityItem(
                'Monthly resident assembly meeting minutes are uploaded.',
                '1d ago',
                Icons.description,
                vc,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(VecinalSemanticColors vc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
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
                'Unit $housingUnit',
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

  Widget _buildFeatureCard(VecinalSemanticColors vc) {
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
                  'Neighborhood Overview',
                  style: VecinalTextStyles.headlineMedium.copyWith(
                    color: vc.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Convento Hueyapan Safe Community',
              style: VecinalTextStyles.bodyMedium.copyWith(
                color: vc.textOnPrimary.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All systems operational. Security is monitoring access 24/7.',
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
                    'Alerta de Emergencia',
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
                  : const Text(
                      '¿Estás seguro de que deseas activar la alerta de emergencia?\n\n'
                      'Esta acción enviará una notificación de alerta crítica con sonido a todos los residentes de la comunidad.',
                      style: TextStyle(fontSize: 15),
                    ),
              actions: isDialogLoading
                  ? null
                  : [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancelar', style: TextStyle(color: vc.textSecondary, fontWeight: FontWeight.w600)),
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
                                  content: const Text('¡Alerta de emergencia activada con éxito!'),
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
                                  content: Text('Error al activar la alarma: $e'),
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
                        child: const Text('Activar Alarma', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
            );
          },
        );
      },
    );
  }
}
