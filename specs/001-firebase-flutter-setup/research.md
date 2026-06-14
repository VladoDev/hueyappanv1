# Research & Technical Decisions: Initial App Setup and Authentication Baseline

## Phase 0: Outline & Research Findings

### 1. Firebase Authentication: Email/Password flow
- **Decision**: Use standard email/password authentication via `firebase_auth`.
- **Rationale**: Direct, secure, and easily integrated with Riverpod.
- **Alternatives Considered**: 
  - OAuth2/Google Sign-In: Rejected for initial release since residents must be pre-registered by the admin using specific neighborhood emails.
  - Phone-based OTP: Rejected due to SMS carrier costs, email is sufficient for v1.

### 2. Association of FCM Tokens for Critical Notifications
- **Decision**: Design a secure token registration mechanism within Cloud Firestore during the authentication lifecycle.
- **Rationale**: Critical notifications require targeted delivery to specific users. By storing FCM tokens mapped to the authenticated user's ID, the backend can target specific devices.
- **Implementation Strategy**:
  - Store tokens under `/residents/{uid}/devices/{token_id}`.
  - Attributes per device token document:
    ```json
    {
      "token": "fcm_registration_token_here",
      "platform": "ios" | "android",
      "updatedAt": "timestamp",
      "isActive": true
    }
    ```
  - **Lifecycle triggers**:
    - **On Login**: Request notification permissions, fetch FCM token, and upsert token into Firestore under the user's document.
    - **On Logout**: Set `isActive: false` or delete the specific device token document to prevent sending notifications to logged-out devices.
    - **On Token Refresh**: Listen to `FirebaseMessaging.instance.onTokenRefresh` and update the active token in Firestore.

### 3. Preparation for iOS Critical Alerts
- **Decision**: Configure standard notification request parameters to request `criticalAlert: true` and `provisional: false` on iOS.
- **Rationale**: Critical alerts bypass the user's Do Not Disturb and Mute settings, which is essential for community emergencies (e.g., security alarms). iOS requires the user's explicit permission for critical alerts, which must be requested alongside standard notification permissions.
- **Implementation Details**:
  - Request permission using:
    ```dart
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true, // Crucial for next feature
    );
    ```
  - Ensure Apple Developer Portal has the "Critical Alerts" entitlement enabled (which will be configured during the next phase).

---

## Technical Unknowns and Resolutions

### Question 1: Firebase Project Configuration
- **Unknown**: How will Firebase configuration (GoogleServices-Info.plist and google-services.json) be managed?
- **Resolution**: We will provide the standard Firebase setup in `main.dart` with support for `DefaultFirebaseOptions`. The user will run the FlutterFire CLI command (`flutterfire configure`) locally to link their specific Firebase project and generate `firebase_options.dart`.

### Question 2: Local Cache & Offline State
- **Unknown**: How to handle resident authentication checks while offline?
- **Resolution**: Firebase Auth caches credentials locally automatically. We will check the cached current user state upon launch to enable immediate offline landing on the Dashboard shell, syncing credentials once connection is re-established.
