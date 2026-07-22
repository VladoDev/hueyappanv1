import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceBlockDatasource {
  final FirebaseFirestore _firestore;

  DeviceBlockDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> isDeviceBlocked(String deviceId) async {
    try {
      final doc = await _firestore.collection('blocked_devices').doc(deviceId).get(
        const GetOptions(source: Source.server),
      );
      return doc.exists;
    } catch (e) {
      // Return false on network error. The repository will handle the fallback
      // using the local datasource if needed.
      return false; 
    }
  }

  Future<void> saveDeviceIdToResident(String uid, String deviceId) async {
    try {
      await _firestore.collection('residents').doc(uid).set(
        {'deviceId': deviceId},
        SetOptions(merge: true),
      );
    } catch (e) {
      // Non-critical, could happen if user has no permission (e.g. logged out)
    }
  }
}
