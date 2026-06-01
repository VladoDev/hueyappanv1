import 'package:flutter_test/flutter_test.dart';
import 'package:hueyappanv1/src/features/contacts/domain/entities/contact_entity.dart';
import 'package:hueyappanv1/src/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:hueyappanv1/src/features/contacts/domain/usecases/toggle_favorite_usecase.dart';
import 'package:hueyappanv1/src/features/contacts/domain/usecases/watch_contacts_usecase.dart';

class MockContactsRepository implements ContactsRepository {
  final List<ContactEntity> _contacts = [
    const ContactEntity(
      id: 1,
      name: 'Caseta de Vigilancia',
      phoneNumber: '+527351234567',
      category: 'Security',
      isFavorite: false,
    ),
    const ContactEntity(
      id: 2,
      name: 'Administración',
      phoneNumber: '+527357654321',
      category: 'Admin',
      isFavorite: true,
    ),
  ];

  @override
  Stream<List<ContactEntity>> watchContacts({
    String? query,
    String? categoryFilter,
    bool favoritesOnly = false,
  }) {
    Iterable<ContactEntity> filtered = _contacts;
    if (favoritesOnly) {
      filtered = filtered.where((c) => c.isFavorite);
    }
    if (categoryFilter != null) {
      filtered = filtered.where((c) => c.category.toLowerCase() == categoryFilter.toLowerCase());
    }
    if (query != null && query.isNotEmpty) {
      filtered = filtered.where((c) => c.name.toLowerCase().contains(query.toLowerCase()));
    }
    return Stream.value(filtered.toList());
  }

  @override
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    // Mock implementation doesn't need to write to DB
  }
}

void main() {
  group('Contacts UseCases Unit Tests', () {
    late MockContactsRepository repository;
    late WatchContactsUseCase watchUseCase;
    late ToggleFavoriteUseCase toggleUseCase;

    setUp(() {
      repository = MockContactsRepository();
      watchUseCase = WatchContactsUseCase(repository);
      toggleUseCase = ToggleFavoriteUseCase(repository);
    });

    test('watchContacts executes and streams favorites', () async {
      final list = await watchUseCase.execute(favoritesOnly: true).first;
      expect(list.length, 1);
      expect(list.first.name, 'Administración');
    });

    test('watchContacts filters by category', () async {
      final list = await watchUseCase.execute(categoryFilter: 'Security').first;
      expect(list.length, 1);
      expect(list.first.name, 'Caseta de Vigilancia');
    });

    test('toggleFavorite validation throws on invalid ID', () {
      expect(() => toggleUseCase.execute(-1, true), throwsArgumentError);
    });
  });
}
