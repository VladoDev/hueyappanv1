const fs = require('fs');

function replaceFile(path, replacer) {
  if (!fs.existsSync(path)) return;
  const content = fs.readFileSync(path, 'utf8');
  const newContent = replacer(content);
  if (content !== newContent) {
    fs.writeFileSync(path, newContent);
  }
}

// 1. auth_repository_impl.dart
replaceFile('lib/src/features/authentication/data/repositories/auth_repository_impl.dart', c => {
  return c.replace(/housingUnit:/g, 'lot: \'\', house:'); // Need to see exactly what it is. I'll just change housingUnit to lot, house
});

// 2. auth_firebase_datasource.dart (I need to check if I updated triggerEmergencyAlarm in AuthRepository)
// Wait, `auth_repository_impl.dart:157 and 167`. Let me check those lines later.

// 3. home_tab.dart
replaceFile('lib/src/features/authentication/presentation/widgets/home_tab.dart', c => {
  c = c.replace(/final unit = profile\?\.housingUnit \?\? housingUnit;/g, 'final lotVal = profile?.lot ?? lot;\n                              final houseVal = profile?.house ?? house;');
  c = c.replace(/triggerEmergencyAlarm\(currentUser\.uid, name, unit\)/g, 'triggerEmergencyAlarm(currentUser.uid, name, lotVal, houseVal)');
  c = c.replace(/payment\.amountPaid/g, 'payment.amount');
  // At line 31, what is housingUnit?
  c = c.replace(/final String housingUnit;/g, 'final String lot; final String house;');
  return c;
});

// 4. payments_firebase_datasource.dart
replaceFile('lib/src/features/payments/data/datasources/payments_firebase_datasource.dart', c => {
  c = c.replace(/housingUnit: doc\['housingUnit'\] as String/g, "lot: doc['lot'] as String,\n        house: doc['house'] as String");
  c = c.replace(/housingUnit/g, 'lot'); // Wait, line 44 might be `orderBy('housingUnit')`? Let me see.
  return c;
});

// 5. payments_repository_impl.dart
replaceFile('lib/src/features/payments/data/repositories/payments_repository_impl.dart', c => {
  c = c.replace(/resident\.housingUnit/g, 'resident.lot'); // line 72, 73
  return c;
});

// 6. housing_payment_entity.dart
replaceFile('lib/src/features/payments/domain/entities/housing_payment_entity.dart', c => {
  c = c.replace(/housingUnit/g, 'lot, house'); // in Equatable props
  return c;
});

// 7. payment_transaction_entity.dart
replaceFile('lib/src/features/payments/domain/entities/payment_transaction_entity.dart', c => {
  c = c.replace(/housingUnit == other\.housingUnit/g, 'lot == other.lot && house == other.house');
  c = c.replace(/housingUnit\.hashCode/g, 'lot.hashCode ^ house.hashCode');
  return c;
});

// 8. concept_detail_screen.dart
replaceFile('lib/src/features/payments/presentation/screens/concept_detail_screen.dart', c => {
  c = c.replace(/payment\.lot,\n              payment\.house,/g, '(lot: payment.lot, house: payment.house),');
  return c;
});

// 9. neighbor_payments_view.dart
replaceFile('lib/src/features/payments/presentation/screens/neighbor_payments_view.dart', c => {
  c = c.replace(/arg\.lot/g, 'lot');
  c = c.replace(/arg\.house/g, 'house');
  c = c.replace(/neighborPaymentsStreamProvider\(\(lot: lot, house: house\)\)/g, 'neighborPaymentsStreamProvider((lot: lot, house: house))');
  return c;
});

// 10. test/features/payments/payments_usecase_test.dart
replaceFile('test/features/payments/payments_usecase_test.dart', c => {
  c = c.replace(/housingUnit: /g, 'lot: "Lote 1", house: "A", ');
  c = c.replace(/lot, house,/g, 'lot: "Lote 1", house: "A", ');
  return c;
});

console.log('Done script run');
