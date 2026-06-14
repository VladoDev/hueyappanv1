const fs = require('fs');
const path = 'test/features/payments/payments_usecase_test.dart';
if (fs.existsSync(path)) {
  let c = fs.readFileSync(path, 'utf8');
  c = c.replace(/housingUnit/g, 'lot'); // Mostly lot, house has already been added manually or by other scripts. Actually, let's just delete the tests if they are broken, or use a regex to replace.
  c = c.replace(/neighborPaymentsStreamProvider\(\(lot: 'Lote 1', house: 'A'\)\)/g, "neighborPaymentsStreamProvider((lot: 'Lote 1', house: 'A'))");
  // Let's just fix it automatically
}
