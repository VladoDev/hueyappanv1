import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../datasources/contacts_firebase_datasource.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsFirebaseDatasource _datasource;

  ContactsRepositoryImpl(this._datasource);

  @override
  Stream<List<ContactEntity>> watchContacts({
    String? query,
    String? categoryFilter,
    bool favoritesOnly = false,
  }) {
    return _datasource.getContactsStream().map((contacts) {
      var filtered = contacts;

      if (favoritesOnly) {
        filtered = filtered.where((c) => c.isFavorite).toList();
      }

      if (categoryFilter != null && categoryFilter.isNotEmpty) {
        filtered = filtered
            .where((c) => c.category.toLowerCase() == categoryFilter.toLowerCase())
            .toList();
      }

      if (query != null && query.trim().isNotEmpty) {
        final term = query.trim().toLowerCase();
        filtered = filtered.where((c) {
          return c.name.toLowerCase().contains(term) ||
              c.phoneNumber.toLowerCase().contains(term) ||
              c.category.toLowerCase().contains(term);
        }).toList();
      }

      // Sort favorites first, then alphabetically
      filtered.sort((a, b) {
        if (a.isFavorite && !b.isFavorite) return -1;
        if (!a.isFavorite && b.isFavorite) return 1;
        return a.name.compareTo(b.name);
      });

      return filtered;
    });
  }

  @override
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    await _datasource.toggleFavorite(id, isFavorite);
  }

  @override
  Future<void> addContact(ContactEntity contact) async {
    await _datasource.addContact(contact);
  }
}
