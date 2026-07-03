class PollEntity {
  final String id;
  final String title;
  final String description;
  final List<PollOptionEntity> options;
  final Map<String, String> votedHouseholds; // {'Lote_Casa': 'UserName'}
  final DateTime createdAt;
  final String createdBy;
  final bool isActive;

  PollEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.options,
    required this.votedHouseholds,
    required this.createdAt,
    required this.createdBy,
    this.isActive = true,
  });

  bool hasHouseVoted(String houseId) {
    return votedHouseholds.containsKey(houseId);
  }

  int get totalVotes {
    return options.fold(0, (sum, option) => sum + option.votesCount);
  }
}

class PollOptionEntity {
  final String id;
  final String text;
  final int votesCount;

  PollOptionEntity({
    required this.id,
    required this.text,
    this.votesCount = 0,
  });
}

class PollVoteEntity {
  final String houseId;
  final String userId;
  final String userName;
  final String optionId;
  final DateTime timestamp;

  PollVoteEntity({
    required this.houseId,
    required this.userId,
    required this.userName,
    required this.optionId,
    required this.timestamp,
  });
}
