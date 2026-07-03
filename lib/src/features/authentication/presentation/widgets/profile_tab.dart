import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/biometric_provider.dart';

class ProfileTab extends ConsumerStatefulWidget {
  final String name;
  final String email;
  final String lot;
  final String house;
  final String status;
  final String role;

  const ProfileTab({
    super.key,
    required this.name,
    required this.email,
    required this.lot,
    required this.house,
    required this.status,
    required this.role,
  });

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider);
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.myProfile,
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          left: VecinalSpacing.xl,
          right: VecinalSpacing.xl,
          top: VecinalSpacing.xl,
          bottom: 100,
        ),
        children: [
          _buildAvatarSection(vc),
          const SizedBox(height: 32),
          Text(
            l10n.accountInformation,
            style: VecinalTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: vc.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            l10n.housingUnitLabel,
            l10n.housingUnitValue(widget.lot, widget.house),
            vc,
          ),
          _buildInfoRow(l10n.residentStatusLabel, widget.status, vc),
          _buildInfoRow(
            l10n.roleLabel,
            widget.role == 'admin' ? l10n.roleAdmin : l10n.roleVecino,
            vc,
          ),
          const SizedBox(height: 12),
          _buildBiometricToggle(vc, l10n),
          const SizedBox(height: 48),
          _buildSignOutButton(context, ref, controller.isLoading, vc),
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
            widget.name,
            style: VecinalTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: vc.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.email,
            style: VecinalTextStyles.bodyMedium.copyWith(
              color: vc.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricToggle(VecinalSemanticColors vc, AppLocalizations l10n) {
    final biometricAvailable = ref.watch(biometricAvailableProvider).value ?? false;
    if (!biometricAvailable) return const SizedBox.shrink();

    final biometricEnabled = ref.watch(biometricEnabledProvider).value ?? false;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        side: BorderSide(color: vc.borderDefault, width: 0.5),
      ),
      child: SwitchListTile(
        title: Text(
          l10n.biometricToggle,
          style: VecinalTextStyles.bodyMedium.copyWith(
            color: vc.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: biometricEnabled,
        activeColor: vc.primaryDefault,
        onChanged: (bool value) => _onBiometricToggled(value, vc, l10n),
      ),
    );
  }

  Future<void> _onBiometricToggled(bool enable, VecinalSemanticColors vc, AppLocalizations l10n) async {
    final biometricService = ref.read(biometricServiceProvider);
    
    if (!enable) {
      await biometricService.setBiometricEnabled(false);
      ref.invalidate(biometricEnabledProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.biometricsDisabled)),
        );
      }
      return;
    }

    // Trying to enable
    final hasStored = await biometricService.hasStoredCredentials();
    String password = '';

    if (!hasStored) {
      // Need password
      final pwd = await _showPasswordDialog(vc, l10n);
      if (pwd == null || pwd.isEmpty) return; // cancelled
      password = pwd;
    }

    final authenticated = await biometricService.authenticate(l10n.biometricAuthReason);
    if (authenticated) {
      if (!hasStored) {
        await biometricService.saveCredentials(widget.email, password);
        ref.invalidate(hasStoredCredentialsProvider);
      }
      await biometricService.setBiometricEnabled(true);
      ref.invalidate(biometricEnabledProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.biometricsEnabled)),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.biometricAuthFailed), backgroundColor: vc.destructive),
        );
      }
    }
  }

  Future<String?> _showPasswordDialog(VecinalSemanticColors vc, AppLocalizations l10n) {
    final controller = TextEditingController();
    bool obscure = true;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: vc.surfaceModal,
          title: Text(
            l10n.enterPasswordForBiometrics,
            style: VecinalTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              labelText: l10n.passwordPlaceholder,
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => obscure = !obscure),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: Text(l10n.cancel, style: TextStyle(color: vc.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text),
              style: ElevatedButton.styleFrom(backgroundColor: vc.primaryDefault),
              child: Text(l10n.save, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutButton(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
    VecinalSemanticColors vc,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton.icon(
      onPressed: isLoading
          ? null
          : () async {
              try {
                await ref.read(authRepositoryProvider).logout();
              } catch (_) {
                // Ensure we always navigate to login even if logout has partial failures
              }
              // Invalidate all auth-related providers to clear cached user data
              ref.invalidate(authStateProvider);
              ref.invalidate(firebaseUserProvider);
              ref.invalidate(authControllerProvider);
              if (context.mounted) {
                context.go('/login');
              }
            },
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: vc.textOnPrimary,
              ),
            )
          : const Icon(Icons.logout),
      label: Text(
        l10n.signOut,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: vc.destructive,
        foregroundColor: vc.textOnPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.md),
        ),
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
            Flexible(
              child: Text(
                label,
                style: VecinalTextStyles.bodyMedium.copyWith(
                  color: vc.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: VecinalTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: vc.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
