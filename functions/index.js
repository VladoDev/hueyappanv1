const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

exports.broadcastEmergencyAlert = onDocumentCreated("emergencies/{docId}", async (event) => {
  const data = event.data.data();
  if (!data) return null;

  const triggeredByName = data.triggeredByName || "Un residente";

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
          sound: "default",
          "interruption-level": "time-sensitive",
        },
      },
    },
  };

  try {
    const response = await getMessaging().send(payload);
    console.log("Notificación de emergencia enviada con éxito:", response);
    return response;
  } catch (error) {
    console.error("Error al enviar la notificación:", error);
    throw new Error(error);
  }
});
