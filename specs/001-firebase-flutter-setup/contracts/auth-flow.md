# Interface Contracts: Initial App Setup and Authentication Baseline

## UI & Application Route Contracts

We use `go_router` for route definition. Route navigation must check authentication states reactively.

### 1. Route Definitions
All routes are declared under the global GoRouter configuration:

- `/login`
  - **Access**: Public (Unauthenticated)
  - **View**: `LoginScreen`
  - **Redirect behavior**: If user is already authenticated, redirect to `/` (home).
- `/` (Shell Route)
  - **Access**: Protected (Authenticated)
  - **View**: `MainShellScreen` (Hosts bottom navigation)
  - **Sub-routes**:
    - `/home` (Default tab)
    - `/announcements`
    - `/payments`
    - `/profile`
  - **Redirect behavior**: If user is not authenticated, redirect to `/login`.

---

## Service Layer Contracts

We define abstract contracts (interfaces) for the authentication services in the Domain layer to decouple presentation from implementation.

### 1. `AuthRepository` Interface
File: `lib/src/features/authentication/domain/repositories/auth_repository.dart`

```dart
abstract class AuthRepository {
  /// Stream that emits the current user status.
  Stream<ResidentEntity?> get authStateChanges;

  /// Sign in user with email and password.
  Future<ResidentEntity> loginWithEmail({
    required String email,
    required String password,
  });

  /// Signs out the current authenticated user and flags local FCM token as inactive.
  Future<void> signOut();

  /// Updates or registers the active FCM token in the user's document for notifications.
  Future<void> registerDeviceToken({
    required String token,
    required String platform,
  });
}
```
