# Implementation Plan: Initial App Setup and Authentication Baseline

**Branch**: `001-firebase-flutter-setup` | **Date**: 2026-05-29 | **Spec**: [specs/001-firebase-flutter-setup/spec.md](spec.md)

**Input**: Feature specification from `specs/001-firebase-flutter-setup/spec.md`

## Summary
Implement a secure authentication entry point using email and password with Firebase Authentication. Establish the foundational app shell and navigation framework using GoRouter and Riverpod, ensuring the architecture is prepared for the upcoming critical notifications feature by associating the user's FCM token with their Firestore Resident Profile during sign-in.

## Technical Context

**Language/Version**: Dart 3.11.0 / Flutter 3.41.0

**Primary Dependencies**: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_messaging`, `flutter_riverpod`, `go_router`, `freezed_annotation`

**Storage**: Cloud Firestore (for storing Resident Profile metadata and FCM device tokens)

**Testing**: `flutter_test` (Unit tests for Auth controllers/usecases and Widget tests for screen states)

**Target Platform**: Android (Min SDK 21) & iOS (Min iOS 13.0)

**Project Type**: Mobile App (Single Project codebase)

**Performance Goals**: App launch time < 3s, Auth feedback response < 2s

**Constraints**: Clean Architecture file size/length metrics, offline detection, secure credentials storage

**Scale/Scope**: ~100 initial resident accounts, single private neighborhood application

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate / Rule | Check status | Notes / Compliance Strategy |
| :--- | :--- | :--- |
| **Idioma Oficial** | Pass | All source code, commits, and comments will be written strictly in English. |
| **Clean Architecture** | Pass | Feature structured under `lib/src/features/authentication/` into `data/`, `domain/`, and `presentation/`. |
| **Riverpod State Management** | Pass | State will be managed using Riverpod Providers. No global singletons or `setState` for shared states. |
| **Code Length Metrics** | Pass | Logic functions <= 20 lines, widget build() <= 100 lines, files <= 300 lines. |
| **Git Branching** | Pass | Branch correctly named `001-firebase-flutter-setup`. |
| **Testing Coverage** | Pass | Unit tests for domain logic and widget tests for the authentication flows. |
| **i18n Localization** | Pass | Configure ARB localized resources for `en`, `es`, `pt`, `fr`, and `it` under `lib/l10n`. |

## Project Structure

### Documentation (this feature)

```text
specs/001-firebase-flutter-setup/
├── spec.md              # Feature specification
├── plan.md              # This implementation plan
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 data modeling
├── quickstart.md        # Setup guide & scripts
└── checklists/
    └── requirements.md  # Quality checklist
```

### Source Code (repository root)

```text
lib/
├── l10n/
│   ├── app_en.arb
│   ├── app_es.arb
│   ├── app_fr.arb
│   ├── app_it.arb
│   └── app_pt.arb
├── main.dart
└── src/
    ├── app.dart
    ├── core/
    │   ├── theme/
    │   └── router/
    └── features/
        └── authentication/
            ├── data/
            │   ├── datasources/
            │   │   └── auth_firebase_datasource.dart
            │   ├── models/
            │   │   └── resident_model.dart
            │   └── repositories/
            │       └── auth_repository_impl.dart
            ├── domain/
            │   ├── entities/
            │   │   └── resident_entity.dart
            │   ├── repositories/
            │   │   └── auth_repository.dart
            │   └── usecases/
            │       └── login_with_email_usecase.dart
            └── presentation/
                ├── providers/
                │   └── auth_provider.dart
                ├── screens/
                │   ├── login_screen.dart
                │   └── main_shell_screen.dart
                └── widgets/
                    └── custom_text_field.dart
```

**Structure Decision**: Single Flutter project structure targeting Android and iOS, organized using features-based clean architecture layout under `lib/src/features/`.

## Complexity Tracking

*No violations detected or justified.*
