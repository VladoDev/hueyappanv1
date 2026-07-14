import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/polls_provider.dart';

class RevertRequestsPage extends ConsumerWidget {
  const RevertRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final requestsAsync = ref.watch(revertRequestsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.revertRequests),
      ),
      body: requestsAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return Center(child: Text(l10n.noPendingRequests));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.pollLabel(req.pollTitle), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(l10n.userLabel(req.userName)),
                      Text(l10n.houseLotLabel(req.houseId.replaceAll('_', ' '))),
                      Text(l10n.dateLabel(DateFormat('dd/MM/yyyy HH:mm').format(req.createdAt))),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              ref.read(pollsNotifierProvider.notifier).processRevertRequest(req, false);
                            },
                            child: Text(l10n.reject, style: const TextStyle(color: VecinalColors.red600)),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              ref.read(pollsNotifierProvider.notifier).processRevertRequest(req, true);
                            },
                            child: Text(l10n.approve),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
