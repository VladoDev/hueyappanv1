import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../domain/entities/contact_entity.dart';
import '../providers/contacts_provider.dart';

class AddContactDialog extends ConsumerStatefulWidget {
  const AddContactDialog({super.key});

  @override
  ConsumerState<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends ConsumerState<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedCategory = 'Services';
  bool _isLoading = false;

  final List<String> _categories = [
    'Emergency',
    'Security',
    'Services',
    'Admin'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);

    try {
      final contact = ContactEntity(
        id: '', // Will be assigned by Firestore
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        category: _selectedCategory,
        isFavorite: false,
      );

      await ref.read(addContactUseCaseProvider).execute(contact);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.contactAdded)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.addContact, style: VecinalTextStyles.headlineSmall),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.nameLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? l10n.fieldRequired
                    : null,
              ),
              const SizedBox(height: VecinalSpacing.md),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: l10n.phoneLabel,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.trim().isEmpty
                    ? l10n.fieldRequired
                    : null,
              ),
              const SizedBox(height: VecinalSpacing.md),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: l10n.categoryLabel,
                  border: const OutlineInputBorder(),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategory = val);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: TextStyle(color: vc.textSecondary)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: vc.primaryDefault,
            foregroundColor: vc.textOnPrimary,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text(l10n.add),
        ),
      ],
    );
  }
}
