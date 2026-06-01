import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/entities/housing_payment_entity.dart';
import '../providers/payments_provider.dart';

class PaymentRegisterDialog extends ConsumerStatefulWidget {
  final HousingPaymentEntity payment;

  const PaymentRegisterDialog({
    super.key,
    required this.payment,
  });

  @override
  ConsumerState<PaymentRegisterDialog> createState() => _PaymentRegisterDialogState();
}

class _PaymentRegisterDialogState extends ConsumerState<PaymentRegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _refController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isCorrection = false;

  @override
  void initState() {
    super.initState();
    // Auto-fill suggested remaining balance
    _amountController.text = widget.payment.balance.toStringAsFixed(2);
    _notesController.text = widget.payment.notes ?? '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _refController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit(String type) async {
    if (_formKey.currentState!.validate()) {
      final authUser = ref.read(authStateProvider).value;
      if (authUser == null) return;

      final double amount = double.parse(_amountController.text);
      final String refText = _refController.text.trim();
      final String notesText = _notesController.text.trim();

      final String fullNotes = [
        if (refText.isNotEmpty) 'Ref: $refText',
        if (notesText.isNotEmpty) notesText,
      ].join(' | ');

      final success = await ref
          .read(paymentsControllerProvider.notifier)
          .registerPaymentTransaction(
            housingPaymentId: widget.payment.id,
            amount: amount,
            type: type,
            createdBy: authUser.uid,
            notes: fullNotes.isNotEmpty ? fullNotes : null,
          );

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transacción registrada con éxito')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(paymentsControllerProvider).isLoading;

    return AlertDialog(
      title: Text(
        '${l10n.registerPayment} - ${widget.payment.housingUnit}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(vc),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('¿Es una corrección / ajuste?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: const Text('Active para ajustes de saldo positivos o negativos.', style: TextStyle(fontSize: 12)),
                value: _isCorrection,
                onChanged: isLoading
                    ? null
                    : (val) {
                        setState(() {
                          _isCorrection = val;
                          if (_isCorrection) {
                            _amountController.text = '0.00';
                          } else {
                            _amountController.text = widget.payment.balance.toStringAsFixed(2);
                          }
                        });
                      },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                enabled: !isLoading,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: InputDecoration(
                  labelText: _isCorrection ? 'Monto de ajuste' : l10n.amountReceivedLabel,
                  prefixIcon: Icon(Icons.monetization_on_outlined, color: vc.primaryDefault),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return l10n.fieldRequired;
                  final parsed = double.tryParse(val);
                  if (parsed == null) return l10n.invalidAmount;
                  if (!_isCorrection && parsed <= 0) return 'El monto debe ser mayor que cero';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _refController,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: l10n.referenceLabel,
                  prefixIcon: Icon(Icons.receipt_long_outlined, color: vc.primaryDefault),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                enabled: !isLoading,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: l10n.notesLabel,
                  prefixIcon: Icon(Icons.note_alt_outlined, color: vc.primaryDefault),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: isLoading
          ? [const Center(child: CircularProgressIndicator())]
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel, style: TextStyle(color: vc.textSecondary, fontWeight: FontWeight.w600)),
              ),
              if (_isCorrection)
                ElevatedButton(
                  onPressed: () => _submit('correction'),
                  style: ElevatedButton.styleFrom(backgroundColor: vc.destructive, foregroundColor: vc.textOnPrimary),
                  child: const Text('Aplicar Ajuste', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              else ...[
                ElevatedButton(
                  onPressed: () => _submit('partial'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vc.surfaceSecondary,
                    foregroundColor: vc.textPrimary,
                    side: BorderSide(color: vc.borderDefault),
                  ),
                  child: Text(l10n.partialAction, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () => _submit('complete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vc.primaryDefault,
                    foregroundColor: vc.textOnPrimary,
                  ),
                  child: Text(l10n.completeAction, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ]
            ],
    );
  }

  Widget _buildSummaryCard(VecinalSemanticColors vc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: vc.surfaceSecondary,
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        border: Border.all(color: vc.borderDefault, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total debido:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text('\$${widget.payment.totalDue.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Abonado:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text('\$${widget.payment.amountPaid.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: vc.paymentSuccessText)),
            ],
          ),
          const Divider(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Saldo Restante:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(
                '\$${widget.payment.balance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.payment.balance > 0 ? vc.destructive : vc.paymentSuccessText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
