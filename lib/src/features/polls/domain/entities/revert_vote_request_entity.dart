enum RevertRequestStatus {
  pending,
  approved,
  rejected,
}

class RevertVoteRequestEntity {
  final String id;
  final String pollId;
  final String pollTitle;
  final String userId;
  final String userName;
  final String houseId;
  final String previousOptionId;
  final RevertRequestStatus status;
  final DateTime createdAt;

  RevertVoteRequestEntity({
    required this.id,
    required this.pollId,
    required this.pollTitle,
    required this.userId,
    required this.userName,
    required this.houseId,
    required this.previousOptionId,
    this.status = RevertRequestStatus.pending,
    required this.createdAt,
  });
}
