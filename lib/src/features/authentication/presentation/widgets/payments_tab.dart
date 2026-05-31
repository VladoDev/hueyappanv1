import 'package:flutter/material.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

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
      body: Padding(
        padding: const EdgeInsets.all(VecinalSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(context, vc),
            const SizedBox(height: 24),
            Text(
              l10n.paymentHistory,
              style: VecinalTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: vc.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildHistoryItem(
              l10n.aprilFee,
              l10n.amountPaidValue('120.00'),
              l10n.aprilFeeDate,
              vc,
            ),
            _buildHistoryItem(
              l10n.marchFee,
              l10n.amountPaidValue('120.00'),
              l10n.marchFeeDate,
              vc,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, VecinalSemanticColors vc) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.lg),
        side: BorderSide(color: vc.paymentBorder, width: 0.5),
      ),
      color: vc.paymentBg,
      child: Padding(
        padding: const EdgeInsets.all(VecinalSpacing.xl),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.mayDues,
                  style: VecinalTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: vc.paymentText,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: vc.paymentSuccessBg,
                    borderRadius: BorderRadius.circular(VecinalRadius.sm),
                    border: Border.all(color: vc.paymentSuccessText.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Text(
                    l10n.paidStatus,
                    style: VecinalTextStyles.labelSmall.copyWith(
                      color: vc.paymentSuccessText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.amountPaid,
                  style: VecinalTextStyles.bodyMedium.copyWith(color: vc.paymentText.withValues(alpha: 0.8)),
                ),
                Text(
                  l10n.amountPaidValue('120.00'),
                  style: VecinalTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: vc.paymentText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String amount, String date, VecinalSemanticColors vc) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        side: BorderSide(color: vc.borderDefault, width: 0.5),
      ),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: vc.paymentSuccessText),
        title: Text(
          title,
          style: VecinalTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          date,
          style: VecinalTextStyles.bodySmall.copyWith(color: vc.textHint),
        ),
        trailing: Text(
          amount,
          style: VecinalTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.textPrimary,
          ),
        ),
      ),
    );
  }
}
