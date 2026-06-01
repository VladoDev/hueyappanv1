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
import '../../features/authentication/presentation/widgets/payments_tab.dart';
import '../../features/authentication/presentation/widgets/profile_tab.dart';
import '../../features/contacts/presentation/screens/contacts_tab.dart';

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
      if (authState.isLoading || 
          authState.hasError || 
          firebaseUserAsync.isLoading || 
          firebaseUserAsync.hasError) {
        return null; // Wait until initial load is complete
      }

      final user = authState.value;
      final firebaseUser = firebaseUserAsync.value;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      // Check if logged in to Firebase Auth but profile is missing in Firestore
      final hasAuthUser = firebaseUser != null;

      if (hasAuthUser && user == null) {
        // Half-registered state: redirect to register screen
        return isRegistering ? null : '/register';
      }

      if (user == null) {
        // Not logged in: allow login or register screen, redirect to login otherwise
        return (isLoggingIn || isRegistering) ? null : '/login';
      }

      // Logged in: redirect to dashboard if trying to go to login or register screen
      if (isLoggingIn || isRegistering) {
        return '/home';
      }

      return null; // Let the router navigate to the requested page
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
                    return HomeTab(residentName: user.name, housingUnit: user.housingUnit);
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
                builder: (context, state) => const PaymentsTab(),
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
                      housingUnit: user.housingUnit,
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
    ],
  );
});

