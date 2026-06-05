import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../domain/entities/housing_payment_entity.dart';
import '../../domain/entities/payment_transaction_entity.dart';
import '../providers/payments_provider.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

class NeighborPaymentsView extends ConsumerWidget {
  final String lot;
  final String house;

  const NeighborPaymentsView({
    super.key,
    required this.lot,
    required this.house,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final paymentsAsync = ref.watch(neighborPaymentsStreamProvider((lot: lot, house: house)));
    final transactionsAsync = ref.watch(neighborTransactionsStreamProvider((lot: lot, house: house)));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.maintenanceFees,
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
      ),
      body: paymentsAsync.when(
        data: (payments) {
          final pending = payments.where((p) => p.paymentStatus != 'paid').toList();

          return ListView(
            padding: const EdgeInsets.only(
              left: VecinalSpacing.xl,
              right: VecinalSpacing.xl,
              top: VecinalSpacing.base,
              bottom: 100,
            ),
            children: [
              _buildTransferCard(context),
              const SizedBox(height: 24),
              Text(
                l10n.paymentsPending,
                style: VecinalTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: vc.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              if (pending.isEmpty)
                _buildEmptyState(l10n.noPendingPayments, Icons.check_circle_outline, vc)
              else
                ...pending.map((p) => _NeighborPaymentCard(payment: p)),
              transactionsAsync.when(
                data: (transactions) {
                  final pendingConfirmations = transactions.where((t) => !t.isConfirmed).toList();
                  final confirmedHistory = transactions.where((t) => t.isConfirmed).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pendingConfirmations.isNotEmpty) ...[
                        Text(
                          'Confirmaciones Pendientes',
                          style: VecinalTextStyles.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: vc.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...pendingConfirmations.map((t) => _NeighborPendingConfirmationCard(transaction: t)),
                        const SizedBox(height: 24),
                      ],
                      Text(
                        l10n.paymentsHistory,
                        style: VecinalTextStyles.headlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: vc.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (confirmedHistory.isEmpty)
                        _buildEmptyState(l10n.noPaymentsFound, Icons.history_outlined, vc)
                      else
                        ...confirmedHistory.map((t) => _NeighborHistoryCard(transaction: t)),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState(String text, IconData icon, VecinalSemanticColors vc) {
    return Card(
      elevation: 0,
      color: vc.surfaceSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        side: BorderSide(color: vc.borderDefault, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(VecinalSpacing.xl),
        child: Column(
          children: [
            Icon(icon, size: 40, color: vc.textHint),
            const SizedBox(height: 12),
            Text(
              text,
              style: VecinalTextStyles.bodyMedium.copyWith(
                color: vc.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferCard(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    const clabe = '0123 4567 8901 2345 67';
    final reference = l10n.housingUnitValue(lot, house);

    void copyToClipboard(String text, String successMsg) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMsg),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
        ),
      );
    }

    return Card(
      elevation: 0,
      color: vc.paymentBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.lg),
        side: BorderSide(color: vc.paymentBorder, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(VecinalSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_outlined, color: vc.paymentIcon, size: 24),
                const SizedBox(width: 8),
                Text(
                  l10n.transferDetails,
                  style: VecinalTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: vc.paymentText,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            _buildTransferRow(l10n.bankNameLabel, 'BBVA Bancomer', vc),
            const SizedBox(height: 10),
            _buildTransferRow(
              l10n.clabeLabel,
              clabe,
              vc,
              onCopy: () => copyToClipboard(clabe.replaceAll(' ', ''), l10n.copySuccess),
            ),
            const SizedBox(height: 10),
            _buildTransferRow(l10n.beneficiaryLabel, 'Privada Convento Hueyapan AC', vc),
            const SizedBox(height: 10),
            _buildTransferRow(
              l10n.bankTransferReference,
              reference,
              vc,
              onCopy: () => copyToClipboard(reference, l10n.referenceCopySuccess),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferRow(String label, String value, VecinalSemanticColors vc, {VoidCallback? onCopy}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: VecinalTextStyles.bodyMedium.copyWith(
            color: vc.paymentText.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: VecinalTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: vc.paymentText,
              ),
            ),
            if (onCopy != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onCopy,
                child: Icon(Icons.copy, size: 16, color: vc.paymentIcon),
              ),
            ]
          ],
        ),
      ],
    );
  }
}

// ── Neighbour Payment Card ──

class _NeighborPaymentCard extends ConsumerWidget {
  final HousingPaymentEntity payment;

  const _NeighborPaymentCard({required this.payment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    final concepts = ref.watch(conceptsStreamProvider).value;
    final concept = concepts?.firstWhere((c) => c.id == payment.conceptId);
    final itemsAsync = ref.watch(conceptItemsStreamProvider(payment.conceptId));

    final isPartial = payment.paymentStatus == 'partial';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        side: BorderSide(
          color: isPartial ? vc.noticeBorder : vc.borderDefault,
          width: isPartial ? 1.0 : 0.5,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Expanded(
              child: Text(
                concept?.title ?? l10n.conceptDetails,
                style: VecinalTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: vc.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isPartial ? vc.noticeBg : vc.paymentPendingBg,
                borderRadius: BorderRadius.circular(VecinalRadius.xs),
              ),
              child: Text(
                isPartial ? l10n.partialPaymentTag : l10n.pendingPaymentTag,
                style: VecinalTextStyles.labelSmall.copyWith(
                  color: isPartial ? vc.noticeText : vc.paymentPendingText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (concept?.description != null && concept!.description!.isNotEmpty) ...[
                Text(
                  concept.description!,
                  style: VecinalTextStyles.bodyMedium.copyWith(color: vc.textSecondary),
                ),
                const SizedBox(height: 6),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.amountPerHouseLabel}: \$${payment.totalDue.toStringAsFixed(2)}',
                        style: VecinalTextStyles.bodySmall.copyWith(color: vc.textHint),
                      ),
                      if (concept != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${l10n.conceptTotalCost} (Ref): \$${concept.totalAmount.toStringAsFixed(2)}',
                          style: VecinalTextStyles.bodySmall.copyWith(color: vc.textHint),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    'Adeudo: \$${payment.balance.toStringAsFixed(2)}',
                    style: VecinalTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isPartial ? vc.noticeText : vc.destructive,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 16),
                Text(
                  l10n.conceptBreakdown,
                  style: VecinalTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: vc.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                itemsAsync.when(
                  data: (items) {
                    if (items.isEmpty) {
                      return Text(
                        'Sin desglose adicional.',
                        style: VecinalTextStyles.bodyMedium.copyWith(color: vc.textHint),
                      );
                    }
                    return Column(
                      children: items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.label, style: VecinalTextStyles.bodyMedium),
                              if (item.amount != null)
                                Text(
                                  '\$${item.amount!.toStringAsFixed(2)}',
                                  style: VecinalTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                ),
                if (payment.amountPaid > 0 || payment.extraAmount > 0) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 16),
                  if (payment.amountPaid > 0)
                    Text(
                      'Total pagado: \$${payment.amountPaid.toStringAsFixed(2)}',
                      style: VecinalTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: vc.paymentSuccessText,
                      ),
                    ),
                  if (payment.extraAmount > 0) ...[
                    if (payment.amountPaid > 0) const SizedBox(height: 4),
                    Text(
                      '${l10n.extraPaid}: \$${payment.extraAmount.toStringAsFixed(2)}',
                      style: VecinalTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: vc.primaryDefault,
                      ),
                    ),
                  ],
                ],
                if (payment.balance > 0) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showReportPaymentDialog(context, ref, payment, concept?.title, vc),
                      icon: const Icon(Icons.receipt_long, size: 18),
                      label: const Text(
                        'Reportar Pago',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vc.surfacePrimary,
                        foregroundColor: vc.primaryDefault,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(VecinalRadius.md),
                          side: BorderSide(color: vc.primaryDefault, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showReportPaymentDialog(
    BuildContext context,
    WidgetRef ref,
    HousingPaymentEntity payment,
    String? conceptTitle,
    VecinalSemanticColors vc,
  ) {
    final amountController = TextEditingController(text: payment.balance.toStringAsFixed(2));
    final notesController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Reportar Pago', style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registra el pago que realizaste para "${conceptTitle ?? 'Cuota'}".',
                    style: TextStyle(color: vc.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Monto Abonado',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: 'Notas / Referencia (Opcional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    maxLines: 2,
                  ),
                  if (isLoading) ...[
                    const SizedBox(height: 24),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),
            actions: isLoading
                ? []
                : [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx),
                      child: Text('Cancelar', style: TextStyle(color: vc.textSecondary)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final amount = double.tryParse(amountController.text) ?? 0.0;
                        if (amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('El monto debe ser mayor a 0')),
                          );
                          return;
                        }

                        setState(() => isLoading = true);

                        final authState = ref.read(authStateProvider);
                        final user = authState.value;

                        final type = amount >= payment.balance ? 'complete' : 'partial';

                        final success = await ref
                            .read(paymentsControllerProvider.notifier)
                            .registerPaymentTransaction(
                              housingPaymentId: payment.id,
                              amount: amount,
                              type: type,
                              createdBy: user?.name ?? 'Vecino',
                              isAdmin: false,
                              notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                            );

                        if (context.mounted) {
                          Navigator.pop(dialogCtx);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pago reportado exitosamente. Esperando confirmación del administrador.')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error al reportar el pago.')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vc.primaryDefault,
                        foregroundColor: vc.textOnPrimary,
                      ),
                      child: const Text('Enviar Reporte'),
                    ),
                  ],
          );
        },
      ),
    );
  }
}

// ── Neighbour Paid History Card ──

class _NeighborHistoryCard extends ConsumerWidget {
  final PaymentTransactionEntity transaction;

  const _NeighborHistoryCard({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    final dateStr = '${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        side: BorderSide(color: vc.borderDefault, width: 0.5),
      ),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: vc.paymentSuccessText, size: 28),
        title: Text(
          transaction.conceptTitle ?? l10n.conceptDetails,
          style: VecinalTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Abonado el $dateStr',
              style: VecinalTextStyles.bodySmall.copyWith(color: vc.textHint),
            ),
            if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                transaction.notes!,
                style: VecinalTextStyles.bodySmall.copyWith(color: vc.textSecondary, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${transaction.amount.toStringAsFixed(2)}',
              style: VecinalTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: vc.textPrimary,
              ),
            ),
            if (transaction.extraAmount > 0)
              Text(
                '+\$${transaction.extraAmount.toStringAsFixed(2)} ${l10n.extraAmountLabel.toLowerCase()}',
                style: VecinalTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: vc.primaryDefault,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NeighborPendingConfirmationCard extends ConsumerStatefulWidget {
  final PaymentTransactionEntity transaction;

  const _NeighborPendingConfirmationCard({required this.transaction});

  @override
  ConsumerState<_NeighborPendingConfirmationCard> createState() => _NeighborPendingConfirmationCardState();
}

class _NeighborPendingConfirmationCardState extends ConsumerState<_NeighborPendingConfirmationCard> {
  bool _isConfirming = false;

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final t = widget.transaction;
    
    final dateStr = '${t.createdAt.day}/${t.createdAt.month}/${t.createdAt.year}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        side: BorderSide(color: vc.noticeBorder, width: 1.0),
      ),
      color: vc.noticeBg.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    t.conceptTitle ?? l10n.conceptDetails,
                    style: VecinalTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '\$${t.amount.toStringAsFixed(2)}',
                  style: VecinalTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: vc.destructive,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Registrado el $dateStr',
                  style: VecinalTextStyles.bodySmall.copyWith(color: vc.textHint),
                ),
                if (t.extraAmount > 0)
                  Text(
                    '+\$${t.extraAmount.toStringAsFixed(2)} ${l10n.extraAmountLabel.toLowerCase()}',
                    style: VecinalTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: vc.primaryDefault,
                    ),
                  ),
              ],
            ),
            if (t.notes != null && t.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                t.notes!,
                style: VecinalTextStyles.bodySmall.copyWith(color: vc.textSecondary, fontStyle: FontStyle.italic),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isConfirming
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (dialogCtx) => AlertDialog(
                            title: const Text('Confirmar Pago', style: TextStyle(fontWeight: FontWeight.bold)),
                            content: Text('¿Confirmas que realizaste el pago de \$${t.amount.toStringAsFixed(2)} para el concepto "${t.conceptTitle ?? 'Cuota'}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogCtx),
                                child: Text('Cancelar', style: TextStyle(color: vc.textSecondary, fontWeight: FontWeight.w600)),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(dialogCtx);
                                  setState(() {
                                    _isConfirming = true;
                                  });
                                  final messenger = ScaffoldMessenger.of(context);
                                  final success = await ref
                                      .read(paymentsControllerProvider.notifier)
                                      .confirmPaymentTransaction(
                                        housingPaymentId: t.housingPaymentId,
                                        transactionId: t.id,
                                      );
                                  if (mounted) {
                                    setState(() {
                                      _isConfirming = false;
                                    });
                                    if (success) {
                                      messenger.showSnackBar(
                                        const SnackBar(content: Text('Pago confirmado con éxito')),
                                      );
                                    } else {
                                      messenger.showSnackBar(
                                        const SnackBar(content: Text('Error al confirmar el pago')),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: vc.primaryDefault,
                                  foregroundColor: vc.textOnPrimary,
                                ),
                                child: const Text('Confirmar', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text(
                  'Confirmar Pago',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: vc.primaryDefault,
                  foregroundColor: vc.textOnPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
