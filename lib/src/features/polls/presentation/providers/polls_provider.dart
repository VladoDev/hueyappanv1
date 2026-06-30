import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/poll_entity.dart';
import '../../domain/entities/revert_vote_request_entity.dart';
import '../../data/datasources/polls_firebase_datasource.dart';
import '../../data/repositories/polls_repository_impl.dart';
import '../../domain/repositories/polls_repository.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

final pollsDatasourceProvider = Provider<PollsFirebaseDatasource>((ref) {
  return PollsFirebaseDatasource();
});

final pollsRepositoryProvider = Provider<PollsRepository>((ref) {
  final datasource = ref.watch(pollsDatasourceProvider);
  return PollsRepositoryImpl(datasource);
});

final pollsStreamProvider = StreamProvider.autoDispose<List<PollEntity>>((ref) {
  final repository = ref.watch(pollsRepositoryProvider);
  return repository.getPolls();
});

final revertRequestsStreamProvider = StreamProvider.autoDispose<List<RevertVoteRequestEntity>>((ref) {
  final repository = ref.watch(pollsRepositoryProvider);
  return repository.getPendingRevertRequests();
});

class PollsNotifier extends Notifier<AsyncValue<void>> {
  late PollsRepository _repository;

  @override
  AsyncValue<void> build() {
    _repository = ref.watch(pollsRepositoryProvider);
    return const AsyncValue.data(null);
  }

  Future<void> createPoll(PollEntity poll) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createPoll(poll);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deletePoll(String pollId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deletePoll(pollId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> closePoll(String pollId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.closePoll(pollId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> vote(String pollId, String optionId) async {
    state = const AsyncValue.loading();
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('No autenticado');
      
      await _repository.vote(
        pollId: pollId,
        optionId: optionId,
        resident: user,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> requestRevertVote(String pollId, String pollTitle, String previousOptionId) async {
    state = const AsyncValue.loading();
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('No autenticado');

      await _repository.requestRevertVote(
        pollId: pollId,
        pollTitle: pollTitle,
        resident: user,
        previousOptionId: previousOptionId,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> processRevertRequest(RevertVoteRequestEntity request, bool approve) async {
    state = const AsyncValue.loading();
    try {
      await _repository.processRevertRequest(request: request, approve: approve);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final pollsNotifierProvider = NotifierProvider<PollsNotifier, AsyncValue<void>>(PollsNotifier.new);
