const { getMessaging } = require("firebase-admin/messaging");
const payload = {
  topic: "emergencies",
  notification: { title: "Test" },
  android: {
    priority: "high",
    notification: { sound: "siren.wav", channelId: "critical_emergency_channel_30s" }
  },
  apns: {
    payload: {
      aps: {
        sound: { critical: 1, name: "siren.wav", volume: 1.0 },
        "interruption-level": "critical"
      }
    }
  }
};

try {
  // We mock the send method to just validate the payload
  const messaging = getMessaging();
  // Firebase Admin SDK validates payloads before making network calls.
  // Actually, we can just use the internal validator if we don't have initialized app.
  // We'll initialize a dummy app to let it validate.
} catch (e) {
  console.log("Error during initialization");
}
