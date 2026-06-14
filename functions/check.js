const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

// Initialize using Application Default Credentials
initializeApp({ projectId: "hueyappanv1" });

const db = getFirestore();

async function check() {
  const snapshot = await db.collection("residents").get();
  for (const doc of snapshot.docs) {
    console.log(`Doc: ${doc.id}`);
    console.log(doc.data());
  }
}
check();
