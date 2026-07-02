import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/features/contacts/presentation/screens/contacts_tab.dart';
import 'package:hueyappanv1/src/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:hueyappanv1/src/features/contacts/domain/entities/contact_entity.dart';

class FakeFirebaseAnalytics extends Fake implements FirebaseAnalytics {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return Future<void>.value();
  }
}

void main() {
  testWidgets('ContactsTab renders title, filter chips, and search field', (
    WidgetTester tester,
  ) async {
    final testContacts = [
      const ContactEntity(
        id: 1,
        name: 'Caseta Test',
        phoneNumber: '1234567890',
        category: 'Security',
        isFavorite: false,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contactsStreamProvider.overrideWith(
            (ref) => Stream.value(testContacts),
          ),
          analyticsProvider.overrideWithValue(FakeFirebaseAnalytics()),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('es'),
          home: ContactsTab(),
        ),
      ),
    );

    // Initial build and yield microtasks
    await tester.pump();
    await tester.pumpAndSettle();

    // Verify Title translated in Spanish
    expect(find.text('Números de Contacto'), findsOneWidget);

    // Verify Search hint is rendered
    expect(find.byType(TextField), findsOneWidget);

    // Verify contacts list item is rendered
    expect(find.text('Caseta Test'), findsOneWidget);

    // Verify localized category badge is shown twice: in the filter chip and in the contact badge
    expect(find.text('Seguridad'), findsNWidgets(2));
  });
}
