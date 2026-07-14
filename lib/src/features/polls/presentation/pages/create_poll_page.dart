import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/polls_provider.dart';
import '../../domain/entities/poll_entity.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

class CreatePollPage extends ConsumerStatefulWidget {
  const CreatePollPage({super.key});

  @override
  ConsumerState<CreatePollPage> createState() => _CreatePollPageState();
}

class _CreatePollPageState extends ConsumerState<CreatePollPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  bool _allowCustomOptions = false;
  bool _isLoading = false;

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers[index].dispose();
        _optionControllers.removeAt(index);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final resident = ref.read(authStateProvider).value;
    if (resident == null) return;

    setState(() => _isLoading = true);

    try {
      final newPoll = PollEntity(
        id: '',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        options: _optionControllers.asMap().entries.map((e) => PollOptionEntity(
          id: e.key.toString(),
          text: e.value.text.trim(),
        )).toList(),
        votedHouseholds: {},
        createdAt: DateTime.now(),
        createdBy: resident.uid,
        isActive: true,
        allowCustomOptions: _allowCustomOptions,
      );

      await ref.read(pollsNotifierProvider.notifier).createPoll(newPoll);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pollCreated)),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    for (var ctrl in _optionControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createPoll),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: l10n.pollQuestionLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: l10n.pollDescriptionLabel,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    Text(l10n.options, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ..._optionControllers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final ctrl = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: ctrl,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  labelText: l10n.pollOptionX(index + 1),
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) => value!.isEmpty ? 'Requerido' : null,
                              ),
                            ),
                            if (_optionControllers.length > 2)
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: VecinalColors.red600),
                                onPressed: () => _removeOption(index),
                              )
                          ],
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: _addOption,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addOption),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(l10n.pollAllowCustomOptions),
                      subtitle: Text(l10n.pollCustomOptionsDescription),
                      value: _allowCustomOptions,
                      onChanged: (val) {
                        setState(() => _allowCustomOptions = val);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submit,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(l10n.createPoll, style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
