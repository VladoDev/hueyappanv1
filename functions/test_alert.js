const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

async function run() {
  try {
    await db.collection("emergencies").add({
      triggeredBy: "test",
      triggeredByName: "Test User",
      triggeredByLot: "00",
      triggeredByHouse: "A",
      timestamp: new Date(),
      status: "active"
    });
    console.log("Emergency added successfully");
  } catch (e) {
    console.error("Error:", e);
  }
}
run();
