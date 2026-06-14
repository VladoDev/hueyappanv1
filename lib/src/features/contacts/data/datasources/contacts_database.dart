import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'contacts_database.g.dart';

@DataClassName('Contact')
class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get category => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Contacts])
class ContactsDatabase extends _$ContactsDatabase {
  ContactsDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        await batch((b) {
          b.insertAll(contacts, [
            ContactsCompanion.insert(name: 'Caseta de Vigilancia', phoneNumber: '+527351234567', category: 'Security'),
            ContactsCompanion.insert(name: 'Administración', phoneNumber: '+527357654321', category: 'Admin'),
            ContactsCompanion.insert(name: 'Mantenimiento General', phoneNumber: '+527359876543', category: 'Services'),
            ContactsCompanion.insert(name: 'Bomberos Hueyapan', phoneNumber: '+527353520055', category: 'Emergency'),
            ContactsCompanion.insert(name: 'Cruz Roja', phoneNumber: '+527353521212', category: 'Emergency'),
            ContactsCompanion.insert(name: 'Policía Municipal', phoneNumber: '+527353520110', category: 'Emergency'),
            ContactsCompanion.insert(name: 'Suministro de Agua (Pipas)', phoneNumber: '+527351112222', category: 'Services'),
            ContactsCompanion.insert(name: 'Gas LP Convento', phoneNumber: '+527353334444', category: 'Services'),
          ]);
        });
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'contacts.db'));
    return NativeDatabase.createInBackground(file);
  });
}
