import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../providers/auth_provider.dart';

class ProfileTab extends ConsumerWidget {
  final String name;
  final String email;
  final String housingUnit;
  final String status;

  const ProfileTab({
    super.key,
    required this.name,
    required this.email,
    required this.housingUnit,
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authControllerProvider);
    final vc = context.vecinalColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(VecinalSpacing.xl),
        children: [
          _buildAvatarSection(vc),
          const SizedBox(height: 32),
          Text(
            'Account Information',
            style: VecinalTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: vc.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Housing Unit', 'Unit $housingUnit', vc),
          _buildInfoRow('Resident Status', status, vc),
          const SizedBox(height: 48),
          _buildSignOutButton(ref, controller.isLoading, vc),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(VecinalSemanticColors vc) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: vc.primaryContainer,
            child: Icon(Icons.person, size: 48, color: vc.primaryDefault),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: VecinalTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: vc.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: VecinalTextStyles.bodyMedium.copyWith(color: vc.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(WidgetRef ref, bool isLoading, VecinalSemanticColors vc) {
    return ElevatedButton.icon(
      onPressed: isLoading
          ? null
          : () => ref.read(authControllerProvider.notifier).logout(),
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: vc.textOnPrimary),
            )
          : const Icon(Icons.logout),
      label: const Text(
        'Sign Out',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: vc.destructive,
        foregroundColor: vc.textOnPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
        elevation: 0,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, VecinalSemanticColors vc) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        side: BorderSide(color: vc.borderDefault, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: VecinalTextStyles.bodyMedium.copyWith(
                color: vc.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: VecinalTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: vc.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
