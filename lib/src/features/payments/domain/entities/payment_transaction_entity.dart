class PaymentTransactionEntity {
  final String id;
  final String housingPaymentId;
  final double amount;
  final double extraAmount;
  final String type; // 'partial', 'complete', 'correction'
  final DateTime createdAt;
  final String createdBy;
  final String? notes;
  final String? lot;
  final String? house;
  final String? conceptTitle;
  final String? conceptId;
  final bool isConfirmed;
  final DateTime? confirmedAt;

  const PaymentTransactionEntity({
    required this.id,
    required this.housingPaymentId,
    required this.amount,
    this.extraAmount = 0.0,
    required this.type,
    required this.createdAt,
    required this.createdBy,
    this.notes,
    this.lot,
    this.house,
    this.conceptTitle,
    this.conceptId,
    this.isConfirmed = true,
    this.confirmedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentTransactionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          housingPaymentId == other.housingPaymentId &&
          amount == other.amount &&
          extraAmount == other.extraAmount &&
          type == other.type &&
          createdAt == other.createdAt &&
          createdBy == other.createdBy &&
          notes == other.notes &&
          lot == other.lot &&
          house == other.house &&
          conceptTitle == other.conceptTitle &&
          conceptId == other.conceptId &&
          isConfirmed == other.isConfirmed &&
          confirmedAt == other.confirmedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      housingPaymentId.hashCode ^
      amount.hashCode ^
      extraAmount.hashCode ^
      type.hashCode ^
      createdAt.hashCode ^
      createdBy.hashCode ^
      notes.hashCode ^
      lot.hashCode ^
      house.hashCode ^
      conceptTitle.hashCode ^
      conceptId.hashCode ^
      isConfirmed.hashCode ^
      confirmedAt.hashCode;
}
