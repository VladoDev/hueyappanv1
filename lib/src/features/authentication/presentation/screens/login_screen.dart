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
      if (next.hasError) {
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
      backgroundColor: vc.surfacePrimary,
      body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
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
                      child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const _HeaderSection(),
                                const SizedBox(height: 40),
                                _buildEmailField(isLoading, vc),
                                const SizedBox(height: 20),
                                _buildPasswordField(isLoading, vc),
                                const SizedBox(height: 40),
                                _buildSubmitButton(isLoading, vc),
                                const SizedBox(height: 24),
                                _buildRegisterLink(isLoading, vc, context),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: vc.primaryDefault,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
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

  Widget _buildRegisterLink(bool isLoading, VecinalSemanticColors vc, BuildContext context) {
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
            borderRadius: BorderRadius.circular(28), // Slight rounding or circle depending on logo shape
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

