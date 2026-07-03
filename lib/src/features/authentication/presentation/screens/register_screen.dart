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

  final List<String> _lots = List.generate(22, (i) => (134 + i).toString());
  List<String> get _houses {
    if (_selectedLot == '144' || _selectedLot == '145') {
      return ['A', 'B', 'C'];
    }
    return ['A', 'B'];
  }

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
      final success = await ref
          .read(authControllerProvider.notifier)
          .register(
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
    final l10n = AppLocalizations.of(context)!;

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.registerHeaderTitle,
          style: VecinalTextStyles.headlineSmall.copyWith(
            color: vc.primaryDefault,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildNameFields(isLoading, vc),
                        const SizedBox(height: 16),
                        _buildDropdowns(isLoading, vc),
                        const SizedBox(height: 16),
                        _buildContactFields(isLoading, vc),
                        const SizedBox(height: 16),
                        _buildRecaptcha(vc),
                        const SizedBox(height: 28),
                        _buildSubmitButton(isLoading, vc),
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

  InputDecoration _commonInputDecoration(
    String labelText,
    IconData? prefixIcon,
    VecinalSemanticColors vc,
  ) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: vc.textSecondary),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: vc.primaryDefault)
          : null,
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
    );
  }

  Widget _buildNameFields(bool isLoading, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        TextFormField(
          controller: _firstNameController,
          enabled: !isLoading,
          style: TextStyle(color: vc.textPrimary, fontWeight: FontWeight.w500),
          decoration: _commonInputDecoration(
            l10n.firstNameLabel,
            Icons.person_outline,
            vc,
          ),
          validator: (val) =>
              val == null || val.trim().isEmpty ? l10n.requiredField : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lastNameController,
          enabled: !isLoading,
          style: TextStyle(color: vc.textPrimary, fontWeight: FontWeight.w500),
          decoration: _commonInputDecoration(
            l10n.lastNameLabel,
            Icons.person_outline,
            vc,
          ),
          validator: (val) =>
              val == null || val.trim().isEmpty ? l10n.requiredField : null,
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
                value: _selectedLot,
                dropdownColor: vc.surfaceCard,
                style: TextStyle(
                  color: vc.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: _commonInputDecoration(
                  l10n.lotLabel,
                  Icons.home_outlined,
                  vc,
                ),
                items: _lots
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: isLoading
                    ? null
                    : (val) {
                        setState(() {
                          _selectedLot = val;
                          if (_selectedHouse != null &&
                              !_houses.contains(_selectedHouse)) {
                            _selectedHouse = null;
                          }
                        });
                      },
                validator: (val) => val == null ? l10n.requiredField : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedHouse,
                dropdownColor: vc.surfaceCard,
                style: TextStyle(
                  color: vc.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: _commonInputDecoration(l10n.houseLabel, null, vc),
                items: _houses
                    .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                    .toList(),
                onChanged: isLoading
                    ? null
                    : (val) => setState(() => _selectedHouse = val),
                validator: (val) => val == null ? l10n.requiredField : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedResidentType,
          dropdownColor: vc.surfaceCard,
          style: TextStyle(color: vc.textPrimary, fontWeight: FontWeight.w500),
          decoration: _commonInputDecoration(
            l10n.residentTypeLabel,
            Icons.assignment_ind_outlined,
            vc,
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
          onChanged: isLoading
              ? null
              : (val) => setState(() => _selectedResidentType = val),
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
          style: TextStyle(color: vc.textPrimary, fontWeight: FontWeight.w500),
          decoration: _commonInputDecoration(
            l10n.phoneLabel,
            Icons.phone_android_outlined,
            vc,
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return l10n.phoneRequired;
            if (!RegExp(r'^\d{10}$').hasMatch(val))
              return l10n.phoneLengthInvalid;
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          enabled: !isLoading && !_isPreAuthenticated,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: vc.textPrimary, fontWeight: FontWeight.w500),
          decoration: _commonInputDecoration(
            l10n.emailLabel,
            Icons.email_outlined,
            vc,
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty)
              return l10n.emailRequiredRegister;
            if (!val.contains('@')) return l10n.emailInvalidRegister;
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          enabled: !isLoading && !_isPreAuthenticated,
          obscureText: true,
          style: TextStyle(color: vc.textPrimary, fontWeight: FontWeight.w500),
          decoration: _commonInputDecoration(
            l10n.passwordLabel,
            Icons.lock_outline,
            vc,
          ),
          validator: (val) {
            if (val == null || val.isEmpty)
              return l10n.passwordRequiredRegister;
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
          apiKey: "6Lemtw4tAAAAACeY-96VPirAxI6EcUTgwW8quFXQ",
          apiSecret: "6Lemtw4tAAAAAErhymCWcuWsuxCqAXtyzHGKNdkV",
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
                l10n.registerButton,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
