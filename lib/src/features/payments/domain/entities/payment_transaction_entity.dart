class PaymentTransactionEntity {
  final String id;
  final String housingPaymentId;
  final double amount;
  final String type; // 'partial', 'complete', 'correction'
  final DateTime createdAt;
  final String createdBy;
  final String? notes;

  const PaymentTransactionEntity({
    required this.id,
    required this.housingPaymentId,
    required this.amount,
    required this.type,
    required this.createdAt,
    required this.createdBy,
    this.notes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentTransactionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          housingPaymentId == other.housingPaymentId &&
          amount == other.amount &&
          type == other.type &&
          createdAt == other.createdAt &&
          createdBy == other.createdBy &&
          notes == other.notes;

  @override
  int get hashCode =>
      id.hashCode ^
      housingPaymentId.hashCode ^
      amount.hashCode ^
      type.hashCode ^
      createdAt.hashCode ^
      createdBy.hashCode ^
      notes.hashCode;
}
