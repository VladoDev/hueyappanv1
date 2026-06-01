import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../data/datasources/contacts_database.dart';
import '../../data/repositories/contacts_repository_impl.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/watch_contacts_usecase.dart';

class ContactsFilterState {
  final String searchQuery;
  final String? categoryFilter;
  final bool favoritesOnly;

  const ContactsFilterState({
    this.searchQuery = '',
    this.categoryFilter,
    this.favoritesOnly = false,
  });

  ContactsFilterState copyWith({
    String? searchQuery,
    String? categoryFilter,
    bool clearCategoryFilter = false,
    bool? favoritesOnly,
  }) {
    return ContactsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryFilter: clearCategoryFilter ? null : (categoryFilter ?? this.categoryFilter),
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    );
  }
}

final analyticsProvider = Provider<FirebaseAnalytics>((ref) => FirebaseAnalytics.instance);

final contactsDatabaseProvider = Provider<ContactsDatabase>((ref) {
  final db = ContactsDatabase();
  ref.onDispose(() {
    db.close();
  });
  return db;
});

final contactsRepositoryProvider = Provider<ContactsRepository>((ref) {
  return ContactsRepositoryImpl(ref.watch(contactsDatabaseProvider));
});

final watchContactsUseCaseProvider = Provider<WatchContactsUseCase>((ref) {
  return WatchContactsUseCase(ref.watch(contactsRepositoryProvider));
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>((ref) {
  return ToggleFavoriteUseCase(ref.watch(contactsRepositoryProvider));
});

class ContactsFilterNotifier extends Notifier<ContactsFilterState> {
  @override
  ContactsFilterState build() => const ContactsFilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategoryFilter(String? category) {
    if (category == null) {
      state = state.copyWith(clearCategoryFilter: true);
    } else {
      state = state.copyWith(categoryFilter: category, favoritesOnly: false);
    }
  }

  void setFavoritesOnly(bool favoritesOnly) {
    if (favoritesOnly) {
      state = state.copyWith(favoritesOnly: true, clearCategoryFilter: true);
    } else {
      state = state.copyWith(favoritesOnly: false);
    }
  }
}

final contactsFilterProvider = NotifierProvider<ContactsFilterNotifier, ContactsFilterState>(
  ContactsFilterNotifier.new,
);

final contactsStreamProvider = StreamProvider<List<ContactEntity>>((ref) {
  final filter = ref.watch(contactsFilterProvider);
  final useCase = ref.watch(watchContactsUseCaseProvider);
  return useCase.execute(
    query: filter.searchQuery,
    categoryFilter: filter.categoryFilter,
    favoritesOnly: filter.favoritesOnly,
  );
});
