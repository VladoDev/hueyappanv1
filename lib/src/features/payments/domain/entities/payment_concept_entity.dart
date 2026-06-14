class PaymentConceptEntity {
  final String id;
  final String title;
  final String? description;
  final double totalAmount;
  final int totalUnits;
  final double amountPerUnit;
  final String status; // 'active', 'closed', 'cancelled'
  final DateTime createdAt;
  final DateTime updatedAt;
  final double recordedExpense;

  const PaymentConceptEntity({
    required this.id,
    required this.title,
    this.description,
    required this.totalAmount,
    required this.totalUnits,
    required this.amountPerUnit,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.recordedExpense = 0.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentConceptEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          totalAmount == other.totalAmount &&
          totalUnits == other.totalUnits &&
          amountPerUnit == other.amountPerUnit &&
          status == other.status &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          recordedExpense == other.recordedExpense;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      totalAmount.hashCode ^
      totalUnits.hashCode ^
      amountPerUnit.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      recordedExpense.hashCode;
}
