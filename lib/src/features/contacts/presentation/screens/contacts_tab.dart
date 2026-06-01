import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../providers/contacts_provider.dart';
import '../widgets/contact_list_item.dart';

class ContactsTab extends ConsumerStatefulWidget {
  const ContactsTab({super.key});

  @override
  ConsumerState<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends ConsumerState<ContactsTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(analyticsProvider).logScreenView(screenName: 'ContactsTab');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(contactsFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.contactsTitle,
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: VecinalSpacing.xl),
          child: Column(
            children: [
              _buildSearchBar(vc, l10n),
              const SizedBox(height: VecinalSpacing.md),
              _buildFilterChips(filter, vc, l10n),
              const SizedBox(height: VecinalSpacing.md),
              Expanded(child: _buildContactsList(vc, l10n)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(VecinalSemanticColors vc, AppLocalizations l10n) {
    return TextField(
      controller: _searchController,
      onChanged: (val) => ref.read(contactsFilterProvider.notifier).setSearchQuery(val),
      style: VecinalTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: l10n.searchContacts,
        hintStyle: VecinalTextStyles.bodyMedium.copyWith(color: vc.textHint),
        prefixIcon: Icon(Icons.search, color: vc.textHint),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: vc.textHint),
                onPressed: () {
                  _searchController.clear();
                  ref.read(contactsFilterProvider.notifier).setSearchQuery('');
                },
              )
            : null,
        filled: true,
        fillColor: vc.surfaceSecondary,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: VecinalSpacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.lg),
          borderSide: BorderSide(color: vc.borderDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.lg),
          borderSide: BorderSide(color: vc.borderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.lg),
          borderSide: BorderSide(color: vc.primaryDefault, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildFilterChips(
    ContactsFilterState filter,
    VecinalSemanticColors vc,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildChip(
            label: l10n.allContacts,
            selected: filter.categoryFilter == null && !filter.favoritesOnly,
            onSelected: (_) {
              ref.read(contactsFilterProvider.notifier).setCategoryFilter(null);
            },
            vc: vc,
          ),
          _buildChip(
            label: l10n.favoritesOnly,
            selected: filter.favoritesOnly,
            onSelected: (_) {
              ref.read(contactsFilterProvider.notifier).setFavoritesOnly(true);
            },
            vc: vc,
          ),
          ...['security', 'admin', 'emergency', 'services'].map((cat) {
            final isSel = filter.categoryFilter?.toLowerCase() == cat.toLowerCase();
            return _buildChip(
              label: _getLocalizedCategoryName(l10n, cat),
              selected: isSel,
              onSelected: (_) {
                ref.read(contactsFilterProvider.notifier).setCategoryFilter(cat);
              },
              vc: vc,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
    required VecinalSemanticColors vc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: VecinalSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        labelStyle: VecinalTextStyles.labelSmall.copyWith(
          color: selected ? vc.textOnPrimary : vc.textSecondary,
          fontWeight: FontWeight.bold,
        ),
        selectedColor: vc.primaryDefault,
        checkmarkColor: vc.textOnPrimary,
        backgroundColor: vc.surfaceSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VecinalRadius.md),
          side: BorderSide(color: selected ? vc.primaryDefault : vc.borderDefault),
        ),
      ),
    );
  }

  Widget _buildContactsList(VecinalSemanticColors vc, AppLocalizations l10n) {
    final contactsAsync = ref.watch(contactsStreamProvider);

    return contactsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (contacts) {
        if (contacts.isEmpty) {
          return Center(
            child: Text(
              l10n.noContactsFound,
              style: VecinalTextStyles.bodyMedium.copyWith(color: vc.textHint),
            ),
          );
        }
        return ListView.builder(
          itemCount: contacts.length,
          padding: const EdgeInsets.only(bottom: 100),
          itemBuilder: (context, index) {
            return ContactListItem(contact: contacts[index]);
          },
        );
      },
    );
  }

  String _getLocalizedCategoryName(AppLocalizations l10n, String category) {
    switch (category.toLowerCase()) {
      case 'security':
        return l10n.securityCategory;
      case 'admin':
        return l10n.adminCategory;
      case 'services':
        return l10n.servicesCategory;
      case 'emergency':
        return l10n.emergencyCategory;
      default:
        return category;
    }
  }
}
