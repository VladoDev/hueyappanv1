import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../domain/entities/payment_concept_entity.dart';
import '../providers/payments_provider.dart';

class AdminPaymentsView extends ConsumerWidget {
  const AdminPaymentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final conceptsAsync = ref.watch(conceptsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.adminPanel,
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.createConcept,
            onPressed: () => context.push('/payments/new'),
          ),
        ],
      ),
      body: conceptsAsync.when(
        data: (concepts) {
          if (concepts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment_outlined, size: 64, color: vc.textHint),
                    const SizedBox(height: 16),
                    Text(
                      'No hay conceptos de pago creados aún.',
                      style: VecinalTextStyles.headlineSmall.copyWith(color: vc.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/payments/new'),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.createConcept),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vc.primaryDefault,
                        foregroundColor: vc.textOnPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VecinalRadius.md)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(VecinalSpacing.xl),
            itemCount: concepts.length,
            itemBuilder: (context, index) {
              return _ConceptCard(concept: concepts[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

// ── Admin Concept Card ──

class _ConceptCard extends ConsumerWidget {
  final PaymentConceptEntity concept;

  const _ConceptCard({required this.concept});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final paymentsAsync = ref.watch(conceptPaymentsStreamProvider(concept.id));

    String statusText(String status) {
      switch (status) {
        case 'active':
          return l10n.activeStatus;
        case 'closed':
          return l10n.closedStatus;
        case 'cancelled':
          return l10n.cancelledStatus;
        default:
          return status;
      }
    }

    Color statusColor(String status) {
      switch (status) {
        case 'active':
          return vc.paymentSuccessText;
        case 'closed':
          return vc.textHint;
        case 'cancelled':
          return vc.destructive;
        default:
          return vc.textPrimary;
      }
    }

    Color statusBgColor(String status) {
      switch (status) {
        case 'active':
          return vc.paymentSuccessBg;
        case 'closed':
          return vc.surfaceSecondary;
        case 'cancelled':
          return vc.destructiveBg;
        default:
          return vc.surfaceSecondary;
      }
    }

    void confirmDelete() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(l10n.deleteConcept, style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Text(l10n.deleteConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel, style: TextStyle(color: vc.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final success = await ref
                      .read(paymentsControllerProvider.notifier)
                      .deleteConcept(concept.id);
                  if (context.mounted && success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Concepto eliminado con éxito')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: vc.destructive, foregroundColor: vc.textOnPrimary),
                child: Text(l10n.delete),
              ),
            ],
          );
        },
      );
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.lg),
        side: BorderSide(color: vc.borderDefault, width: 0.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(VecinalRadius.lg),
        onTap: () => context.push('/payments/detail/${concept.id}'),
        child: Padding(
          padding: const EdgeInsets.all(VecinalSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      concept.title,
                      style: VecinalTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: vc.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBgColor(concept.status),
                      borderRadius: BorderRadius.circular(VecinalRadius.xs),
                    ),
                    child: Text(
                      statusText(concept.status),
                      style: VecinalTextStyles.labelSmall.copyWith(
                        color: statusColor(concept.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: vc.textSecondary),
                    onSelected: (val) {
                      if (val == 'edit') {
                        context.push('/payments/edit/${concept.id}');
                      } else if (val == 'delete') {
                        confirmDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20, color: vc.textPrimary),
                            const SizedBox(width: 8),
                            Text(l10n.editConcept),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 20, color: vc.destructive),
                            const SizedBox(width: 8),
                            Text(l10n.deleteConcept, style: TextStyle(color: vc.destructive)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (concept.description != null && concept.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  concept.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: VecinalTextStyles.bodyMedium.copyWith(color: vc.textSecondary),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total: \$${concept.totalAmount.toStringAsFixed(2)}',
                        style: VecinalTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.amountPerHouseLabel}: \$${concept.amountPerUnit.toStringAsFixed(2)}',
                        style: VecinalTextStyles.bodySmall.copyWith(color: vc.textHint),
                      ),
                    ],
                  ),
                  paymentsAsync.when(
                    data: (payments) {
                      final total = payments.length;
                      final paid = payments.where((p) => p.paymentStatus == 'paid').length;
                      final percent = total > 0 ? (paid / total) : 0.0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$paid de $total pagados',
                            style: VecinalTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: vc.primaryDefault,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 100,
                            height: 6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: percent,
                                backgroundColor: vc.borderDefault,
                                valueColor: AlwaysStoppedAnimation<Color>(vc.primaryDefault),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox(
                      width: 50,
                      height: 20,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    error: (err, stack) => const Text('Err'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
