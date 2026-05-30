# Configuración de Firebase Cloud Functions para Alertas Críticas

Para enviar notificaciones push a todos los dispositivos móviles (incluso cuando la aplicación está cerrada y el dispositivo en modo Silencio o No Molestar), debemos usar una **Firebase Cloud Function**.

Esta función se activará automáticamente cada vez que se agregue un nuevo documento en la colección `/emergencies` de Firestore.

---

## Requisitos Previos

1. Asegúrate de tener instalado **Node.js** (versión 18 o 20 recomendada) en tu computadora.
2. Instala Firebase CLI ejecutando:
   ```bash
   npm install -g firebase-tools
   ```
3. Inicia sesión en Firebase desde tu terminal:
   ```bash
   firebase login
   ```

---

## Paso 1: Inicializar Cloud Functions

Ejecuta el siguiente comando en la raíz de tu proyecto para iniciar el asistente de configuración de funciones:

```bash
firebase init functions
```

1. Selecciona tu proyecto actual: `hueyappanv1`.
2. Elige el lenguaje: **JavaScript** (o TypeScript si lo prefieres).
3. Selecciona **Yes** para usar ESLint (opcional).
4. Selecciona **Yes** para instalar las dependencias con `npm`.

Esto creará una carpeta llamada `functions` en la raíz de tu proyecto.

---

## Paso 2: Escribir el código de la función

Abre el archivo `functions/index.js` y reemplaza todo su contenido con el siguiente script de Node.js:

```javascript
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendEmergencyNotification = functions.firestore
  .document("emergencies/{docId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    if (!data) return null;

    const triggeredByName = data.triggeredByName || "Un residente";

    // Configuración del mensaje FCM
    const payload = {
      topic: "emergencies",
      notification: {
        title: "🚨 ¡ALERTA DE EMERGENCIA! 🚨",
        body: `El residente ${triggeredByName} ha activado una alarma de emergencia en la comunidad.`,
      },
      android: {
        priority: "high",
        notification: {
          sound: "default",
          channelId: "emergency_channel",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: {
              critical: 1,      // 1 indica que es una Alerta Crítica (iOS)
              name: "default",
              volume: 1.0,
            },
          },
        },
      },
    };

    try {
      const response = await admin.messaging().send(payload);
      console.log("Notificación de emergencia enviada con éxito:", response);
      return response;
    } catch (error) {
      console.error("Error al enviar la notificación:", error);
      throw new Error(error);
    }
  });
```

---

## Paso 3: Desplegar la función a Firebase

Para subir tu función al servidor de Firebase, ejecuta el siguiente comando:

```bash
firebase deploy --only functions
```

Una vez completado el despliegue, la función quedará activa y escuchará automáticamente la base de datos de Firestore.

---

## Configuración opcional: Prueba Directa en el Cliente (FCM Legacy)

Si deseas probar el envío de notificaciones push de inmediato sin desplegar la Cloud Function, el código de la app intentará buscar una clave del servidor FCM en Firestore:

1. En tu consola de Firebase, ve a **Configuración del proyecto** > **Cloud Messaging**.
2. Habilita la **API de Cloud Messaging (versión heredada/legacy)** de ser necesario, y copia la **Clave del servidor (Server Key)**.
3. En la base de datos de Firestore, crea una colección llamada `config`, un documento con ID `fcm` y un campo de texto `serverKey` con el valor de tu clave:
   * Colección: `/config`
   * Documento: `fcm`
   * Campo: `serverKey` (String)

Al hacer esto, la aplicación enviará la notificación push directamente a todos los dispositivos suscritos al tema `emergencies` cuando toques el botón de emergencia.
