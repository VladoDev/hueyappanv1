import re
filepath = 'lib/src/features/payments/presentation/screens/neighbor_payments_view.dart'

with open(filepath, 'r') as f:
    content = f.read()

# Add import
import_statement = "import '../providers/bank_details_provider.dart';\nimport '../../../authentication/presentation/providers/auth_provider.dart';"
content = content.replace("import '../../../authentication/presentation/providers/auth_provider.dart';", import_statement)

# Pass isAdmin to buildTransferCard
if "final authState =" not in content:
    build_method = """  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authStateProvider);
    final isAdmin = authState.value?.isAdmin ?? false;"""
    content = content.replace("""  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;""", build_method)

content = content.replace("_buildTransferCard(context)", "_buildTransferCard(context, ref, isAdmin)")

card_method = """  Widget _buildTransferCard(BuildContext context, WidgetRef ref, bool isAdmin) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final bankDetailsAsync = ref.watch(bankDetailsStreamProvider);
    
    final reference = l10n.housingUnitValue(lot, house);

    void copyToClipboard(String text, String successMsg) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMsg),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VecinalRadius.md),
          ),
        ),
      );
    }

    return bankDetailsAsync.when(
      data: (bankDetails) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_outlined,
                          color: vc.paymentIcon,
                          size: 24,
                        ),
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
                    if (isAdmin)
                      IconButton(
                        icon: Icon(Icons.edit, color: vc.paymentText),
                        onPressed: () => _showEditBankDetailsDialog(context, ref, bankDetails, vc),
                      ),
                  ],
                ),
                const Divider(height: 24, thickness: 0.5),
                _buildTransferRow(l10n.bankNameLabel, bankDetails.bankName.isNotEmpty ? bankDetails.bankName : 'Not set', vc),
                const SizedBox(height: 10),
                _buildTransferRow(
                  l10n.clabeLabel,
                  bankDetails.clabe.isNotEmpty ? bankDetails.clabe : 'Not set',
                  vc,
                  onCopy: bankDetails.clabe.isNotEmpty ? () => copyToClipboard(bankDetails.clabe.replaceAll(' ', ''), l10n.copySuccess) : null,
                ),
                const SizedBox(height: 10),
                _buildTransferRow(
                  l10n.beneficiaryLabel,
                  bankDetails.accountName.isNotEmpty ? bankDetails.accountName : 'Not set',
                  vc,
                ),
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _showEditBankDetailsDialog(BuildContext context, WidgetRef ref, bankDetails, VecinalSemanticColors vc) {
    // We will implement this in a separate file and import it
    showDialog(
      context: context,
      builder: (context) => _EditBankDetailsDialog(bankDetails: bankDetails),
    );
  }
"""

# Replace the old _buildTransferCard
old_card_start = "  Widget _buildTransferCard(BuildContext context) {"
old_card_end = "  Widget _buildTransferRow("

start_idx = content.find(old_card_start)
end_idx = content.find(old_card_end)

if start_idx != -1 and end_idx != -1:
    content = content[:start_idx] + card_method + content[end_idx:]

with open(filepath, 'w') as f:
    f.write(content)

print("Updated neighbor_payments_view.dart")
