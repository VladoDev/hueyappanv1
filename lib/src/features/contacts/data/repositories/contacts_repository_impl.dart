import 'package:drift/drift.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../datasources/contacts_database.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsDatabase _db;

  ContactsRepositoryImpl(this._db);

  @override
  Stream<List<ContactEntity>> watchContacts({
    String? query,
    String? categoryFilter,
    bool favoritesOnly = false,
  }) {
    final selectQuery = _db.select(_db.contacts);
    _applyFilters(selectQuery, query, categoryFilter, favoritesOnly);
    _applySorting(selectQuery);

    return selectQuery.watch().map(_mapListToEntities);
  }

  void _applyFilters(
    SimpleSelectStatement<$ContactsTable, Contact> statement,
    String? query,
    String? categoryFilter,
    bool favoritesOnly,
  ) {
    statement.where((tbl) {
      final expressions = <Expression<bool>>[];

      if (favoritesOnly) {
        expressions.add(tbl.isFavorite.equals(true));
      }

      if (categoryFilter != null && categoryFilter.isNotEmpty) {
        expressions.add(tbl.category.lower().equals(categoryFilter.toLowerCase()));
      }

      if (query != null && query.trim().isNotEmpty) {
        final term = '%${query.trim().toLowerCase()}%';
        expressions.add(
          tbl.name.lower().like(term) |
          tbl.phoneNumber.lower().like(term) |
          tbl.category.lower().like(term),
        );
      }

      if (expressions.isEmpty) {
        return const Constant(true);
      }

      return expressions.reduce((value, element) => value & element);
    });
  }

  void _applySorting(SimpleSelectStatement<$ContactsTable, Contact> statement) {
    statement.orderBy([
      (tbl) => OrderingTerm(expression: tbl.isFavorite, mode: OrderingMode.desc),
      (tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc),
    ]);
  }

  List<ContactEntity> _mapListToEntities(List<Contact> contacts) {
    return contacts.map(_mapToEntity).toList();
  }

  @override
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await (_db.update(_db.contacts)..where((tbl) => tbl.id.equals(id))).write(
      ContactsCompanion(isFavorite: Value(isFavorite)),
    );
  }

  ContactEntity _mapToEntity(Contact contact) {
    return ContactEntity(
      id: contact.id,
      name: contact.name,
      phoneNumber: contact.phoneNumber,
      category: contact.category,
      isFavorite: contact.isFavorite,
    );
  }
}
