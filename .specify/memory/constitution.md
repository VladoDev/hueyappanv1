# HueyAPPan - Constitution File
## Reglamento Interno de Desarrollo y Estructura del Proyecto

### 1. Introducción y Propósito
El presente documento establece las normas constitutivas, lineamientos de diseño de software y políticas de gobernanza de código para el desarrollo de **HueyAPPan**. Esta aplicación está diseñada de forma exclusiva para optimizar la comunicación, gestión y convivencia de los vecinos de la privada *Convento Hueyapan*.

El cumplimiento de estas reglas es estrictamente obligatorio para cualquier desarrollador que colabore en el proyecto, garantizando un código mantenible, escalable, robusto y altamente profesional bajo estándares modernos de la industria.

### 2. Idioma Oficial del Proyecto
> **Regla Fundamental:** Todo el código fuente, nombres de variables, funciones, clases, bases de datos, documentación técnica, mensajes de commit y comentarios dentro del código deberán ser escritos **estrictamente en inglés**.

El uso del inglés asegura la estandarización técnica universal y la compatibilidad con herramientas automáticas de análisis de código. Las interacciones con los usuarios finales (interfaz de usuario) se manejarán de forma independiente mediante el sistema de internacionalización.

### 3. Arquitectura del Software (Clean Architecture by Features)
El proyecto se estructurará siguiendo los principios de **Clean Architecture** organizados por características funcionales (*by Features*). Cada funcionalidad independiente (ej. `auth`, `vistas`, `noticias`, `pagos`) debe actuar como un módulo aislado y contener de forma estricta las siguientes tres capas:

| Capa | Responsabilidad Primaria | Componentes Permitidos |
| :--- | :--- | :--- |
| **Data** | Implementación de la infraestructura, peticiones a Firebase, mapeo de datos remotos y locales a modelos de la aplicación. | DataSources, Repositories Impl, Models, DTOs. |
| **Domain** | Contiene la lógica de negocio pura y las entidades abstractas. Es totalmente independiente de librerías externas o frameworks de UI. | Entities, Use Cases, Repositories Interfaces. |
| **Presentation** | Manejo de la interfaz de usuario, renderizado de pantallas y gestión de estados locales a través de controladores visuales. | Widgets, Screens, State Notifiers / Providers. |

Adicionalmente, se imponen las siguientes reglas obligatorias para cada feature:
* **Consistencia Visual (Tematización):** Cada feature debe adoptar y seguir de forma obligatoria el sistema de temas preestablecido en la aplicación (`vecinalLightTheme()` y `vecinalDarkTheme()`). Queda estrictamente prohibido utilizar colores estáticos personalizados u otros estilos que rompan con la coherencia visual.
* **Telemetría e Instrumentación (Firebase Analytics):** En cada feature desarrollado, es obligatorio integrar eventos de medición mediante **Firebase Analytics** para rastrear vistas de pantalla y las interacciones principales del usuario.

### 4. Gestión de Estado e Inyección de Dependencias
* **Prohibición de State Local Anidado:** Se prohíbe explícitamente el uso de `setState` en los widgets de la aplicación para lógicas de estado compartido o de negocio. Todo el estado de la aplicación debe ser explícito, reactivo y centralizado.
* **Estandarización con Riverpod:** Se usará exclusivamente **Riverpod** tanto para la gestión de estados globales y locales como para la inyección de dependencias (DI).
* **Restricción de Singletons:** Queda estrictamente prohibido el uso de patrones Singleton globales clásicos (ej. instanciación estática directa o localizadores de servicios aislados). Toda dependencia de servicios (como Firebase) debe proveerse, inyectarse y gestionarse a través de un `Provider` de Riverpod para asegurar la testabilidad.

### 5. Restricciones de Tamaño y Métricas de Código
Con el fin de mitigar la complejidad ciclomática y asegurar el cumplimiento del Principio de Responsabilidad Única (SRP), se imponen los siguientes límites estructurales estrictos:
* **Funciones y Métodos de Lógica de Negocio:** No deberán exceder las **20 líneas de código** por función. Lógicas complejas deberán ser refactorizadas en subfunciones privadas o utilidades abstractas.
* **Métodos `build` de Widgets:** No deberán exceder las **100 líneas de código**. Si un árbol de widgets supera este límite, los componentes internos deberán ser extraídos obligatoriamente en subwidgets independientes (`ConsumerWidget` o `StatelessWidget`).
* **Archivos de Código (`.dart`):** Ningún archivo fuente podrá exceder las **300 líneas de código** en su totalidad.

### 6. Estrategia de Control de Versiones (Git Branching)
El desarrollo se realizará mediante un esquema ordenado de ramificaciones basado en características. Queda estrictamente prohibido realizar commits directos a la rama principal (`main` o `master`). Cada vez que se cree un nuevo feature o se resuelva un error, se creará una nueva rama con la siguiente nomenclatura según el caso de uso:
* Para el desarrollo de nuevas pantallas, servicios o funcionalidades: `feature/###-nombre-del-feature`
* Para la resolución de errores, fallos técnicos o regresiones detectadas: `bugfix/###-nombre-del-bug`

Donde `###` representa un identificador numérico secuencial de tres dígitos (por ejemplo, `001` o `002`).

Todo el código deberá integrarse mediante Pull Requests (PR) que requieran revisión de código y validación automatizada.

### 7. Política de Calidad y Pruebas (Testing Policy)
La estabilidad del software es prioritaria dada su naturaleza comunitaria. Por lo tanto:
1. **Cobertura por Feature:** Cada funcionalidad nueva o modificada debe incluir obligatoriamente sus respectivas pruebas unitarias (**Unit Testing**) para la lógica de negocio/casos de uso, y pruebas de componentes (**Widget Testing**) para la capa de presentación.
2. **Análisis Estático (Linting):** Se implementará de forma obligatoria el paquete `flutter_lints` con reglas estrictas activadas en el archivo `analysis_options.yaml`. No se permitirá la fusión de código que presente advertencias (warnings) o errores de estilo.
3. **Automatización CI/CD:** Se integrará **GitHub Actions** para ejecutar automáticamente el análisis estático y toda la suite de pruebas en cada Pull Request creado hacia las ramas de integración.

### 8. Internacionalización (i18n)
A pesar de ser una aplicación local, la arquitectura debe estar preparada globalmente. La aplicación contará con soporte nativo mediante `flutter_localizations` para cinco idiomas base, gestionados a través de archivos de recursos tipados (ARB):
* English (en)
* Español (es)
* Portugués (pt)
* Français (fr)
* Italiano (it)

> **Regla de Localización Obligatoria:** Cada texto visible para el usuario final en la interfaz gráfica (UI) deberá pasar obligatoriamente por el sistema de localización e internacionalización (`intl` o archivos ARB). Queda estrictamente prohibido incluir cadenas de texto estáticas (hardcoded) en los widgets.