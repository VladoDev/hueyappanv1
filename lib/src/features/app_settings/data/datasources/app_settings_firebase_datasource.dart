import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appSettingsFirebaseDatasourceProvider = Provider<AppSettingsFirebaseDatasource>((ref) {
  return AppSettingsFirebaseDatasource(FirebaseFirestore.instance);
});

class AppSettingsFirebaseDatasource {
  final FirebaseFirestore _firestore;

  AppSettingsFirebaseDatasource(this._firestore);

  Stream<Map<String, dynamic>?> watchAppSettings() {
    return _firestore
        .collection('community_settings')
        .doc('app_settings')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }
}
