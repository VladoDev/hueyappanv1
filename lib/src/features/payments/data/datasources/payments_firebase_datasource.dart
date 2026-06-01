import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../authentication/data/models/resident_model.dart';
import '../models/payment_concept_model.dart';
import '../models/concept_item_model.dart';
import '../models/housing_payment_model.dart';
import '../models/payment_transaction_model.dart';

class PaymentsFirebaseDatasource {
  final FirebaseFirestore _firestore;

  PaymentsFirebaseDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ── Stream Readers ──

  Stream<List<PaymentConceptModel>> watchConcepts() {
    return _firestore
        .collection('concepts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentConceptModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<ConceptItemModel>> watchConceptItems(String conceptId) {
    return _firestore
        .collection('concepts')
        .doc(conceptId)
        .collection('items')
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConceptItemModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<HousingPaymentModel>> watchNeighborPayments(String housingUnit) {
    return _firestore
        .collection('housing_payments')
        .where('housingUnit', isEqualTo: housingUnit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HousingPaymentModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<HousingPaymentModel>> watchConceptPayments(String conceptId) {
    return _firestore
        .collection('housing_payments')
        .where('conceptId', isEqualTo: conceptId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HousingPaymentModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<PaymentTransactionModel>> watchPaymentTransactions(
      String housingPaymentId) {
    return _firestore
        .collection('housing_payments')
        .doc(housingPaymentId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentTransactionModel.fromJson(doc.data()))
            .toList());
  }

  // ── Writers & Batch Actions ──

  Future<void> saveConceptWithDetails({
    required PaymentConceptModel concept,
    required List<ConceptItemModel> items,
    required List<HousingPaymentModel> payments,
  }) async {
    final batch = _firestore.batch();

    // 1. Save concept document
    final conceptRef = _firestore.collection('concepts').doc(concept.id);
    batch.set(conceptRef, concept.toJson());

    // 2. Save sub-items
    for (final item in items) {
      final itemRef = conceptRef.collection('items').doc(item.id);
      batch.set(itemRef, item.toJson());
    }

    // 3. Save housing payments
    for (final payment in payments) {
      final paymentRef = _firestore.collection('housing_payments').doc(payment.id);
      batch.set(paymentRef, payment.toJson());
    }

    await batch.commit();
  }

  Future<void> updateConcept(PaymentConceptModel concept) async {
    await _firestore.collection('concepts').doc(concept.id).update(concept.toJson());
  }

  Future<void> deleteConcept(String conceptId) async {
    final batch = _firestore.batch();

    // 1. Delete concept document
    batch.delete(_firestore.collection('concepts').doc(conceptId));

    // 2. Delete concept sub-items
    final itemsSnapshot = await _firestore
        .collection('concepts')
        .doc(conceptId)
        .collection('items')
        .get();
    for (final doc in itemsSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // 3. Delete housing payments associated with this concept
    final paymentsSnapshot = await _firestore
        .collection('housing_payments')
        .where('conceptId', isEqualTo: conceptId)
        .get();
    for (final doc in paymentsSnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<void> savePaymentTransaction({
    required HousingPaymentModel updatedPayment,
    required PaymentTransactionModel transaction,
  }) async {
    final batch = _firestore.batch();

    // 1. Update the parent housing payment
    final paymentRef =
        _firestore.collection('housing_payments').doc(updatedPayment.id);
    batch.set(paymentRef, updatedPayment.toJson());

    // 2. Create the transaction record
    final transactionRef = paymentRef.collection('transactions').doc(transaction.id);
    batch.set(transactionRef, transaction.toJson());

    await batch.commit();
  }

  // ── Residents Query ──

  Future<List<ResidentModel>> getActiveResidents() async {
    final snapshot = await _firestore
        .collection('residents')
        .where('accountStatus', isEqualTo: 'Active')
        .get();

    return snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data.putIfAbsent('uid', () => doc.id);
      return ResidentModel.fromJson(data);
    }).toList();
  }

  // ── Push Notifications / FCM ──

  Future<String?> getFcmServerKey() async {
    try {
      final doc = await _firestore.collection('config').doc('fcm').get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!['serverKey'] as String?;
      }
    } catch (e) {
      debugPrint('⚠️ [FCM Config] Could not load server key: $e');
    }
    return null;
  }

  Future<List<String>> getResidentTokens(String residentUid) async {
    try {
      final snapshot = await _firestore
          .collection('residents')
          .doc(residentUid)
          .collection('devices')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['token'] as String?)
          .whereType<String>()
          .toList();
    } catch (e) {
      debugPrint('⚠️ [FCM Tokens] Error fetching tokens for $residentUid: $e');
      return [];
    }
  }

  Future<void> sendPushNotification(
    String? serverKey, {
    required String title,
    required String body,
    String? topic,
    List<String>? targetTokens,
  }) async {
    if (serverKey == null || serverKey.isEmpty) {
      debugPrint('⚠️ [FCM] Server key missing. Skipping push notification.');
      return;
    }

    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final List<String> recipients = [];
    if (topic != null) {
      recipients.add('/topics/$topic');
    } else if (targetTokens != null) {
      recipients.addAll(targetTokens);
    }

    for (final recipient in recipients) {
      final payload = {
        'to': recipient,
        'priority': 'high',
        'notification': {
          'title': title,
          'body': body,
          'sound': 'default',
        },
        'android': {
          'priority': 'high',
          'notification': {
            'sound': 'default',
            'channel_id': 'payments_channel',
          },
        },
        'apns': {
          'payload': {
            'aps': {
              'sound': 'default',
              'interruption-level': 'active',
            },
          },
        },
      };

      try {
        final response = await http.post(
          url,
          headers: headers,
          body: json.encode(payload),
        );
        debugPrint(
            '🔔 [FCM] Notification sent to $recipient. Status: ${response.statusCode}');
      } catch (e) {
        debugPrint('❌ [FCM] Error sending message to $recipient: $e');
      }
    }
  }
}
