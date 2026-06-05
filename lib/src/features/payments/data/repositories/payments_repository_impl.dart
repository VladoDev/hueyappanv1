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
  Stream<List<HousingPaymentEntity>> watchNeighborPayments(String lot, String house) {
    return _dataSource.watchNeighborPayments(lot, house).map((list) {
      final entities = list.map((model) => model.toEntity()).toList();
      return _mergeHousingPayments(entities);
    });
  }

  @override
  Stream<List<HousingPaymentEntity>> watchConceptPayments(String conceptId) {
    return _dataSource.watchConceptPayments(conceptId).map((list) {
      final entities = list.map((model) => model.toEntity()).toList();
      return _mergeHousingPayments(entities);
    });
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

    // 3. Generate housing payment records for each unique housing unit
    final List<HousingPaymentModel> payments = [];
    final Set<String> uniqueHousingUnits = {};
    for (final resident in activeResidents) {
      if (uniqueHousingUnits.contains(resident.lot)) continue;
      uniqueHousingUnits.add(resident.lot);

      final paymentId = FirebaseFirestore.instance.collection('housing_payments').doc().id;
      payments.add(HousingPaymentModel(
        id: paymentId,
        conceptId: concept.id,
        residentUid: resident.uid,
        lot: resident.lot,
        house: resident.house,
        totalDue: concept.amountPerUnit,
        amountPaid: 0.0,
        balance: concept.amountPerUnit,
        paymentStatus: 'pending',
        extraAmount: 0.0,
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
    bool isAdmin = true,
    double extraAmount = 0.0,
    String? notes,
  }) async {
    // 1. Fetch current payment details
    final docRef = FirebaseFirestore.instance.collection('housing_payments').doc(housingPaymentId);
    final paymentDoc = await docRef.get();
    if (!paymentDoc.exists || paymentDoc.data() == null) {
      throw Exception('Registro de adeudo no encontrado.');
    }
    final currentModel = HousingPaymentModel.fromJson(paymentDoc.data()!);

    // Fetch concept title for context & metadata
    final conceptDoc = await FirebaseFirestore.instance
        .collection('concepts')
        .doc(currentModel.conceptId)
        .get();
    String conceptTitle = 'Pago';
    if (conceptDoc.exists && conceptDoc.data() != null) {
      conceptTitle = conceptDoc.data()!['title'] as String? ?? 'Pago';
    }

    // Set hasPendingConfirmation to true, but do not update totals yet
    final updatedModel = currentModel.copyWith(
      hasPendingConfirmation: true,
    );

    // 3. Create the transaction record as unconfirmed
    final transactionId = docRef.collection('transactions').doc().id;
    final transactionModel = PaymentTransactionModel(
      id: transactionId,
      housingPaymentId: housingPaymentId,
      amount: amount,
      extraAmount: extraAmount,
      type: type,
      createdAt: DateTime.now(),
      createdBy: createdBy,
      notes: notes,
      lot: currentModel.lot,
      house: currentModel.house,
      conceptTitle: conceptTitle,
      conceptId: currentModel.conceptId,
      isConfirmed: false,
      confirmedAt: null,
    );

    // 4. Save to Firestore
    await _dataSource.savePaymentTransaction(
      updatedPayment: updatedModel,
      transaction: transactionModel,
    );

    // 5. Send push notification depending on who registered the payment
    try {
      final serverKey = await _dataSource.getFcmServerKey();
      
      final List<String> targetTokens = [];
      String notificationBody = '';
      String notificationTitle = 'Confirmación de Pago Pendiente 💳';

      if (isAdmin) {
        // Admin registered it -> send to neighbors of that unit
        final activeResidents = await _dataSource.getActiveResidents();
        final unitResidents = activeResidents.where((r) => r.lot == currentModel.lot && r.house == currentModel.house);
        
        for (final resident in unitResidents) {
          final t = await _dataSource.getResidentTokens(resident.uid);
          targetTokens.addAll(t);
        }

        notificationBody = 'El administrador registró un pago por \$${amount.toStringAsFixed(2)} para el concepto "$conceptTitle". Por favor confírmalo para que se refleje en tu cuenta.';
      } else {
        // Neighbor registered it -> send to admins
        final adminTokens = await _dataSource.getAdminTokens();
        targetTokens.addAll(adminTokens);
        
        notificationBody = 'El residente del Lote ${currentModel.lot}-${currentModel.house} ha reportado un pago por \$${amount.toStringAsFixed(2)} para el concepto "$conceptTitle". Por favor revísalo y confírmalo.';
      }

      if (targetTokens.isNotEmpty) {
        await _dataSource.sendPushNotification(
          serverKey,
          title: notificationTitle,
          body: notificationBody,
          targetTokens: targetTokens,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error sending push notification for payment: $e');
    }
  }

  @override
  Future<void> confirmPaymentTransaction({
    required String housingPaymentId,
    required String transactionId,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('housing_payments').doc(housingPaymentId);
    final paymentDoc = await docRef.get();
    if (!paymentDoc.exists || paymentDoc.data() == null) {
      throw Exception('Registro de adeudo no encontrado.');
    }
    final parentModel = HousingPaymentModel.fromJson(paymentDoc.data()!);

    final txDocRef = docRef.collection('transactions').doc(transactionId);
    final txDoc = await txDocRef.get();
    if (!txDoc.exists || txDoc.data() == null) {
      throw Exception('Transacción no encontrada.');
    }
    final transactionModel = PaymentTransactionModel.fromJson(txDoc.data()!);

    if (transactionModel.isConfirmed) {
      // Already confirmed, nothing to do
      return;
    }

    // Fetch all transactions to recalculate totals
    final txsSnapshot = await docRef.collection('transactions').get();
    final allTransactions = txsSnapshot.docs
        .map((d) => PaymentTransactionModel.fromJson(d.data()))
        .toList();

    double newAmountPaid = 0.0;
    double newExtraAmount = 0.0;
    bool hasUnconfirmed = false;
    bool hasComplete = false;

    for (final tx in allTransactions) {
      final isTxConfirmed = (tx.id == transactionId) || tx.isConfirmed;
      if (isTxConfirmed) {
        if (tx.type == 'complete') {
          hasComplete = true;
        }
        newAmountPaid += tx.amount;
        newExtraAmount += tx.extraAmount;
      } else {
        hasUnconfirmed = true;
      }
    }

    double newBalance = parentModel.totalDue - newAmountPaid;
    String newStatus;
    DateTime? newPaidAt = parentModel.paidAt;

    if (hasComplete || newBalance <= 0) {
      newAmountPaid = parentModel.totalDue;
      newBalance = 0.0;
      newStatus = 'paid';
      newPaidAt = DateTime.now();
    } else if (newAmountPaid > 0) {
      newStatus = 'partial';
      newPaidAt = null;
    } else {
      newAmountPaid = 0.0;
      newBalance = parentModel.totalDue;
      newStatus = 'pending';
      newPaidAt = null;
    }

    final updatedParentModel = parentModel.copyWith(
      amountPaid: newAmountPaid,
      balance: newBalance,
      extraAmount: newExtraAmount,
      paymentStatus: newStatus,
      paidAt: newPaidAt,
      hasPendingConfirmation: hasUnconfirmed,
    );

    final updatedTransactionModel = transactionModel.copyWith(
      isConfirmed: true,
      confirmedAt: DateTime.now(),
    );

    await _dataSource.savePaymentTransaction(
      updatedPayment: updatedParentModel,
      transaction: updatedTransactionModel,
    );
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

  List<HousingPaymentEntity> _mergeHousingPayments(List<HousingPaymentEntity> list) {
    final Map<String, List<HousingPaymentEntity>> grouped = {};
    for (final payment in list) {
      final key = '${payment.conceptId}_${payment.lot}_${payment.house}';
      grouped.putIfAbsent(key, () => []).add(payment);
    }

    final List<HousingPaymentEntity> mergedList = [];
    grouped.forEach((key, payments) {
      // Sort payments by ID to guarantee a deterministic representative across different Firestore query orderings
      payments.sort((a, b) => a.id.compareTo(b.id));

      if (payments.length == 1) {
        mergedList.add(payments.first);
      } else {
        // Merge multiple payments for the same concept and housing unit (lote)
        final representative = payments.first;
        
        final double totalPaid = payments.fold<double>(0, (acc, p) => acc + p.amountPaid);
        final double totalExtra = payments.fold<double>(0, (acc, p) => acc + p.extraAmount);
        
        final double totalDue = representative.totalDue;
        final double balance = (totalDue - totalPaid).clamp(0.0, totalDue);
        
        final String status;
        if (balance <= 0) {
          status = 'paid';
        } else if (totalPaid > 0) {
          status = 'partial';
        } else {
          status = 'pending';
        }
        
        DateTime? latestPaidAt;
        for (final p in payments) {
          if (p.paidAt != null) {
            if (latestPaidAt == null || p.paidAt!.isAfter(latestPaidAt)) {
              latestPaidAt = p.paidAt;
            }
          }
        }
        
        final notesList = payments.map((p) => p.notes).whereType<String>().where((n) => n.isNotEmpty).toList();
        final notes = notesList.isNotEmpty ? notesList.join(' | ') : null;

        mergedList.add(HousingPaymentEntity(
          id: representative.id,
          conceptId: representative.conceptId,
          residentUid: representative.residentUid,
          lot: representative.lot,
          house: representative.house,
          totalDue: totalDue,
          amountPaid: totalPaid,
          balance: balance,
          paymentStatus: status,
          extraAmount: totalExtra,
          paidAt: latestPaidAt,
          notes: notes,
          hasPendingConfirmation: payments.any((p) => p.hasPendingConfirmation),
        ));
      }
    });

    return mergedList;
  }
}
