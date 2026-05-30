import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

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
    if (_formKey.currentState!.validate() &&
        _selectedLot != null &&
        _selectedHouse != null &&
        _selectedResidentType != null) {
      await ref.read(authControllerProvider.notifier).register(
            email: _emailController.text,
            password: _passwordController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            lot: _selectedLot!,
            house: _selectedHouse!,
            residentType: _selectedResidentType!,
            phone: _phoneController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen<AsyncValue>(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        final errorMsg = next.error.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red[800],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
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
          const _BackgroundLayout(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 100, left: 24, right: 24, bottom: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _HeaderSection(),
                          const SizedBox(height: 24),
                          _buildNameFields(isLoading),
                          const SizedBox(height: 16),
                          _buildDropdowns(isLoading),
                          const SizedBox(height: 16),
                          _buildContactFields(isLoading),
                          const SizedBox(height: 24),
                          _buildSubmitButton(isLoading),
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

  Widget _buildNameFields(bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: 'Nombre',
              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (val) => val == null || val.trim().isEmpty ? 'Requerido' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: 'Apellidos',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (val) => val == null || val.trim().isEmpty ? 'Requerido' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdowns(bool isLoading) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedLot,
                decoration: InputDecoration(
                  labelText: 'Lote',
                  prefixIcon: const Icon(Icons.home_outlined, color: Color(0xFF2E7D32)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _lots.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: isLoading ? null : (val) => setState(() => _selectedLot = val),
                validator: (val) => val == null ? 'Requerido' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedHouse,
                decoration: InputDecoration(
                  labelText: 'Casa',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _houses.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                onChanged: isLoading ? null : (val) => setState(() => _selectedHouse = val),
                validator: (val) => val == null ? 'Requerido' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedResidentType,
          decoration: InputDecoration(
            labelText: 'Tipo de Residente',
            prefixIcon: const Icon(Icons.assignment_ind_outlined, color: Color(0xFF2E7D32)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: _residentTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: isLoading ? null : (val) => setState(() => _selectedResidentType = val),
          validator: (val) => val == null ? 'Requerido' : null,
        ),

      ],
    );
  }

  Widget _buildContactFields(bool isLoading) {
    return Column(
      children: [
        TextFormField(
          controller: _phoneController,
          enabled: !isLoading,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Teléfono Móvil',
            prefixIcon: const Icon(Icons.phone_android_outlined, color: Color(0xFF2E7D32)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return 'El teléfono es requerido';
            if (!RegExp(r'^\d{10}$').hasMatch(val)) return 'Debe tener exactamente 10 dígitos';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          enabled: !isLoading && !_isPreAuthenticated,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo Electrónico',
            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF2E7D32)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) return 'El correo es requerido';
            if (!val.contains('@')) return 'Ingresa un correo válido';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          enabled: !isLoading && !_isPreAuthenticated,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2E7D32)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return 'La contraseña es requerida';
            if (val.length < 6) return 'Mínimo 6 caracteres';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B5E20),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : const Text(
                'Registrarse',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

class _BackgroundLayout extends StatelessWidget {
  const _BackgroundLayout();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9), Color(0xFF81C784)],
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
              backgroundColor: const Color(0xFF2E7D32).withOpacity(0.25),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: CircleAvatar(
              radius: 180,
              backgroundColor: const Color(0xFF1B5E20).withOpacity(0.2),
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
    return const Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xFF1B5E20),
          child: Icon(Icons.shield, size: 30, color: Colors.white),
        ),
        SizedBox(height: 12),
        Text(
          'Registro de Residente',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
      ],
    );
  }
}
