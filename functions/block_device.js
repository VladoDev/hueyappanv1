const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  projectId: 'hueyappan-prod'
});

const db = admin.firestore();

async function run() {
  try {
    await db.collection('blocked_devices').doc('23c2ebdc-0b10-4825-b9c3-ad6fe943f531').set({
      blockedAt: admin.firestore.FieldValue.serverTimestamp(),
      reason: "Manual block requested by admin"
    });
    console.log("Successfully blocked device.");
  } catch (e) {
    console.error("Error:", e);
  }
}

run();
