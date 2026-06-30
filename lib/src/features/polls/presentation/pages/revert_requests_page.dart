import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/polls_provider.dart';

class RevertRequestsPage extends ConsumerWidget {
  const RevertRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(revertRequestsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de Reversión'),
      ),
      body: requestsAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('No hay solicitudes pendientes'));
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
                      Text('Votación: ${req.pollTitle}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Usuario: ${req.userName}'),
                      Text('Casa/Lote: ${req.houseId.replaceAll('_', ' ')}'),
                      Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(req.createdAt)}'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              ref.read(pollsNotifierProvider.notifier).processRevertRequest(req, false);
                            },
                            child: const Text('Rechazar', style: TextStyle(color: Colors.red)),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              ref.read(pollsNotifierProvider.notifier).processRevertRequest(req, true);
                            },
                            child: const Text('Aprobar'),
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
