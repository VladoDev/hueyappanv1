import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import 'package:local_auth/local_auth.dart';
import '../providers/auth_provider.dart';
import '../providers/biometric_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// When true, show the email/password form instead of biometric view.
  bool _showCredentialForm = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final result = await ref
          .read(authControllerProvider.notifier)
          .login(_emailController.text, _passwordController.text);

      // If login succeeded, check if we should offer biometric setup
      if (result != null && mounted) {
        await _offerBiometricSetup(result.email, result.password);
      }
    }
  }

  Future<void> _loginWithBiometrics() async {
    final l10n = AppLocalizations.of(context)!;
    final biometricService = ref.read(biometricServiceProvider);

    final success = await ref
        .read(authControllerProvider.notifier)
        .loginWithBiometrics(biometricService, l10n.biometricAuthReason);

    if (!success && mounted) {
      final authState = ref.read(authControllerProvider);
      if (authState.hasError) {
        final errorMsg = authState.error.toString().replaceAll(
          'Exception: ',
          '',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: context.vecinalColors.destructive,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(VecinalRadius.md),
            ),
          ),
        );
      }
    }
  }

  /// After a successful email/password login, offer biometric setup if available
  /// and not already configured.
  Future<void> _offerBiometricSetup(String email, String password) async {
    final biometricService = ref.read(biometricServiceProvider);

    // Check if device supports biometrics
    final canUse = await biometricService.canCheckBiometrics();
    if (!canUse) return;

    // Check if already enabled
    final alreadyEnabled = await biometricService.isBiometricEnabled();
    if (alreadyEnabled) {
      // Update credentials silently (in case password changed)
      await biometricService.saveCredentials(email, password);
      return;
    }

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final vc = context.vecinalColors;

    // Determine which biometric icon to show
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
          style: VecinalTextStyles.headlineMedium.copyWith(
            color: vc.textPrimary,
          ),
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
      // Authenticate once to confirm, then save
      final authenticated = await biometricService.authenticate(
        l10n.biometricAuthReason,
      );
      if (authenticated) {
        await biometricService.saveCredentials(email, password);
        await biometricService.setBiometricEnabled(true);
        // Invalidate providers so next login shows biometric view
        ref.invalidate(biometricEnabledProvider);
        ref.invalidate(hasStoredCredentialsProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final vc = context.vecinalColors;

    // Biometric state
    final biometricAvailable =
        ref.watch(biometricAvailableProvider).value ?? false;
    final biometricEnabled = ref.watch(biometricEnabledProvider).value ?? false;
    final hasCredentials =
        ref.watch(hasStoredCredentialsProvider).value ?? false;

    final showBiometricView =
        biometricAvailable &&
        biometricEnabled &&
        hasCredentials &&
        !_showCredentialForm;

    ref.listen<AsyncValue>(authControllerProvider, (previous, next) {
      if (next.hasError) {
        final errorMsg = next.error.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: vc.destructive,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(VecinalRadius.md),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: vc.surfacePrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Clean Solid Card
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: vc.surfaceCard,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: showBiometricView
                      ? _buildBiometricView(isLoading, vc)
                      : _buildCredentialForm(isLoading, vc),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BIOMETRIC VIEW
  // ─────────────────────────────────────────────

  Widget _buildBiometricView(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    final biometrics = ref.watch(biometricServiceProvider);

    return FutureBuilder<List<BiometricType>>(
      future: biometrics.getAvailableBiometrics(),
      builder: (context, snapshot) {
        final types = snapshot.data ?? [];
        final isFace = types.contains(BiometricType.face);
        final icon = isFace ? Icons.face_rounded : Icons.fingerprint_rounded;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _HeaderSection(),
            const SizedBox(height: 40),
            // Biometric button
            GestureDetector(
              onTap: isLoading ? null : _loginWithBiometrics,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: vc.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: vc.primaryDefault.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: vc.primaryDefault,
                          ),
                        ),
                      )
                    : Icon(icon, size: 52, color: vc.primaryDefault),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.biometricLoginTitle,
              style: VecinalTextStyles.headlineSmall.copyWith(
                color: vc.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.biometricLoginSubtitle,
              style: VecinalTextStyles.bodyMedium.copyWith(
                color: vc.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            // Fallback: login with credentials
            TextButton(
              onPressed: isLoading
                  ? null
                  : () => setState(() => _showCredentialForm = true),
              style: TextButton.styleFrom(
                foregroundColor: vc.primaryDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.loginWithCredentials,
                style: TextStyle(
                  color: vc.primaryDefault,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  //  CREDENTIAL FORM (email/password)
  // ─────────────────────────────────────────────

  Widget _buildCredentialForm(bool isLoading, VecinalSemanticColors vc) {
    final biometricAvailable =
        ref.watch(biometricAvailableProvider).value ?? false;
    final biometricEnabled = ref.watch(biometricEnabledProvider).value ?? false;
    final hasCredentials =
        ref.watch(hasStoredCredentialsProvider).value ?? false;
    final canSwitchToBiometric =
        biometricAvailable && biometricEnabled && hasCredentials;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _HeaderSection(),
          const SizedBox(height: 40),
          _buildEmailField(isLoading, vc),
          const SizedBox(height: 20),
          _buildPasswordField(isLoading, vc),
          const SizedBox(height: 12),
          _buildForgotPasswordLink(isLoading, vc),
          const SizedBox(height: 28),
          _buildSubmitButton(isLoading, vc),
          const SizedBox(height: 24),
          _buildRegisterLink(isLoading, vc, context),
          // Show "back to biometric" option if available
          if (canSwitchToBiometric) ...[
            const SizedBox(height: 8),
            _buildBackToBiometricLink(isLoading, vc),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailField(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _emailController,
      enabled: !isLoading,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: vc.textPrimary, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: l10n.emailLabel,
        labelStyle: TextStyle(color: vc.textSecondary),
        prefixIcon: Icon(Icons.email_outlined, color: vc.primaryDefault),
        filled: true,
        fillColor: vc.surfacePrimary.withValues(alpha: 0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: vc.primaryDefault, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return l10n.emailRequired;
        if (!value.contains('@')) return l10n.emailInvalid;
        return null;
      },
    );
  }

  Widget _buildPasswordField(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _passwordController,
      enabled: !isLoading,
      obscureText: true,
      style: TextStyle(color: vc.textPrimary, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: l10n.passwordLabel,
        labelStyle: TextStyle(color: vc.textSecondary),
        prefixIcon: Icon(Icons.lock_outline_rounded, color: vc.primaryDefault),
        filled: true,
        fillColor: vc.surfacePrimary.withValues(alpha: 0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: vc.primaryDefault, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return l10n.passwordRequired;
        if (value.length < 6) return l10n.passwordTooShort;
        return null;
      },
    );
  }

  Widget _buildForgotPasswordLink(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: isLoading ? null : () => context.push('/forgot-password'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          l10n.forgotPassword,
          style: TextStyle(
            color: vc.primaryDefault,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: vc.primaryDefault,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                l10n.loginButton,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterLink(
    bool isLoading,
    VecinalSemanticColors vc,
    BuildContext context,
  ) {
    return TextButton(
      onPressed: isLoading ? null : () => context.push('/register'),
      style: TextButton.styleFrom(
        foregroundColor: vc.primaryDefault,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        AppLocalizations.of(context)!.registerLink,
        style: TextStyle(
          color: vc.primaryDefault,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildBackToBiometricLink(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return TextButton.icon(
      onPressed: isLoading
          ? null
          : () => setState(() => _showCredentialForm = false),
      icon: Icon(Icons.fingerprint_rounded, size: 18, color: vc.primaryDefault),
      label: Text(
        l10n.biometricLoginButton,
        style: TextStyle(
          color: vc.primaryDefault,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // App Logo Icon with subtle shadow
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: vc.primaryDefault.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              28,
            ), // Slight rounding or circle depending on logo shape
            child: Image.asset(
              'assets/app_icon.png',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.appName,
          style: VecinalTextStyles.displayLarge.copyWith(
            color: vc.primaryDefault,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.loginPortalSubtitle,
          style: VecinalTextStyles.bodyLarge.copyWith(
            color: vc.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
