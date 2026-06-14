const fs = require('fs');

const files = [
  'lib/src/features/payments/data/datasources/payments_firebase_datasource.dart',
  'lib/src/features/payments/data/repositories/payments_repository_impl.dart',
  'lib/src/features/payments/data/models/payment_transaction_model.dart',
  'lib/src/features/payments/data/models/housing_payment_model.dart',
  'lib/src/features/payments/domain/repositories/payments_repository.dart',
  'lib/src/features/payments/domain/usecases/watch_neighbor_payments_usecase.dart',
  'lib/src/features/payments/domain/entities/payment_transaction_entity.dart',
  'lib/src/features/payments/domain/entities/housing_payment_entity.dart',
  'lib/src/features/payments/presentation/providers/payments_provider.dart',
  'lib/src/features/payments/presentation/screens/payment_register_dialog.dart',
  'lib/src/features/payments/presentation/screens/payments_tab_screen.dart',
  'lib/src/features/payments/presentation/screens/concept_detail_screen.dart',
  'lib/src/features/payments/presentation/screens/neighbor_payments_view.dart',
  'test/features/payments/payments_usecase_test.dart'
];

for (const file of files) {
  if (!fs.existsSync(file)) continue;
  let text = fs.readFileSync(file, 'utf8');

  // Replace 'String housingUnit;' to 'String lot,\n    String house;' in parameters and fields
  // In Freezed classes:
  text = text.replace(/required String housingUnit,/g, 'required String lot,\n    required String house,');
  text = text.replace(/String\? housingUnit,/g, 'String? lot,\n    String? house,');
  
  // In plain classes:
  text = text.replace(/final String housingUnit;/g, 'final String lot;\n  final String house;');
  text = text.replace(/final String\? housingUnit;/g, 'final String? lot;\n  final String? house;');
  
  text = text.replace(/required this\.housingUnit/g, 'required this.lot,\n    required this.house');
  text = text.replace(/this\.housingUnit/g, 'this.lot,\n    this.house');
  
  // Object mapping:
  text = text.replace(/'housingUnit': housingUnit,/g, "'lot': lot,\n        'house': house,");
  text = text.replace(/'housingUnit': payment\.housingUnit/g, "'lot': payment.lot,\n        'house': payment.house");
  text = text.replace(/housingUnit: housingUnit,/g, "lot: lot,\n        house: house,");
  text = text.replace(/housingUnit: payment\.housingUnit/g, "lot: payment.lot,\n        house: payment.house");
  text = text.replace(/housingUnit: entity\.housingUnit/g, "lot: entity.lot,\n        house: entity.house");
  text = text.replace(/housingUnit: tx\.housingUnit \?\? payment\.housingUnit/g, "lot: tx.lot ?? payment.lot,\n                house: tx.house ?? payment.house");
  text = text.replace(/housingUnit: user\.housingUnit/g, "lot: user.lot,\n        house: user.house");
  
  // Data extraction
  text = text.replace(/housingUnit: data\['housingUnit'\] as String\?,/g, "lot: data['lot'] as String?,\n        house: data['house'] as String?,");
  text = text.replace(/housingUnit: doc\['housingUnit'\] as String/g, "lot: doc['lot'] as String,\n        house: doc['house'] as String");
  text = text.replace(/housingUnit: doc\['housingUnit'\] as String\?/g, "lot: doc['lot'] as String?,\n        house: doc['house'] as String?");
  
  // Method signatures
  text = text.replace(/watchNeighborPayments\(String housingUnit\)/g, "watchNeighborPayments(String lot, String house)");
  text = text.replace(/execute\(String housingUnit\)/g, "execute(String lot, String house)");
  text = text.replace(/watchNeighborPayments\(housingUnit\)/g, "watchNeighborPayments(lot, house)");
  
  // Providers family
  text = text.replace(/StreamProvider\.family<List<HousingPaymentEntity>, String>\(\(ref, housingUnit\)/g, "StreamProvider.family<List<HousingPaymentEntity>, ({String lot, String house})>((ref, arg)");
  text = text.replace(/StreamProvider\.family<List<PaymentTransactionEntity>, String>\(\(ref, housingUnit\)/g, "StreamProvider.family<List<PaymentTransactionEntity>, ({String lot, String house})>((ref, arg)");
  
  // Watch provider usage
  text = text.replace(/ref\.watch\(watchNeighborPaymentsUsecaseProvider\)\.execute\(housingUnit\)/g, "ref.watch(watchNeighborPaymentsUsecaseProvider).execute(arg.lot, arg.house)");
  text = text.replace(/neighborPaymentsStreamProvider\(housingUnit\)/g, "neighborPaymentsStreamProvider(arg)");
  
  // UI texts
  text = text.replace(/housingUnitValue\(housingUnit\)/g, "housingUnitValue(lot, house)");
  text = text.replace(/payment\.housingUnit/g, "payment.lot, payment.house"); // This might be tricky in string interpolation.
  text = text.replace(/\$\{payment\.housingUnit\}/g, "${payment.lot}-${payment.house}");
  text = text.replace(/\$\{widget\.payment\.housingUnit\}/g, "${widget.payment.lot}-${widget.payment.house}");
  
  // Equatable / HashCode
  text = text.replace(/housingUnit,/g, "lot,\n        house,");

  fs.writeFileSync(file, text);
}
console.log('Refactoring complete');
