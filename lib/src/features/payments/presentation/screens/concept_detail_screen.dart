import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../domain/entities/housing_payment_entity.dart';
import '../../domain/entities/payment_concept_entity.dart';
import '../providers/payments_provider.dart';
import 'payment_register_dialog.dart';

class ConceptDetailScreen extends ConsumerStatefulWidget {
  final String conceptId;

  const ConceptDetailScreen({
    super.key,
    required this.conceptId,
  });

  @override
  ConsumerState<ConceptDetailScreen> createState() => _ConceptDetailScreenState();
}

class _ConceptDetailScreenState extends ConsumerState<ConceptDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showUpdateExpenseDialog(PaymentConceptEntity concept, VecinalSemanticColors vc, AppLocalizations l10n) {
    final controller = TextEditingController(text: concept.recordedExpense.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.updateExpense, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.itemAmount,
              prefixIcon: Icon(Icons.monetization_on_outlined, color: vc.primaryDefault),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel, style: TextStyle(color: vc.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                final double expense = double.tryParse(controller.text) ?? 0.0;
                Navigator.of(context).pop();
                await ref
                    .read(paymentsControllerProvider.notifier)
                    .updateRecordedExpense(conceptId: concept.id, expense: expense);
              },
              style: ElevatedButton.styleFrom(backgroundColor: vc.primaryDefault, foregroundColor: vc.textOnPrimary),
              child: Text(l10n.save, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    final conceptsAsync = ref.watch(conceptsStreamProvider);
    final paymentsAsync = ref.watch(conceptPaymentsStreamProvider(widget.conceptId));

    return conceptsAsync.when(
      data: (concepts) {
        final concept = concepts.where((c) => c.id == widget.conceptId).firstOrNull;
        if (concept == null) {
          return const Scaffold(body: Center(child: Text('Concepto no encontrado')));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              concept.title,
              style: VecinalTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: vc.primaryDefault,
              ),
            ),
          ),
          body: paymentsAsync.when(
            data: (payments) {
              final paid = payments.where((p) => p.paymentStatus == 'paid').toList();
              final pending = payments.where((p) => p.paymentStatus != 'paid').toList();

              final totalCollected = payments.fold<double>(0, (sum, p) => sum + p.amountPaid);
              final totalExtraCollected = payments.fold<double>(0, (sum, p) => sum + p.extraAmount);
              final totalPending = payments.fold<double>(0, (sum, p) => sum + p.balance);
              final recordedExpense = concept.recordedExpense;
              final availableBalance = totalCollected + totalExtraCollected - recordedExpense;

              return Column(
                children: [
                  _buildFinancialSummary(totalCollected, totalExtraCollected, totalPending, recordedExpense, availableBalance, () => _showUpdateExpenseDialog(concept, vc, l10n), vc, l10n),
                  TabBar(
                    controller: _tabController,
                    labelColor: vc.primaryDefault,
                    unselectedLabelColor: vc.textSecondary,
                    indicatorColor: vc.primaryDefault,
                    tabs: [
                      Tab(
                        child: Text(
                          '${l10n.pendingHouses} (${pending.length})',
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                      Tab(
                        child: Text(
                          '${l10n.paidHouses} (${paid.length})',
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPaymentList(pending, vc, l10n),
                        _buildPaymentList(paid, vc, l10n),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildFinancialSummary(
      double collected, double extraCollected, double pending, double expense, double balance, VoidCallback onUpdateExpense, VecinalSemanticColors vc, AppLocalizations l10n) {
    return Container(
      color: vc.surfaceSecondary,
      padding: const EdgeInsets.all(VecinalSpacing.xl),
      child: Column(
        children: [
          Row(
            children: [
              _buildSummaryItem(
                l10n.totalCollectedLabel,
                collected,
                vc.paymentSuccessText,
                vc,
                subtitle: extraCollected > 0 ? '${l10n.extraAmountLabel}: +\$${extraCollected.toStringAsFixed(2)}' : null,
              ),
              const SizedBox(width: 16),
              _buildSummaryItem(l10n.totalPendingLabel, pending, vc.destructive, vc),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryItem(l10n.recordedExpenseLabel, expense, vc.textPrimary, vc),
              const SizedBox(width: 16),
              _buildSummaryItem(l10n.availableBalanceLabel, balance, balance >= 0 ? vc.paymentSuccessText : vc.destructive, vc),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onUpdateExpense,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(l10n.updateExpense, style: const TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: vc.borderDefault),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double value, Color valueColor, VecinalSemanticColors vc, {String? subtitle}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: vc.surfacePrimary,
          borderRadius: BorderRadius.circular(VecinalRadius.md),
          border: Border.all(color: vc.borderDefault, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: VecinalTextStyles.bodySmall.copyWith(color: vc.textHint)),
            const SizedBox(height: 4),
            Text(
              '\$${value.toStringAsFixed(2)}',
              style: VecinalTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: VecinalTextStyles.bodySmall.copyWith(color: vc.primaryDefault, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentList(List<HousingPaymentEntity> list, VecinalSemanticColors vc, AppLocalizations l10n) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          'Ninguna casa en esta sección.',
          style: VecinalTextStyles.bodyMedium.copyWith(color: vc.textHint),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(VecinalSpacing.xl),
      itemCount: list.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final payment = list[index];
        return _PaymentListRow(payment: payment);
      },
    );
  }
}

// ── Payment Row Widget ──

class _PaymentListRow extends ConsumerWidget {
  final HousingPaymentEntity payment;

  const _PaymentListRow({required this.payment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final residentNameAsync = ref.watch(residentNameProvider(payment.residentUid));

    final isPaid = payment.paymentStatus == 'paid';
    final isPartial = payment.paymentStatus == 'partial';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => PaymentRegisterDialog(payment: payment),
        );
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              payment.housingUnit,
              style: VecinalTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          if (payment.hasPendingConfirmation)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: vc.noticeBg,
                borderRadius: BorderRadius.circular(VecinalRadius.xs),
                border: Border.all(color: vc.noticeBorder, width: 0.5),
              ),
              child: const Text(
                'Por confirmar',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (!isPaid)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            residentNameAsync.when(
              data: (name) => Text(name, style: VecinalTextStyles.bodyMedium.copyWith(color: vc.textSecondary)),
              loading: () => Text('Cargando...', style: VecinalTextStyles.bodyMedium.copyWith(color: vc.textHint)),
              error: (err, stack) => Text('Residente', style: VecinalTextStyles.bodyMedium.copyWith(color: vc.textHint)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isPaid)
                  Text(
                    'Pagó: \$${payment.amountPaid.toStringAsFixed(2)}',
                    style: VecinalTextStyles.bodyMedium.copyWith(color: vc.paymentSuccessText, fontWeight: FontWeight.bold),
                  )
                else
                  Text(
                    'Debe: \$${payment.balance.toStringAsFixed(2)}',
                    style: VecinalTextStyles.bodyMedium.copyWith(
                      color: isPartial ? vc.noticeText : vc.destructive,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (payment.extraAmount > 0)
                  Text(
                    '+ \$${payment.extraAmount.toStringAsFixed(2)} extra',
                    style: VecinalTextStyles.bodySmall.copyWith(
                      color: vc.primaryDefault,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: vc.textHint),
    );
  }
}
