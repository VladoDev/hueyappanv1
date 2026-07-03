import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../domain/entities/concept_item_entity.dart';
import '../../domain/entities/payment_concept_entity.dart';
import '../providers/payments_provider.dart';

class ConceptFormScreen extends ConsumerStatefulWidget {
  final String? conceptId;

  const ConceptFormScreen({super.key, this.conceptId});

  @override
  ConsumerState<ConceptFormScreen> createState() => _ConceptFormScreenState();
}

class _ConceptFormScreenState extends ConsumerState<ConceptFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _amountPerHouseController = TextEditingController();

  final List<_SubItemInput> _subItems = [];
  bool _isEditing = false;
  PaymentConceptEntity? _originalConcept;
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    _isEditing = widget.conceptId != null;

    if (_isEditing) {
      Future.microtask(() async {
        final repo = ref.read(paymentsRepositoryProvider);
        final concepts = await ref.read(conceptsStreamProvider.future);
        final concept = concepts.firstWhere((c) => c.id == widget.conceptId);

        _originalConcept = concept;
        _titleController.text = concept.title;
        _descController.text = concept.description ?? '';
        _totalCostController.text = concept.totalAmount.toStringAsFixed(2);
        _amountPerHouseController.text = concept.amountPerUnit.toStringAsFixed(
          2,
        );
        _status = concept.status;

        // Fetch sub-items
        final items = await repo.watchConceptItems(widget.conceptId!).first;
        setState(() {
          for (final item in items) {
            _subItems.add(
              _SubItemInput(
                labelController: TextEditingController(text: item.label),
                amountController: TextEditingController(
                  text: item.amount != null
                      ? item.amount!.toStringAsFixed(2)
                      : '',
                ),
              ),
            );
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _totalCostController.dispose();
    _amountPerHouseController.dispose();
    for (final item in _subItems) {
      item.dispose();
    }
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(paymentsControllerProvider.notifier);

      final totalAmount = double.parse(_totalCostController.text);
      final amountPerHouse = double.parse(_amountPerHouseController.text);
      final conceptId = _isEditing
          ? widget.conceptId!
          : DateTime.now().millisecondsSinceEpoch.toString();

      final concept = PaymentConceptEntity(
        id: conceptId,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        totalAmount: totalAmount,
        totalUnits: 0,
        amountPerUnit: amountPerHouse,
        status: _status,
        createdAt: _originalConcept?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        recordedExpense: _originalConcept?.recordedExpense ?? 0.0,
      );

      final List<ConceptItemEntity> items = [];
      for (int i = 0; i < _subItems.length; i++) {
        final subItem = _subItems[i];
        final label = subItem.labelController.text.trim();
        final amountText = subItem.amountController.text.trim();
        final amount = amountText.isNotEmpty
            ? double.tryParse(amountText)
            : null;

        if (label.isNotEmpty) {
          items.add(
            ConceptItemEntity(
              id: '${conceptId}_item_$i',
              conceptId: conceptId,
              label: label,
              amount: amount,
              order: i,
            ),
          );
        }
      }

      final success = _isEditing
          ? await controller.updateConcept(concept)
          : await controller.createConcept(concept, items);

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Concepto actualizado' : 'Concepto creado',
            ),
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(paymentsControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.editConcept : l10n.createConcept,
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(VecinalSpacing.xl),
          children: [
            if (_isEditing) ...[
              _buildWarningCard(l10n.editConceptWarning, vc),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _titleController,
              enabled: !isLoading,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.conceptTitleLabel,
                prefixIcon: Icon(Icons.title, color: vc.primaryDefault),
              ),
              validator: (val) =>
                  val == null || val.trim().isEmpty ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              enabled: !isLoading,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.conceptDescLabel,
                prefixIcon: Icon(
                  Icons.description_outlined,
                  color: vc.primaryDefault,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _totalCostController,
                    enabled: !isLoading,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.conceptTotalCost,
                      prefixIcon: Icon(
                        Icons.monetization_on_outlined,
                        color: vc.primaryDefault,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return l10n.fieldRequired;
                      if (double.tryParse(val) == null)
                        return l10n.invalidAmount;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _amountPerHouseController,
                    enabled: !isLoading,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.amountPerHouseLabel,
                      prefixIcon: Icon(
                        Icons.home_outlined,
                        color: vc.primaryDefault,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return l10n.fieldRequired;
                      if (double.tryParse(val) == null)
                        return l10n.invalidAmount;
                      return null;
                    },
                  ),
                ),
              ],
            ),
            if (_isEditing) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: InputDecoration(
                  labelText: 'Estado',
                  prefixIcon: Icon(
                    Icons.info_outline,
                    color: vc.primaryDefault,
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'active',
                    child: Text(l10n.activeStatus),
                  ),
                  DropdownMenuItem(
                    value: 'closed',
                    child: Text(l10n.closedStatus),
                  ),
                  DropdownMenuItem(
                    value: 'cancelled',
                    child: Text(l10n.cancelledStatus),
                  ),
                ],
                onChanged: isLoading
                    ? null
                    : (val) => setState(() => _status = val!),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.subItemsLabel,
                  style: VecinalTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!_isEditing)
                  TextButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => setState(
                            () => _subItems.add(
                              _SubItemInput(
                                labelController: TextEditingController(),
                                amountController: TextEditingController(),
                              ),
                            ),
                          ),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addSubItem),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_subItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Sin desglose de costos.',
                  style: VecinalTextStyles.bodyMedium.copyWith(
                    color: vc.textHint,
                  ),
                ),
              )
            else
              ...List.generate(
                _subItems.length,
                (idx) => _buildSubItemRow(idx, vc, l10n, isLoading),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: vc.primaryDefault,
                  foregroundColor: vc.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(VecinalRadius.md),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        l10n.save,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubItemRow(
    int index,
    VecinalSemanticColors vc,
    AppLocalizations l10n,
    bool isLoading,
  ) {
    final subItem = _subItems[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: subItem.labelController,
              enabled: !isLoading && !_isEditing,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.itemLabel,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: subItem.amountController,
              enabled: !isLoading && !_isEditing,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.itemAmount,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
          if (!_isEditing) ...[
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.remove_circle_outline, color: vc.destructive),
              onPressed: () => setState(() {
                _subItems[index].dispose();
                _subItems.removeAt(index);
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWarningCard(String text, VecinalSemanticColors vc) {
    return Card(
      elevation: 0,
      color: vc.destructiveBg.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        side: BorderSide(color: vc.destructive, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(VecinalSpacing.base),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: vc.destructive),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: VecinalTextStyles.bodyMedium.copyWith(
                  color: vc.destructive,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubItemInput {
  final TextEditingController labelController;
  final TextEditingController amountController;

  _SubItemInput({
    required this.labelController,
    required this.amountController,
  });

  void dispose() {
    labelController.dispose();
    amountController.dispose();
  }
}
