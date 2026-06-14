import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hueyappanv1/src/features/security_events/domain/entities/security_event_entity.dart';

class SecurityEventsFirebaseDatasource {
  final FirebaseFirestore _firestore;

  SecurityEventsFirebaseDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> logEvent(SecurityEventEntity event) async {
    final docRef = event.id.isEmpty 
        ? _firestore.collection('screenshot_logs').doc()
        : _firestore.collection('screenshot_logs').doc(event.id);
        
    await docRef.set(event.toMap());
  }
}
