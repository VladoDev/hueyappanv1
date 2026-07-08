import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/polls_provider.dart';
import '../widgets/poll_card.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import 'package:hueyappanv1/src/core/widgets/vecinal_empty_state.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';

class PollsPage extends ConsumerWidget {
  const PollsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollsAsync = ref.watch(pollsStreamProvider);
    final authState = ref.watch(authStateProvider);
    final resident = authState.value;
    final isAdmin = resident?.isAdmin ?? false;

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.neighborhoodPolls,
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: context.vecinalColors.primaryDefault,
          ),
        ),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: l10n.revertRequests,
              onPressed: () => context.push('/polls/revert-requests'),
            )
        ],
      ),
      body: pollsAsync.when(
        data: (polls) {
          if (polls.isEmpty) {
            return VecinalEmptyState(
              icon: Icons.how_to_vote_outlined,
              message: l10n.noPollsAvailable,
            );
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
        error: (err, stack) => Center(child: Text(l10n.errorGeneric(err.toString()))),
      ),
      floatingActionButton: isAdmin
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.push('/polls/create');
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.newPoll),
              ),
            )
          : null,
    );
  }
}
