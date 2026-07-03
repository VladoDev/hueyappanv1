import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationsDatasource {
  final FirebaseFirestore _firestore;

  NotificationsDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<NotificationModel>> watchNotifications(String uid) {
    return _firestore
        .collection('residents')
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return NotificationModel.fromJson(data);
          }).toList();
        });
  }

  Future<void> markAsRead(String uid, String notificationId) async {
    await _firestore
        .collection('residents')
        .doc(uid)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
}
