import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final vc = context.vecinalColors;

    ref.listen<AsyncValue>(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        final errorMsg = next.error.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: vc.destructive,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
          ),
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient and Blobs
          const _BackgroundLayout(),
          // Glassmorphic Login Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(VecinalSpacing.xl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(VecinalRadius.xl),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(VecinalSpacing.xxl),
                    decoration: BoxDecoration(
                      color: vc.surfaceCard.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(VecinalRadius.xl),
                      border: Border.all(color: vc.surfaceCard.withValues(alpha: 0.4), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _HeaderSection(),
                          const SizedBox(height: 32),
                          _buildEmailField(isLoading, vc),
                          const SizedBox(height: 16),
                          _buildPasswordField(isLoading, vc),
                          const SizedBox(height: 32),
                          _buildSubmitButton(isLoading, vc),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () => context.push('/register'),
                            child: Text(
                              AppLocalizations.of(context)!.registerLink,
                              style: TextStyle(
                                color: vc.primaryDefault,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
      decoration: InputDecoration(
        labelText: l10n.emailLabel,
        prefixIcon: Icon(Icons.email_outlined, color: vc.primaryDefault),
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
      decoration: InputDecoration(
        labelText: l10n.passwordLabel,
        prefixIcon: Icon(Icons.lock_outlined, color: vc.primaryDefault),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return l10n.passwordRequired;
        if (value.length < 6) return l10n.passwordTooShort;
        return null;
      },
    );
  }

  Widget _buildSubmitButton(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: vc.primaryDefault,
          foregroundColor: vc.textOnPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: vc.textOnPrimary),
              )
            : Text(
                l10n.loginButton,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

class _BackgroundLayout extends StatelessWidget {
  const _BackgroundLayout();

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [vc.primaryContainer, vc.surfaceSecondary, vc.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            left: -50,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: vc.primaryDark.withValues(alpha: 0.25),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: CircleAvatar(
              radius: 180,
              backgroundColor: vc.primaryDefault.withValues(alpha: 0.2),
            ),
          ),
        ],
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
        CircleAvatar(
          radius: 36,
          backgroundColor: vc.primaryDefault,
          child: Icon(Icons.shield, size: 40, color: vc.textOnPrimary),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.appName,
          style: VecinalTextStyles.displayLarge.copyWith(
            color: vc.primaryDefault,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.loginPortalSubtitle,
          style: VecinalTextStyles.bodyMedium.copyWith(
            color: vc.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
