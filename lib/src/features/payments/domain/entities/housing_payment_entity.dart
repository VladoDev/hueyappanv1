class HousingPaymentEntity {
  final String id;
  final String conceptId;
  final String residentUid;
  final String housingUnit;
  final double totalDue;
  final double amountPaid;
  final double balance;
  final String paymentStatus; // 'pending', 'partial', 'paid'
  final DateTime? paidAt;
  final String? notes;

  const HousingPaymentEntity({
    required this.id,
    required this.conceptId,
    required this.residentUid,
    required this.housingUnit,
    required this.totalDue,
    required this.amountPaid,
    required this.balance,
    required this.paymentStatus,
    this.paidAt,
    this.notes,
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
          paidAt == other.paidAt &&
          notes == other.notes;

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
      paidAt.hashCode ^
      notes.hashCode;
}
