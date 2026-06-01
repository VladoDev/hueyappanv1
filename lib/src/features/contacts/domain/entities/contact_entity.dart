class ContactEntity {
  final int id;
  final String name;
  final String phoneNumber;
  final String category;
  final bool isFavorite;

  const ContactEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.category,
    required this.isFavorite,
  });

  ContactEntity copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? category,
    bool? isFavorite,
  }) {
    return ContactEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContactEntity &&
        other.id == id &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.category == category &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, phoneNumber, category, isFavorite);
  }
}
