import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/providers/auth_provider.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/main_shell_screen.dart';

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
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainShellScreen(initialIndex: 0),
      ),
      GoRoute(
        path: '/announcements',
        builder: (context, state) => const MainShellScreen(initialIndex: 1),
      ),
      GoRoute(
        path: '/payments',
        builder: (context, state) => const MainShellScreen(initialIndex: 2),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const MainShellScreen(initialIndex: 3),
      ),
    ],
  );
});

