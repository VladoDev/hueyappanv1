# HueyAPPan - Technical Stack
## Especificación Tecnológica y Arquitectura de Infraestructura

### 1. Resumen Ejecutivo del Stack Técnico
La infraestructura tecnológica de **HueyAPPan** ha sido seleccionada meticulosamente para ofrecer un rendimiento óptimo en dispositivos móviles, una arquitectura desacoplada basada en la nube y un flujo de desarrollo moderno enfocado en la inmutabilidad y la reactividad. La combinación de **Flutter** en el cliente y **Firebase** en el backend minimiza el tiempo de comercialización y los costos operativos mientras maximiza la seguridad de los datos vecinales.

### 2. Frontend y Ecosistema Mobile
#### Framework Principal
* **Flutter (Dart):** Framework multiplataforma elegido para compilar de manera nativa aplicaciones de alto rendimiento para iOS y Android desde una única base de código, garantizando una UI fluida y consistente para todos los vecinos.

#### Librerías Core de Desarrollo
| Tecnología / Paquete | Categoría | Propósito y Aplicación en HueyAPPan |
| :--- | :--- | :--- |
| `riverpod` | State Management / DI | Manejo del estado reactivo global de la app e inyección de dependencias limpia sin acoplamiento al contexto de Flutter. |
| `go_router` | Routing & Navigation | Enrutador declarativo oficial basado en la API Navigator 2.0. Facilita la navegación profunda (deep linking) y el manejo de rutas protegidas por autenticación. |
| `freezed` | Code Generation | Generador de código para modelado de datos inmutables, uniones (unions/sealed classes) y métodos de clonación (copyWith), garantizando seguridad en tiempo de compilación. |
| `flutter_localizations` | Internationalization | Paquete del SDK de Flutter encargado de proveer soporte nativo para la traducción y adaptación cultural del sistema en los 5 idiomas requeridos. |

### 3. Backend y Servicios Cloud (Ecosistema Firebase)
El backend de la aplicación estará completamente soportado por la infraestructura serverless de **Firebase**, utilizando los siguientes módulos específicos:
* **Firebase Authentication:** Gestión de identidades totalmente segura para los residentes de la privada. Soportará inicialmente inicio de sesión mediante correo/contraseña con flujos de verificación estrictos para asegurar que solo los residentes autorizados tengan acceso.
* **Cloud Firestore:** Base de datos orientada a documentos (NoSQL) con sincronización en tiempo real. Se utilizará para almacenar los datos dinámicos de la privada: avisos de la administración, reportes de mantenimiento, reserva de áreas comunes y estados de cuenta vecinales.
* **Firebase Cloud Messaging (FCM):** Servicio de notificaciones push de alta fiabilidad. Crucial para emitir alertas inmediatas de seguridad, recordatorios de asambleas vecinales o avisos urgentes emitidos por la administración de la privada.

### 4. Calidad, Automatización y DevOps
#### Análisis Estático y Estilo
* **flutter_lints:** Reglas oficiales de análisis de código de Flutter. Forzará buenas prácticas de programación en Dart, consistencia de diseño estructural y la detección temprana de posibles bugs (como variables sin usar o tipos incorrectos).

#### Integración Continua (CI/CD)
* **GitHub Actions:** Plataforma de automatización donde se configurará un pipeline de Integración Continua (Pipeline CI). En cada Pull Request a las ramas de control, este servicio levantará un entorno virtualizado, instalará las dependencias, ejecutará el linter y correrá de forma mandatoria la suite de Unit y Widget Testing. La aprobación del pipeline será un prerrequisito de fusión.

### 5. Ejemplo de Estructura de Proyecto Esperada
De acuerdo con el Constitution File y el Tech Stack elegidos, la organización de archivos para una característica cualquiera (ej. `authentication`) dentro del directorio `lib/src/features/` debe verse reflejada de la siguiente manera:

```text
authentication/
├── data/
│   ├── datasources/
│   │   └── auth_firebase_datasource.dart
│   ├── models/
│   │   └── user_model.dart (Generado con Freezed)
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── user_entity.dart
│   ├── repositories/
│   │   └── auth_repository.dart (Interfaz abstracta)
│   └── usecases/
│       └── login_with_email_usecase.dart
└── presentation/
    ├── providers/
    │   └── auth_provider.dart (Riverpod Notifier)
    ├── screens/
    │   └── login_screen.dart
    └── widgets/
        └── custom_text_field.dart