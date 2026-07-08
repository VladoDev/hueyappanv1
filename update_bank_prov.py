import os
filepath = 'lib/src/features/payments/presentation/providers/bank_details_provider.dart'

content = """import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bank_details_entity.dart';
import '../../data/datasources/bank_details_datasource.dart';

final bankDetailsDatasourceProvider = Provider<BankDetailsDatasource>((ref) {
  return BankDetailsDatasource();
});

final bankDetailsStreamProvider = StreamProvider<BankDetailsEntity>((ref) {
  return ref.watch(bankDetailsDatasourceProvider).getBankDetailsStream();
});

final updateBankDetailsProvider = Provider<Future<void> Function(BankDetailsEntity)>((ref) {
  return (BankDetailsEntity details) {
    return ref.read(bankDetailsDatasourceProvider).updateBankDetails(details);
  };
});
"""

with open(filepath, 'w') as f:
    f.write(content)

print("Created bank_details_provider.dart")
