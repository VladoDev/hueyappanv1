class ResidentEntity {
  final String uid;
  final String name;
  final String email;
  final String lot;
  final String house;
  final String accountStatus;
  final String? phone;
  final String? residentType;
  final String role;
  final bool isPhoneVerified;

  const ResidentEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.lot,
    required this.house,
    required this.accountStatus,
    this.phone,
    this.residentType,
    this.role = 'vecino',
    this.isPhoneVerified = false,
  });

  bool get isAdmin => role == 'admin';
  bool get isVecino => role == 'vecino';

  ResidentEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? lot,
    String? house,
    String? accountStatus,
    String? phone,
    String? residentType,
    String? role,
    bool? isPhoneVerified,
  }) {
    return ResidentEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      lot: lot ?? this.lot,
      house: house ?? this.house,
      accountStatus: accountStatus ?? this.accountStatus,
      phone: phone ?? this.phone,
      residentType: residentType ?? this.residentType,
      role: role ?? this.role,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResidentEntity &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          email == other.email &&
          lot == other.lot &&
          house == other.house &&
          accountStatus == other.accountStatus &&
          phone == other.phone &&
          residentType == other.residentType &&
          role == other.role &&
          isPhoneVerified == other.isPhoneVerified;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      lot.hashCode ^
      house.hashCode ^
      accountStatus.hashCode ^
      phone.hashCode ^
      residentType.hashCode ^
      role.hashCode ^
      isPhoneVerified.hashCode;
}
