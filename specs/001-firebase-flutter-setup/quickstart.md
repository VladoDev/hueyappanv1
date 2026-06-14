# Quickstart Guide: Initial App Setup and Authentication Baseline

## Firebase Integration Setup

To connect this Flutter project to your specific Firebase instance:

1. **Install Firebase CLI**: Ensure the Firebase CLI is installed globally.
   ```bash
   npm install -g firebase-tools
   firebase login
   ```
2. **Install FlutterFire CLI**:
   ```bash
   dart pub global activate flutterfire_cli
   ```
3. **Configure Project**: Run the configure tool inside the `hueyappanv1` directory:
   ```bash
   flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
   ```
   This will automatically generate `lib/firebase_options.dart` and register your iOS/Android configurations.

---

## Code Generation

This project uses `freezed` and `json_serializable` for data modeling. Whenever you create or modify model entities, run the code generator:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Running Verification

Ensure the test suite compiles and runs properly:

```bash
flutter test
```
