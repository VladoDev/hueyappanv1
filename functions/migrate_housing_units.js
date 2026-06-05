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
admin.initializeApp({
  projectId: "hueyappanv1",
});

const db = admin.firestore();

async function migrate() {
  const residentsSnapshot = await db.collection("residents").get();
  let updated = 0;
  let skipped = 0;

  for (const doc of residentsSnapshot.docs) {
    const data = doc.data();
    
    // Check if it's already migrated
    if (data.lot && data.house && !data.housingUnit) {
      console.log(`⏭️  ${doc.id}: Already migrated, skipping.`);
      skipped++;
      continue;
    }

    const oldUnit = data.housingUnit;

    if (!oldUnit) {
      console.log(`⏭️  ${doc.id}: No housingUnit field, skipping.`);
      skipped++;
      continue;
    }

    let lot = "";
    let house = "";

    // Check if it matches old format: "Lote X - Casa Y"
    const match1 = oldUnit.match(/^Lote\s+(\d+)\s*-\s*Casa\s+(.+)$/i);
    // Check if it matches interim format: "X-Y"
    const match2 = oldUnit.match(/^(\d+)-(.+)$/);

    if (match1) {
      lot = match1[1];
      house = match1[2].trim();
    } else if (match2) {
      lot = match2[1];
      house = match2[2].trim();
    }

    if (lot && house) {
      await db.collection("residents").doc(doc.id).update({
        lot: lot,
        house: house,
        housingUnit: admin.firestore.FieldValue.delete(),
      });

      console.log(`✅ ${doc.id}: "${oldUnit}" → lot: "${lot}", house: "${house}"`);
      updated++;
    } else {
      console.log(`⚠️  ${doc.id}: Unrecognized format "${oldUnit}", skipping.`);
      skipped++;
    }
  }

  console.log(`\n🏁 Migration complete. Updated: ${updated}, Skipped: ${skipped}`);
  process.exit(0);
}

migrate().catch((err) => {
  console.error("Migration failed:", err);
  process.exit(1);
});
