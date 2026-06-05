import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedLot;
  String? _selectedHouse;
  String? _selectedResidentType;

  final List<String> _lots = List.generate(41, (i) => (120 + i).toString());
  final List<String> _houses = ['A', 'B', 'C'];
  final List<String> _residentTypes = ['Propietario', 'Inquilino'];

  bool _isPreAuthenticated = false;
  
  final RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();
  bool _isRecaptchaVerified = false;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authFirebaseDatasourceProvider).currentUser;
    if (currentUser != null) {
      _isPreAuthenticated = true;
      _emailController.text = currentUser.email ?? '';
      _passwordController.text = '••••••••'; // Dummy value to satisfy UI form
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_isRecaptchaVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.recaptchaRequired),
          backgroundColor: context.vecinalColors.destructive,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate() &&
        _selectedLot != null &&
        _selectedHouse != null &&
        _selectedResidentType != null) {
      final success = await ref.read(authControllerProvider.notifier).register(
            email: _emailController.text,
            password: _passwordController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            lot: _selectedLot!,
            house: _selectedHouse!,
            residentType: _selectedResidentType!,
            phone: _phoneController.text,
          );
          
      if (!success && mounted) {
        // Error will be caught by ref.listen, but we can also log it here if we want
      }
    } else {
      // Form validation failed or dropdowns not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.requiredField),
          backgroundColor: context.vecinalColors.destructive,
          behavior: SnackBarBehavior.floating,
        ),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: vc.primaryDefault),
          onPressed: () async {
            if (_isPreAuthenticated) {
              await ref.read(authControllerProvider.notifier).logout();
            } else {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/login');
              }
            }
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient and Blobs
          const _BackgroundLayout(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 100, left: 24, right: 24, bottom: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(VecinalRadius.xl),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(VecinalSpacing.xl),
                    decoration: BoxDecoration(
                      color: vc.surfaceCard.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(VecinalRadius.xl),
                      border: Border.all(color: vc.surfaceCard.withValues(alpha: 0.4), width: 1.5),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _HeaderSection(),
                          const SizedBox(height: 24),
                          _buildNameFields(isLoading, vc),
                          const SizedBox(height: 16),
                          _buildDropdowns(isLoading, vc),
                          const SizedBox(height: 16),
                          _buildContactFields(isLoading, vc),
                          const SizedBox(height: 16),
                          _buildRecaptcha(vc),
                          const SizedBox(height: 24),
                          _buildSubmitButton(isLoading, vc),
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

  Widget _buildNameFields(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: l10n.firstNameLabel,
              prefixIcon: Icon(Icons.person_outline, color: vc.primaryDefault),
            ),
            validator: (val) => val == null || val.trim().isEmpty ? l10n.requiredField : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: l10n.lastNameLabel,
            ),
            validator: (val) => val == null || val.trim().isEmpty ? l10n.requiredField : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdowns(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedLot,
                decoration: InputDecoration(
                  labelText: l10n.lotLabel,
                  prefixIcon: Icon(Icons.home_outlined, color: vc.primaryDefault),
                ),
                items: _lots.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: isLoading ? null : (val) => setState(() => _selectedLot = val),
                validator: (val) => val == null ? l10n.requiredField : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedHouse,
                decoration: InputDecoration(
                  labelText: l10n.houseLabel,
                ),
                items: _houses.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                onChanged: isLoading ? null : (val) => setState(() => _selectedHouse = val),
                validator: (val) => val == null ? l10n.requiredField : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedResidentType,
          decoration: InputDecoration(
            labelText: l10n.residentTypeLabel,
            prefixIcon: Icon(Icons.assignment_ind_outlined, color: vc.primaryDefault),
          ),
          items: _residentTypes.map((t) {
            final String label;
            if (t == 'Propietario') {
              label = l10n.propietarioLabel;
            } else {
              label = l10n.inquilinoLabel;
            }
            return DropdownMenuItem(value: t, child: Text(label));
          }).toList(),
          onChanged: isLoading ? null : (val) => setState(() => _selectedResidentType = val),
          validator: (val) => val == null ? l10n.requiredField : null,
        ),
      ],
    );
  }

  Widget _buildContactFields(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        TextFormField(
          controller: _phoneController,
          enabled: !isLoading,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: l10n.phoneLabel,
            prefixIcon: Icon(Icons.phone_android_outlined, color: vc.primaryDefault),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return l10n.phoneRequired;
            if (!RegExp(r'^\d{10}$').hasMatch(val)) return l10n.phoneLengthInvalid;
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          enabled: !isLoading && !_isPreAuthenticated,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: l10n.emailLabel,
            prefixIcon: Icon(Icons.email_outlined, color: vc.primaryDefault),
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) return l10n.emailRequiredRegister;
            if (!val.contains('@')) return l10n.emailInvalidRegister;
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          enabled: !isLoading && !_isPreAuthenticated,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.passwordLabel,
            prefixIcon: Icon(Icons.lock_outline, color: vc.primaryDefault),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return l10n.passwordRequiredRegister;
            if (val.length < 6) return l10n.passwordTooShortRegister;
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRecaptcha(VecinalSemanticColors vc) {
    return Column(
      children: [
        RecaptchaV2(
          apiKey: "6Lf_uQ0tAAAAADJkfaGYZVf-1xMF_T3FG1Zhe6ox",
          apiSecret: "6Lf_uQ0tAAAAAB9vWoR8FXM-5-mfZFCufjAkRiC2",
          controller: recaptchaV2Controller,
          onVerifiedError: (err) {
            debugPrint('Recaptcha error: $err');
          },
          onVerifiedSuccessfully: (success) {
            setState(() {
              if (success) {
                _isRecaptchaVerified = true;
              }
            });
          },
        ),
      ],
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
                l10n.registerButton,
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
          radius: 28,
          backgroundColor: vc.primaryDefault,
          child: Icon(Icons.shield, size: 30, color: vc.textOnPrimary),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.registerHeaderTitle,
          style: VecinalTextStyles.headlineMedium.copyWith(
            color: vc.primaryDefault,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
