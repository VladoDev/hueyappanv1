const fs = require('fs');

function replaceFile(path, replacer) {
  if (!fs.existsSync(path)) return;
  const content = fs.readFileSync(path, 'utf8');
  const newContent = replacer(content);
  if (content !== newContent) {
    fs.writeFileSync(path, newContent);
  }
}

// 1. home_tab.dart
replaceFile('lib/src/features/authentication/presentation/widgets/home_tab.dart', c => {
  c = c.replace(/neighborTransactionsStreamProvider\(housingUnit\)/g, 'neighborTransactionsStreamProvider((lot: lot, house: house))');
  c = c.replace(/triggerEmergencyAlarm\(currentUser\.uid, name, lotVal, houseVal\)/g, 'triggerEmergencyAlarm(currentUser.uid, name, lotVal, houseVal)'); // Wait, auth_repository_impl triggerEmergencyAlarm expects 4 args, but home_tab might pass 4 args to authFirebaseDatasourceProvider... wait, home_tab.dart calls `datasource.triggerEmergencyAlarm(currentUser.uid, name, lotVal, houseVal)`. Wait! The error was "Too many positional arguments: 3 expected, but 4 found". This means `triggerEmergencyAlarm` in `auth_firebase_datasource.dart` only expects 3 arguments!
  return c;
});

console.log('Done script run 2');
