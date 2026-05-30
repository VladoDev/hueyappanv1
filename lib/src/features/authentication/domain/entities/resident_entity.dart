class ResidentEntity {
  final String uid;
  final String name;
  final String email;
  final String housingUnit;
  final String accountStatus;
  final String? phone;
  final String? residentType;

  const ResidentEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.housingUnit,
    required this.accountStatus,
    this.phone,
    this.residentType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResidentEntity &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          email == other.email &&
          housingUnit == other.housingUnit &&
          accountStatus == other.accountStatus &&
          phone == other.phone &&
          residentType == other.residentType;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      housingUnit.hashCode ^
      accountStatus.hashCode ^
      phone.hashCode ^
      residentType.hashCode;
}
