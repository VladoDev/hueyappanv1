import '../../domain/repositories/polls_repository.dart';
import '../../domain/entities/poll_entity.dart';
import '../../domain/entities/revert_vote_request_entity.dart';
import '../../../authentication/domain/entities/resident_entity.dart';
import '../datasources/polls_firebase_datasource.dart';
import '../models/poll_model.dart';

class PollsRepositoryImpl implements PollsRepository {
  final PollsFirebaseDatasource _datasource;

  PollsRepositoryImpl(this._datasource);

  @override
  Stream<List<PollEntity>> getPolls() {
    return _datasource.getPolls().map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<void> createPoll(PollEntity poll) async {
    final model = PollModel.fromEntity(poll);
    await _datasource.createPoll(model);
  }

  @override
  Future<void> deletePoll(String pollId) async {
    await _datasource.deletePoll(pollId);
  }

  @override
  Future<void> closePoll(String pollId) async {
    await _datasource.closePoll(pollId);
  }

  @override
  Future<void> vote({
    required String pollId,
    required String optionId,
    required ResidentEntity resident,
  }) async {
    await _datasource.vote(
      pollId: pollId,
      optionId: optionId,
      resident: resident,
    );
  }

  @override
  Future<void> requestRevertVote({
    required String pollId,
    required String pollTitle,
    required ResidentEntity resident,
    required String previousOptionId,
  }) async {
    await _datasource.requestRevertVote(
      pollId: pollId,
      pollTitle: pollTitle,
      resident: resident,
      previousOptionId: previousOptionId,
    );
  }

  @override
  Stream<List<RevertVoteRequestEntity>> getPendingRevertRequests() {
    return _datasource
        .getPendingRevertRequests()
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<void> processRevertRequest({
    required RevertVoteRequestEntity request,
    required bool approve,
  }) async {
    await _datasource.processRevertRequest(request: request, approve: approve);
  }
}
