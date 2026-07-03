import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/entities/housing_payment_entity.dart';
import '../providers/payments_provider.dart';

class PaymentRegisterDialog extends ConsumerStatefulWidget {
  final HousingPaymentEntity payment;

  const PaymentRegisterDialog({super.key, required this.payment});

  @override
  ConsumerState<PaymentRegisterDialog> createState() =>
      _PaymentRegisterDialogState();
}

class _PaymentRegisterDialogState extends ConsumerState<PaymentRegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _refController = TextEditingController();
  final _notesController = TextEditingController();
  final _extraAmountController = TextEditingController(text: '0.00');

  @override
  void initState() {
    super.initState();
    // Auto-fill suggested total paid: if already paid something, use that; else suggest the total due
    final defaultAmount = widget.payment.amountPaid > 0
        ? widget.payment.amountPaid
        : widget.payment.totalDue;
    _amountController.text = defaultAmount.toStringAsFixed(2);
    _notesController.text = widget.payment.notes ?? '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _refController.dispose();
    _notesController.dispose();
    _extraAmountController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final authUser = ref.read(authStateProvider).value;
      if (authUser == null) return;

      final double newTotalPaid = double.parse(_amountController.text);
      final double difference = newTotalPaid - widget.payment.amountPaid;

      if (difference == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El monto no ha cambiado')),
        );
        return;
      }

      String type;
      if (difference < 0) {
        type = 'correction';
      } else if (newTotalPaid >= widget.payment.totalDue) {
        type = 'complete';
      } else {
        type = 'partial';
      }

      final double extraAmount =
          double.tryParse(_extraAmountController.text) ?? 0.0;
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
            amount: difference,
            type: type,
            createdBy: authUser.uid,
            extraAmount: extraAmount,
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

  Widget _buildDifferenceIndicator(VecinalSemanticColors vc) {
    final double newTotalPaid =
        double.tryParse(_amountController.text) ?? widget.payment.amountPaid;
    final double difference = newTotalPaid - widget.payment.amountPaid;

    if (difference == 0) return const SizedBox.shrink();

    final isCorrection = difference < 0;
    final color = isCorrection ? vc.destructive : vc.paymentSuccessText;
    final text = isCorrection
        ? 'Se registrará un ajuste de -\$${difference.abs().toStringAsFixed(2)}'
        : 'Se registrará un nuevo pago de +\$${difference.toStringAsFixed(2)}';

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 4.0, bottom: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(paymentsControllerProvider).isLoading;
    final itemsAsync = ref.watch(
      conceptItemsStreamProvider(widget.payment.conceptId),
    );

    return AlertDialog(
      title: Text(
        '${l10n.registerPayment} - ${widget.payment.lot}-${widget.payment.house}',
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
              TextFormField(
                controller: _amountController,
                enabled: !isLoading,
                onChanged: (val) => setState(() {}),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                decoration: InputDecoration(
                  labelText: 'Nuevo Total Abonado',
                  prefixIcon: Icon(
                    Icons.monetization_on_outlined,
                    color: vc.primaryDefault,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return l10n.fieldRequired;
                  final parsed = double.tryParse(val);
                  if (parsed == null) return l10n.invalidAmount;
                  if (parsed < 0) return 'El monto no puede ser negativo';
                  return null;
                },
              ),
              _buildDifferenceIndicator(vc),
              const SizedBox(height: 12),
              TextFormField(
                controller: _refController,
                enabled: !isLoading,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.referenceLabel,
                  prefixIcon: Icon(
                    Icons.receipt_long_outlined,
                    color: vc.primaryDefault,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                enabled: !isLoading,
                maxLines: 2,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.notesLabel,
                  prefixIcon: Icon(
                    Icons.note_alt_outlined,
                    color: vc.primaryDefault,
                  ),
                ),
              ),
              itemsAsync.when(
                data: (items) {
                  if (items.isEmpty) return const SizedBox.shrink();
                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _extraAmountController,
                        enabled: !isLoading,
                        onChanged: (val) => setState(() {}),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.extraAmountInput,
                          prefixIcon: Icon(
                            Icons.add_circle_outline,
                            color: vc.primaryDefault,
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return null;
                          final parsed = double.tryParse(val);
                          if (parsed == null) return l10n.invalidAmount;
                          if (parsed < 0)
                            return 'El monto extra no puede ser negativo';
                          return null;
                        },
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
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
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    color: vc.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: vc.primaryDefault,
                  foregroundColor: vc.textOnPrimary,
                ),
                child: Text(
                  l10n.save,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
    );
  }

  Widget _buildSummaryCard(VecinalSemanticColors vc) {
    final double newTotalPaid =
        double.tryParse(_amountController.text) ?? widget.payment.amountPaid;
    final double newBalance = widget.payment.totalDue - newTotalPaid;

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
              const Text(
                'Total debido:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                '\$${widget.payment.totalDue.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Abonado actualmente:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                '\$${widget.payment.amountPaid.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: vc.paymentSuccessText,
                ),
              ),
            ],
          ),
          const Divider(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nuevo Saldo Restante:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Text(
                '\$${newBalance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: newBalance > 0
                      ? vc.destructive
                      : vc.paymentSuccessText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
