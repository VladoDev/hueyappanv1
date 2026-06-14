/**
 * One-off migration script to separate housingUnit into lot and house.
 * Old format: "Lote 160 - Casa C" or "160-C"
 * New format: lot: "160", house: "C"
 * 
 * Run from the functions/ directory with:
 *   node migrate_housing_units.js
 */

const admin = require("firebase-admin");

// Initialize using Application Default Credentials (gcloud auth)
// IMPORTANT: You need to authenticate first using:
// gcloud auth application-default login
// Or provide a serviceAccountKey.json path via GOOGLE_APPLICATION_CREDENTIALS
admin.initializeApp({
  projectId: "hueyappanv1",
});

const db = admin.firestore();

function extractLotHouse(oldUnit) {
  if (!oldUnit) return null;
  const match1 = oldUnit.match(/^Lote\s+(\d+)\s*-\s*Casa\s+(.+)$/i);
  const match2 = oldUnit.match(/^(\d+)-(.+)$/);
  
  if (match1) return { lot: match1[1], house: match1[2].trim() };
  if (match2) return { lot: match2[1], house: match2[2].trim() };
  return null;
}

async function migrate() {
  console.log("Migrating residents...");
  const residentsSnapshot = await db.collection("residents").get();
  for (const doc of residentsSnapshot.docs) {
    const data = doc.data();
    if (data.lot && data.house && !data.housingUnit) continue;

    const oldUnit = data.housingUnit;
    const extracted = extractLotHouse(oldUnit);

    if (extracted) {
      await db.collection("residents").doc(doc.id).update({
        lot: extracted.lot,
        house: extracted.house,
        housingUnit: admin.firestore.FieldValue.delete(),
      });
      console.log(`✅ Resident ${doc.id}: "${oldUnit}" → lot: "${extracted.lot}", house: "${extracted.house}"`);
    } else {
      console.log(`⚠️ Resident ${doc.id}: Unrecognized format "${oldUnit}", skipping.`);
    }
  }

  console.log("\nMigrating housing_payments...");
  const paymentsSnapshot = await db.collection("housing_payments").get();
  for (const doc of paymentsSnapshot.docs) {
    const data = doc.data();
    if (data.lot && data.house && !data.housingUnit) continue;

    const oldUnit = data.housingUnit;
    const extracted = extractLotHouse(oldUnit);

    if (extracted) {
      await db.collection("housing_payments").doc(doc.id).update({
        lot: extracted.lot,
        house: extracted.house,
        housingUnit: admin.firestore.FieldValue.delete(),
      });
      console.log(`✅ Payment ${doc.id}: "${oldUnit}" → lot: "${extracted.lot}", house: "${extracted.house}"`);
    }
    
    // Migrate nested transactions
    const txSnapshot = await doc.ref.collection("transactions").get();
    for (const txDoc of txSnapshot.docs) {
      const txData = txDoc.data();
      if (txData.lot && txData.house && !txData.housingUnit) continue;

      const txOldUnit = txData.housingUnit;
      const txExtracted = extractLotHouse(txOldUnit);

      if (txExtracted) {
        await txDoc.ref.update({
          lot: txExtracted.lot,
          house: txExtracted.house,
          housingUnit: admin.firestore.FieldValue.delete(),
        });
        console.log(`  ✅ Transaction ${txDoc.id} updated`);
      }
    }
  }

  console.log(`\n🏁 Migration complete.`);
  process.exit(0);
}

migrate().catch((err) => {
  console.error("Migration failed:", err);
  process.exit(1);
});
