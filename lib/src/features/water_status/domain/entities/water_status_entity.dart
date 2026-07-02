class WaterStatusEntity {
  final String
  status; // 'auto', 'maintenance', 'force_available', 'force_unavailable'
  final DateTime? updatedAt;
  final String? updatedBy;

  const WaterStatusEntity({
    required this.status,
    this.updatedAt,
    this.updatedBy,
  });

  bool get isAuto => status == 'auto';
  bool get isMaintenance => status == 'maintenance';
  bool get isForceAvailable => status == 'force_available';
  bool get isForceUnavailable => status == 'force_unavailable';

  /// Calculates if water is available TODAY based on the "one day yes, one day no" rule.
  /// Base date: June 13, 2026 was a day WITHOUT water.
  bool get isWaterAvailableToday {
    if (isForceAvailable) return true;
    if (isForceUnavailable || isMaintenance) return false;

    // 'auto' logic:
    // Reference date where water was NO: June 13, 2026.
    final baseDate = DateTime(2026, 6, 13);
    final today = DateTime.now();

    // Calculate difference in days using UTC to avoid timezone/daylight saving quirks
    final baseDateUtc = DateTime.utc(
      baseDate.year,
      baseDate.month,
      baseDate.day,
    );
    final todayUtc = DateTime.utc(today.year, today.month, today.day);

    final differenceInDays = todayUtc.difference(baseDateUtc).inDays;

    // June 13 (diff 0) -> NO
    // June 14 (diff 1) -> YES
    // June 15 (diff 2) -> NO
    // So if differenceInDays is odd, it's YES. If even, it's NO.
    return differenceInDays % 2 != 0;
  }
}
