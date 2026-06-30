import '../entities/poll_entity.dart';
import '../entities/revert_vote_request_entity.dart';
import '../../../authentication/domain/entities/resident_entity.dart';

abstract class PollsRepository {
  Stream<List<PollEntity>> getPolls();
  
  Future<void> createPoll(PollEntity poll);
  
  Future<void> deletePoll(String pollId);
  
  Future<void> closePoll(String pollId);

  Future<void> vote({
    required String pollId,
    required String optionId,
    required ResidentEntity resident,
  });

  Future<void> requestRevertVote({
    required String pollId,
    required String pollTitle,
    required ResidentEntity resident,
    required String previousOptionId,
  });

  Stream<List<RevertVoteRequestEntity>> getPendingRevertRequests();

  Future<void> processRevertRequest({
    required RevertVoteRequestEntity request,
    required bool approve,
  });
}
