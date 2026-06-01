import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../domain/entities/housing_payment_entity.dart';
import '../providers/payments_provider.dart';

class NeighborPaymentsView extends ConsumerWidget {
  final String housingUnit;

  const NeighborPaymentsView({
    super.key,
    required this.housingUnit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final paymentsAsync = ref.watch(neighborPaymentsStreamProvider(housingUnit));

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
          final history = payments.where((p) => p.paymentStatus == 'paid').toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: VecinalSpacing.xl, vertical: VecinalSpacing.base),
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
              const SizedBox(height: 24),
              Text(
                l10n.paymentsHistory,
                style: VecinalTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: vc.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              if (history.isEmpty)
                _buildEmptyState(l10n.noPaymentsFound, Icons.history_outlined, vc)
              else
                ...history.map((p) => _NeighborHistoryCard(payment: p)),
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
    final reference = l10n.housingUnitValue(housingUnit);

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
                  Text(
                    '${l10n.conceptTotalCost}: \$${payment.totalDue.toStringAsFixed(2)}',
                    style: VecinalTextStyles.bodySmall.copyWith(color: vc.textHint),
                  ),
                  Text(
                    'Saldo: \$${payment.balance.toStringAsFixed(2)}',
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
                if (isPartial) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 16),
                  Text(
                    'Total pagado: \$${payment.amountPaid.toStringAsFixed(2)}',
                    style: VecinalTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: vc.paymentSuccessText,
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
}

// ── Neighbour Paid History Card ──

class _NeighborHistoryCard extends ConsumerWidget {
  final HousingPaymentEntity payment;

  const _NeighborHistoryCard({required this.payment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    final concepts = ref.watch(conceptsStreamProvider).value;
    final concept = concepts?.firstWhere((c) => c.id == payment.conceptId);

    final dateStr = payment.paidAt != null
        ? '${payment.paidAt!.day}/${payment.paidAt!.month}/${payment.paidAt!.year}'
        : '';

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
          concept?.title ?? l10n.conceptDetails,
          style: VecinalTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          dateStr.isNotEmpty ? 'Pagado el $dateStr' : '',
          style: VecinalTextStyles.bodySmall.copyWith(color: vc.textHint),
        ),
        trailing: Text(
          '\$${payment.amountPaid.toStringAsFixed(2)}',
          style: VecinalTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.textPrimary,
          ),
        ),
      ),
    );
  }
}
