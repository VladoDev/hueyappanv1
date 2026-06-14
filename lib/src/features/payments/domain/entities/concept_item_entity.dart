class ConceptItemEntity {
  final String id;
  final String conceptId;
  final String label;
  final double? amount;
  final int order;

  const ConceptItemEntity({
    required this.id,
    required this.conceptId,
    required this.label,
    this.amount,
    required this.order,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConceptItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          conceptId == other.conceptId &&
          label == other.label &&
          amount == other.amount &&
          order == other.order;

  @override
  int get hashCode =>
      id.hashCode ^
      conceptId.hashCode ^
      label.hashCode ^
      amount.hashCode ^
      order.hashCode;
}
