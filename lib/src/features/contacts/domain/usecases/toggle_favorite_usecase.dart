import '../repositories/contacts_repository.dart';

class ToggleFavoriteUseCase {
  final ContactsRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<void> execute(int id, bool isFavorite) {
    if (id <= 0) {
      throw ArgumentError('Invalid contact ID.');
    }
    return _repository.toggleFavorite(id, isFavorite);
  }
}
