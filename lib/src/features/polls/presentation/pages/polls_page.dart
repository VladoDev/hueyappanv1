import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/polls_provider.dart';
import '../widgets/poll_card.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

class PollsPage extends ConsumerWidget {
  const PollsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollsAsync = ref.watch(pollsStreamProvider);
    final authState = ref.watch(authStateProvider);
    final resident = authState.value;
    final isAdmin = resident?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Votaciones Vecinales'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Solicitudes de Reversión',
              onPressed: () => context.push('/polls/revert-requests'),
            )
        ],
      ),
      body: pollsAsync.when(
        data: (polls) {
          if (polls.isEmpty) {
            return const Center(child: Text('No hay votaciones disponibles'));
          }
          return ListView.builder(
            padding: EdgeInsets.only(
              top: 16, left: 16, right: 16,
              bottom: isAdmin ? 180 : 16,
            ),
            itemCount: polls.length,
            itemBuilder: (context, index) {
              final poll = polls[index];
              return PollCard(poll: poll);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: isAdmin
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.push('/polls/create');
                },
                icon: const Icon(Icons.add),
                label: const Text('Nueva Votación'),
              ),
            )
          : null,
    );
  }
}
