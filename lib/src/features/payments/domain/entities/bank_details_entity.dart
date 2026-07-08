class BankDetailsEntity {
  final String bankName;
  final String accountName;
  final String clabe;
  final String reference;

  const BankDetailsEntity({
    required this.bankName,
    required this.accountName,
    required this.clabe,
    required this.reference,
  });

  BankDetailsEntity copyWith({
    String? bankName,
    String? accountName,
    String? clabe,
    String? reference,
  }) {
    return BankDetailsEntity(
      bankName: bankName ?? this.bankName,
      accountName: accountName ?? this.accountName,
      clabe: clabe ?? this.clabe,
      reference: reference ?? this.reference,
    );
  }

  factory BankDetailsEntity.empty() {
    return const BankDetailsEntity(
      bankName: '',
      accountName: '',
      clabe: '',
      reference: '',
    );
  }
}
