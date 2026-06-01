import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/payment_concept_entity.dart';
import '../../domain/entities/concept_item_entity.dart';
import '../../domain/entities/housing_payment_entity.dart';
import '../../domain/entities/payment_transaction_entity.dart';
import '../../domain/repositories/payments_repository.dart';
import '../datasources/payments_firebase_datasource.dart';
import '../models/payment_concept_model.dart';
import '../models/concept_item_model.dart';
import '../models/housing_payment_model.dart';
import '../models/payment_transaction_model.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  final PaymentsFirebaseDatasource _dataSource;

  PaymentsRepositoryImpl(this._dataSource);

  // ── Stream Mapping ──

  @override
  Stream<List<PaymentConceptEntity>> watchConcepts() {
    return _dataSource.watchConcepts().map((list) =>
        list.map((model) => model.toEntity()).toList());
  }

  @override
  Stream<List<ConceptItemEntity>> watchConceptItems(String conceptId) {
    return _dataSource.watchConceptItems(conceptId).map((list) =>
        list.map((model) => model.toEntity()).toList());
  }

  @override
  Stream<List<HousingPaymentEntity>> watchNeighborPayments(String housingUnit) {
    return _dataSource.watchNeighborPayments(housingUnit).map((list) =>
        list.map((model) => model.toEntity()).toList());
  }

  @override
  Stream<List<HousingPaymentEntity>> watchConceptPayments(String conceptId) {
    return _dataSource.watchConceptPayments(conceptId).map((list) =>
        list.map((model) => model.toEntity()).toList());
  }

  @override
  Stream<List<PaymentTransactionEntity>> watchPaymentTransactions(
      String housingPaymentId) {
    return _dataSource.watchPaymentTransactions(housingPaymentId).map((list) =>
        list.map((model) => model.toEntity()).toList());
  }

  // ── Concept Creation & Management ──

  @override
  Future<void> createConcept(
      PaymentConceptEntity concept, List<ConceptItemEntity> items) async {
    // 1. Fetch active residents
    final activeResidents = await _dataSource.getActiveResidents();

    // 2. Map concept and items to models
    final conceptModel = PaymentConceptModel.fromEntity(concept);
    final itemModels = items.map((e) => ConceptItemModel.fromEntity(e)).toList();

    // 3. Generate housing payment records for each active resident
    final List<HousingPaymentModel> payments = [];
    for (final resident in activeResidents) {
      final paymentId = FirebaseFirestore.instance.collection('housing_payments').doc().id;
      payments.add(HousingPaymentModel(
        id: paymentId,
        conceptId: concept.id,
        residentUid: resident.uid,
        housingUnit: resident.housingUnit,
        totalDue: concept.amountPerUnit,
        amountPaid: 0.0,
        balance: concept.amountPerUnit,
        paymentStatus: 'pending',
        paidAt: null,
        notes: null,
      ));
    }

    // 4. Save batch to Firestore
    await _dataSource.saveConceptWithDetails(
      concept: conceptModel,
      items: itemModels,
      payments: payments,
    );

    // 5. Send broadcast notification
    try {
      final serverKey = await _dataSource.getFcmServerKey();
      await _dataSource.sendPushNotification(
        serverKey,
        title: 'Nuevo Pago Pendiente 📋',
        body: 'Se ha creado el concepto "${concept.title}" con un monto de \$${concept.amountPerUnit.toStringAsFixed(2)} por casa.',
        topic: 'payments',
      );
    } catch (e) {
      // Non-blocking error for push notification failure
      debugPrint('⚠️ Error sending push notification for concept: $e');
    }
  }

  @override
  Future<void> updateConcept(PaymentConceptEntity concept) async {
    final model = PaymentConceptModel.fromEntity(concept);
    await _dataSource.updateConcept(model);
  }

  @override
  Future<void> deleteConcept(String conceptId) async {
    await _dataSource.deleteConcept(conceptId);
  }

  // ── Payment Recording & Auditing ──

  @override
  Future<void> registerPaymentTransaction({
    required String housingPaymentId,
    required double amount,
    required String type,
    required String createdBy,
    String? notes,
  }) async {
    // 1. Fetch current payment details
    final docRef = FirebaseFirestore.instance.collection('housing_payments').doc(housingPaymentId);
    final paymentDoc = await docRef.get();
    if (!paymentDoc.exists || paymentDoc.data() == null) {
      throw Exception('Registro de adeudo no encontrado.');
    }
    final currentModel = HousingPaymentModel.fromJson(paymentDoc.data()!);

    // 2. Perform calculations
    double newAmountPaid = currentModel.amountPaid + amount;
    double newBalance = currentModel.totalDue - newAmountPaid;
    String newStatus;
    DateTime? newPaidAt = currentModel.paidAt;

    if (type == 'complete' || newBalance <= 0) {
      newAmountPaid = currentModel.totalDue;
      newBalance = 0.0;
      newStatus = 'paid';
      newPaidAt = DateTime.now();
    } else if (newAmountPaid > 0) {
      newStatus = 'partial';
      newPaidAt = null;
    } else {
      newAmountPaid = 0.0;
      newBalance = currentModel.totalDue;
      newStatus = 'pending';
      newPaidAt = null;
    }

    final updatedModel = currentModel.copyWith(
      amountPaid: newAmountPaid,
      balance: newBalance,
      paymentStatus: newStatus,
      paidAt: newPaidAt,
      notes: notes,
    );

    // 3. Create the transaction record
    final transactionId = docRef.collection('transactions').doc().id;
    final transactionModel = PaymentTransactionModel(
      id: transactionId,
      housingPaymentId: housingPaymentId,
      amount: amount,
      type: type,
      createdAt: DateTime.now(),
      createdBy: createdBy,
      notes: notes,
    );

    // 4. Save to Firestore
    await _dataSource.savePaymentTransaction(
      updatedPayment: updatedModel,
      transaction: transactionModel,
    );

    // 5. Send push notification to target resident
    try {
      final serverKey = await _dataSource.getFcmServerKey();
      final tokens = await _dataSource.getResidentTokens(currentModel.residentUid);

      if (tokens.isNotEmpty) {
        // Fetch concept title for context
        final conceptDoc = await FirebaseFirestore.instance
            .collection('concepts')
            .doc(currentModel.conceptId)
            .get();
        
        String conceptTitle = 'Pago';
        if (conceptDoc.exists && conceptDoc.data() != null) {
          conceptTitle = conceptDoc.data()!['title'] as String? ?? 'Pago';
        }

        String body;
        if (newStatus == 'paid') {
          body = 'Tu pago para el concepto "$conceptTitle" por \$${amount.toStringAsFixed(2)} fue recibido. ¡Tu adeudo ha quedado liquidado!';
        } else if (type == 'correction') {
          body = 'Se ha registrado un ajuste en tu adeudo del concepto "$conceptTitle" por \$${amount.toStringAsFixed(2)}. Saldo restante: \$${newBalance.toStringAsFixed(2)}.';
        } else {
          body = 'Tu abono para el concepto "$conceptTitle" por \$${amount.toStringAsFixed(2)} fue recibido. Saldo restante: \$${newBalance.toStringAsFixed(2)}.';
        }

        await _dataSource.sendPushNotification(
          serverKey,
          title: 'Pago Registrado 💳',
          body: body,
          targetTokens: tokens,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error sending push notification for payment: $e');
    }
  }

  @override
  Future<void> updateRecordedExpense({
    required String conceptId,
    required double expense,
  }) async {
    final doc = await FirebaseFirestore.instance.collection('concepts').doc(conceptId).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Concepto no encontrado.');
    }
    final model = PaymentConceptModel.fromJson(doc.data()!);
    final updatedModel = model.copyWith(
      recordedExpense: expense,
      updatedAt: DateTime.now(),
    );

    await _dataSource.updateConcept(updatedModel);
  }
}
