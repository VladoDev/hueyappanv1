# HueyAPPan - Configuración de Flavors (Entornos)

Este proyecto está configurado con dos entornos (flavors) a nivel nativo (Android/iOS) y a nivel Dart, lo que permite separar completamente el entorno de Desarrollo del entorno de Producción, incluyendo los proyectos de Firebase.

## Entornos Disponibles

1. **Development (`development`)**
   - **Application ID / Bundle ID:** `com.conventohueyapan.hueyappanv1`
   - **Firebase Project ID:** `hueyappanv1`
   - **Nombre de la App:** HueyAPPan Dev
   - **Entry point Dart:** `lib/main_development.dart`

2. **Production (`production`)**
   - **Application ID / Bundle ID:** `com.vlad.hueyappan`
   - **Firebase Project ID:** `hueyappan-prod`
   - **Nombre de la App:** Hueyappan
   - **Entry point Dart:** `lib/main_production.dart`

---

## Comandos para Ejecutar (Run)

Para correr la aplicación en un dispositivo o emulador, debes especificar el *flavor* y el *target* de Dart.

**Ejecutar Desarrollo:**
```bash
flutter run -t lib/main_development.dart --flavor development
```

**Ejecutar Producción:**
```bash
flutter run -t lib/main_production.dart --flavor production
```

---

## Comandos para Compilar (Build)

### Android (APK y AppBundle)

**Construir APK de Desarrollo:**
```bash
flutter build apk -t lib/main_development.dart --flavor development
```

**Construir APK de Producción:**
```bash
flutter build apk -t lib/main_production.dart --flavor production
```

**Construir AppBundle (AAB) para Google Play (Solo Producción):**
```bash
flutter build appbundle -t lib/main_production.dart --flavor production
```

### iOS (IPA)

*Nota: Requiere una Mac con Xcode instalado y certificados de desarrollador configurados.*

**Construir iOS para Desarrollo:**
```bash
flutter build ipa -t lib/main_development.dart --flavor development
```

**Construir iOS para Producción:**
```bash
flutter build ipa -t lib/main_production.dart --flavor production
```

---

## Configuración Técnica (Para Referencia)

- **Android:** Utiliza carpetas específicas en `android/app/src/development` y `android/app/src/production` para colocar el archivo `google-services.json` respectivo. El `applicationId` y `resValue` se declaran en `android/app/build.gradle.kts`.
- **iOS:** Utiliza un *Run Script* en `ios/Runner.xcodeproj` ("Select GoogleService-Info.plist") que detecta la configuración activa (`*-development` vs `*-production`) y copia dinámicamente el `GoogleService-Info.plist` correcto desde las carpetas `ios/Runner/Firebase/Development` o `ios/Runner/Firebase/Production`.
- **Dart:** Se generaron dos archivos vía `flutterfire configure`: `firebase_options_development.dart` y `firebase_options_production.dart`. Cada `main_*.dart` respectivo inicializa Firebase pasando las credenciales correspondientes al flavor.
