import '../repositories/contacts_repository.dart';

class ToggleFavoriteUseCase {
  final ContactsRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<void> execute(String id, bool isFavorite) {
    if (id.trim().isEmpty) {
      throw ArgumentError('Invalid contact ID.');
    }
    return _repository.toggleFavorite(id, isFavorite);
  }
}
