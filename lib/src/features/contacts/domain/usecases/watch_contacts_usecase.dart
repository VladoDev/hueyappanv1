import '../entities/contact_entity.dart';
import '../repositories/contacts_repository.dart';

class WatchContactsUseCase {
  final ContactsRepository _repository;

  WatchContactsUseCase(this._repository);

  Stream<List<ContactEntity>> execute({
    String? query,
    String? categoryFilter,
    bool favoritesOnly = false,
  }) {
    return _repository.watchContacts(
      query: query,
      categoryFilter: categoryFilter,
      favoritesOnly: favoritesOnly,
    );
  }
}
