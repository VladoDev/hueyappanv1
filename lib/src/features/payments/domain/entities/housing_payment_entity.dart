class HousingPaymentEntity {
  final String id;
  final String conceptId;
  final String residentUid;
  final String housingUnit;
  final double totalDue;
  final double amountPaid;
  final double balance;
  final String paymentStatus; // 'pending', 'partial', 'paid'
  final double extraAmount;
  final DateTime? paidAt;
  final String? notes;
  final bool hasPendingConfirmation;

  const HousingPaymentEntity({
    required this.id,
    required this.conceptId,
    required this.residentUid,
    required this.housingUnit,
    required this.totalDue,
    required this.amountPaid,
    required this.balance,
    required this.paymentStatus,
    this.extraAmount = 0.0,
    this.paidAt,
    this.notes,
    this.hasPendingConfirmation = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HousingPaymentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          conceptId == other.conceptId &&
          residentUid == other.residentUid &&
          housingUnit == other.housingUnit &&
          totalDue == other.totalDue &&
          amountPaid == other.amountPaid &&
          balance == other.balance &&
          paymentStatus == other.paymentStatus &&
          extraAmount == other.extraAmount &&
          paidAt == other.paidAt &&
          notes == other.notes &&
          hasPendingConfirmation == other.hasPendingConfirmation;

  @override
  int get hashCode =>
      id.hashCode ^
      conceptId.hashCode ^
      residentUid.hashCode ^
      housingUnit.hashCode ^
      totalDue.hashCode ^
      amountPaid.hashCode ^
      balance.hashCode ^
      paymentStatus.hashCode ^
      extraAmount.hashCode ^
      paidAt.hashCode ^
      notes.hashCode ^
      hasPendingConfirmation.hashCode;
}
