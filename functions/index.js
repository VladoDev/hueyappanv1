const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getMessaging } = require("firebase-admin/messaging");

const { onRequest } = require("firebase-functions/v2/https");

initializeApp();



exports.broadcastEmergencyAlert = onDocumentCreated("emergencies/{docId}", async (event) => {
  const data = event.data.data();
  if (!data) return null;

  const triggeredByName = data.triggeredByName || "Un residente";
  const triggeredByLot = data.triggeredByLot || "desconocido";
  const triggeredByHouse = data.triggeredByHouse || "";

  const payload = {
    topic: "emergencies",
    notification: {
      title: "🚨 ¡ALERTA DE EMERGENCIA! 🚨",
      body: `El residente ${triggeredByName} del lote ${triggeredByLot}-${triggeredByHouse} ha activado una alarma de emergencia en la comunidad.`,
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
            critical: 1,
            name: "default",
            volume: 1.0,
          },
          "interruption-level": "critical",
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

const { getFirestore } = require("firebase-admin/firestore");
const { onDocumentWritten, onDocumentUpdated } = require("firebase-functions/v2/firestore");

exports.handlePhoneVerificationRequest = onDocumentWritten("phone_verifications/{uid}", async (event) => {
  const data = event.data.after ? event.data.after.data() : null;
  if (!data || data.status !== 'pending') return null;
  
  // Si ya tiene un OTP, significa que la función ya procesó este documento
  if (data.otp) return null;

  const uid = event.params.uid;
  const name = data.name || "Un residente";
  const lot = data.lot || "";
  const house = data.house || "";
  const phone = data.phone || "";

  // Generar OTP de 6 dígitos
  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  const db = getFirestore();
  
  // Guardar OTP en Firestore
  await db.collection("phone_verifications").doc(uid).update({
    otp: otp,
    otpCreatedAt: new Date(),
  });

  // Encontrar admins
  const adminsSnapshot = await db.collection("residents").where("role", "==", "admin").get();
  
  if (adminsSnapshot.empty) {
    console.log("No admins found to send OTP notification");
    return null;
  }

  const tokens = [];
  for (const doc of adminsSnapshot.docs) {
    const adminUid = doc.id;
    const devicesSnapshot = await db.collection("residents").doc(adminUid).collection("devices").where("isActive", "==", true).get();
    devicesSnapshot.forEach(device => {
      if (device.data().token) {
        tokens.push(device.data().token);
      }
    });
  }

  if (tokens.length === 0) {
    console.log("No active devices for admins");
    return null;
  }

  const payload = {
    tokens: tokens,
    notification: {
      title: "Solicitud de Verificación",
      body: `El vecino ${name} (Lote ${lot}-${house}) ha solicitado verificación OTP.`,
    },
    data: {
      type: "otp_verification",
      requesterName: name,
      requesterLot: lot,
      requesterHouse: house,
      requesterPhone: phone,
      otp: otp,
      requesterUid: uid,
    }
  };

  try {
    const response = await getMessaging().sendEachForMulticast(payload);
    console.log("Notificación de OTP enviada con éxito a admins:", response);
  } catch (error) {
    console.error("Error al enviar la notificación de OTP a admins:", error);
  }

  // Guardar la notificación en la subcolección de cada administrador
  for (const doc of adminsSnapshot.docs) {
    const adminUid = doc.id;
    try {
      await db.collection("residents").doc(adminUid).collection("notifications").add({
        title: "Solicitud de Verificación",
        body: `El vecino ${name} (Lote ${lot}-${house}) ha solicitado verificación OTP.`,
        type: "otp_verification",
        data: {
          requesterName: name,
          requesterLot: lot,
          requesterHouse: house,
          requesterPhone: phone,
          otp: otp,
          requesterUid: uid,
        },
        createdAt: new Date(),
        isRead: false
      });
    } catch (e) {
      console.error(`Error guardando notificación para el admin ${adminUid}:`, e);
    }
  }
});

exports.verifyPhoneOtp = onDocumentUpdated("phone_verifications/{uid}", async (event) => {
  const newValue = event.data.after.data();
  const previousValue = event.data.before.data();

  if (!newValue || newValue.status !== 'pending') return null;
  if (newValue.submittedOtp === previousValue.submittedOtp) return null;

  const submittedOtp = newValue.submittedOtp;
  const actualOtp = newValue.otp;
  const uid = event.params.uid;

  if (!submittedOtp || !actualOtp) return null;

  const db = getFirestore();

  if (submittedOtp === actualOtp) {
    // Valid OTP
    await db.collection("phone_verifications").doc(uid).update({
      status: 'verified',
    });
    await db.collection("residents").doc(uid).update({
      isPhoneVerified: true,
    });
    console.log(`User ${uid} phone verified successfully.`);
  } else {
    // Invalid OTP
    await db.collection("phone_verifications").doc(uid).update({
      status: 'failed',
    });
    console.log(`User ${uid} phone verification failed.`);
  }
});

