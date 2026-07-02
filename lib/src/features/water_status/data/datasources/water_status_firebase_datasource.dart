import 'package:cloud_firestore/cloud_firestore.dart';

class WaterStatusFirebaseDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>> watchWaterStatus() {
    return _firestore
        .collection('community_settings')
        .doc('water_status')
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            return snapshot.data()!;
          }
          return {'status': 'auto'};
        });
  }

  Future<void> updateWaterStatus(String status, String uid) async {
    await _firestore.collection('community_settings').doc('water_status').set({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': uid,
    }, SetOptions(merge: true));
  }
}
