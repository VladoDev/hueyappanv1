import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../features/authentication/presentation/providers/auth_provider.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/main_shell_screen.dart';
import '../../features/authentication/presentation/widgets/home_tab.dart';
import '../../features/authentication/presentation/widgets/announcements_tab.dart';
import '../../features/payments/presentation/screens/payments_tab_screen.dart';
import '../../features/payments/presentation/screens/concept_form_screen.dart';
import '../../features/payments/presentation/screens/concept_detail_screen.dart';
import '../../features/payments/presentation/screens/concept_payment_map_screen.dart';
import '../../features/authentication/presentation/widgets/profile_tab.dart';
import '../../features/contacts/presentation/screens/contacts_tab.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  final firebaseUserAsync = ref.watch(firebaseUserProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges),
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    redirect: (context, state) {
      final firebaseUser = firebaseUserAsync.value;
      final user = authState.value;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      // 1. If Firebase Auth is still loading and we have no user, wait.
      if (firebaseUserAsync.isLoading && firebaseUser == null) {
        return null;
      }

      // 2. If Firebase Auth user is null, we are definitely logged out. Redirect to login.
      if (firebaseUser == null) {
        return (isLoggingIn || isRegistering) ? null : '/login';
      }

      // 3. If Firebase user is logged in but profile is still loading and we have no value, wait.
      if (authState.isLoading && user == null) {
        return null;
      }

      // 4. If Firebase user is logged in but profile is missing (e.g. half-registered), redirect to register.
      if (user == null) {
        return isRegistering ? null : '/register';
      }

      // 5. If fully logged in, redirect away from auth screens.
      if (isLoggingIn || isRegistering) {
        return '/home';
      }

      return null; // Allow navigation to the requested route
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => Consumer(
                  builder: (context, ref, child) {
                    final user = ref.watch(authStateProvider).value;
                    if (user == null) return const SizedBox.shrink();
                    return HomeTab(residentName: user.name, lot: user.lot, house: user.house);
                  },
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/announcements',
                builder: (context, state) => const AnnouncementsTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/payments',
                builder: (context, state) => const PaymentsTabScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const ConceptFormScreen(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ConceptFormScreen(conceptId: id);
                    },
                  ),
                  GoRoute(
                    path: 'detail/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ConceptDetailScreen(conceptId: id);
                    },
                  ),
                  GoRoute(
                    path: 'map/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ConceptPaymentMapScreen(conceptId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/contacts',
                builder: (context, state) => const ContactsTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => Consumer(
                  builder: (context, ref, child) {
                    final user = ref.watch(authStateProvider).value;
                    if (user == null) return const SizedBox.shrink();
                    return ProfileTab(
                      name: user.name,
                      email: user.email,
                      lot: user.lot,
                      house: user.house,
                      status: user.accountStatus,
                      role: user.role,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
});

