import '../entities/contact_entity.dart';

abstract class ContactsRepository {
  Stream<List<ContactEntity>> watchContacts({
    String? query,
    String? categoryFilter,
    bool favoritesOnly = false,
  });

  Future<void> toggleFavorite(int id, bool isFavorite);
}
