import 'package:flutter_test/flutter_test.dart';
import 'package:hueyappanv1/src/features/payments/domain/entities/payment_concept_entity.dart';
import 'package:hueyappanv1/src/features/payments/domain/entities/concept_item_entity.dart';
import 'package:hueyappanv1/src/features/payments/domain/entities/housing_payment_entity.dart';
import 'package:hueyappanv1/src/features/payments/domain/entities/payment_transaction_entity.dart';
import 'package:hueyappanv1/src/features/payments/domain/repositories/payments_repository.dart';
import 'package:hueyappanv1/src/features/payments/domain/usecases/watch_concepts_usecase.dart';
import 'package:hueyappanv1/src/features/payments/domain/usecases/register_payment_transaction_usecase.dart';

class MockPaymentsRepository implements PaymentsRepository {
  final List<PaymentConceptEntity> _concepts = [
    PaymentConceptEntity(
      id: '1',
      title: 'Mantenimiento de Alberca',
      description: 'Limpieza mensual de la alberca principal',
      totalAmount: 4000.0,
      totalUnits: 40,
      amountPerUnit: 100.0,
      status: 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<HousingPaymentEntity> _payments = [
    HousingPaymentEntity(
      id: 'hp1',
      conceptId: '1',
      residentUid: 'res123',
      lot: "Lote 120", house: "A",
      totalDue: 100.0,
      amountPaid: 0.0,
      balance: 100.0,
      paymentStatus: 'pending',
      hasPendingConfirmation: false,
    ),
  ];

  final List<PaymentTransactionEntity> _transactions = [];

  @override
  Stream<List<PaymentConceptEntity>> watchConcepts() {
    return Stream.value(_concepts);
  }

  @override
  Stream<List<ConceptItemEntity>> watchConceptItems(String conceptId) {
    return Stream.value([]);
  }

  @override
  Stream<List<HousingPaymentEntity>> watchNeighborPayments(String lot, String house) {
    return Stream.value(_payments.where((p) => p.lot == lot && p.house == house).toList());
  }

  @override
  Stream<List<HousingPaymentEntity>> watchConceptPayments(String conceptId) {
    return Stream.value(_payments.where((p) => p.conceptId == conceptId).toList());
  }

  @override
  Stream<List<PaymentTransactionEntity>> watchPaymentTransactions(String housingPaymentId) {
    return Stream.value(_transactions.where((t) => t.housingPaymentId == housingPaymentId).toList());
  }

  @override
  Future<void> createConcept(PaymentConceptEntity concept, List<ConceptItemEntity> items) async {
    _concepts.add(concept);
  }

  @override
  Future<void> updateConcept(PaymentConceptEntity concept) async {
    final idx = _concepts.indexWhere((c) => c.id == concept.id);
    if (idx != -1) {
      _concepts[idx] = concept;
    }
  }

  @override
  Future<void> deleteConcept(String conceptId) async {
    _concepts.removeWhere((c) => c.id == conceptId);
  }

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
    final idx = _payments.indexWhere((p) => p.id == housingPaymentId);
    if (idx == -1) throw Exception('Adeudo no encontrado');

    final current = _payments[idx];
    _payments[idx] = HousingPaymentEntity(
      id: current.id,
      conceptId: current.conceptId,
      residentUid: current.residentUid,
      lot: current.lot,
      house: current.house,
      totalDue: current.totalDue,
      amountPaid: current.amountPaid,
      balance: current.balance,
      paymentStatus: current.paymentStatus,
      extraAmount: current.extraAmount,
      paidAt: current.paidAt,
      notes: notes,
      hasPendingConfirmation: true,
    );

    final concept = _concepts.firstWhere((c) => c.id == current.conceptId);

    _transactions.add(PaymentTransactionEntity(
      id: 't_${_transactions.length}',
      housingPaymentId: housingPaymentId,
      amount: amount,
      extraAmount: extraAmount,
      type: type,
      createdAt: DateTime.now(),
      createdBy: createdBy,
      notes: notes,
      lot: current.lot,
      house: current.house,
      conceptTitle: concept.title,
      conceptId: current.conceptId,
      isConfirmed: false,
      confirmedAt: null,
    ));
  }

  @override
  Future<void> confirmPaymentTransaction({
    required String housingPaymentId,
    required String transactionId,
  }) async {
    final idx = _payments.indexWhere((p) => p.id == housingPaymentId);
    if (idx == -1) throw Exception('Adeudo no encontrado');
    final current = _payments[idx];

    final txIdx = _transactions.indexWhere((t) => t.id == transactionId);
    if (txIdx == -1) throw Exception('Transacción no encontrada');
    final tx = _transactions[txIdx];

    if (tx.isConfirmed) return;

    _transactions[txIdx] = PaymentTransactionEntity(
      id: tx.id,
      housingPaymentId: tx.housingPaymentId,
      amount: tx.amount,
      extraAmount: tx.extraAmount,
      type: tx.type,
      createdAt: tx.createdAt,
      createdBy: tx.createdBy,
      notes: tx.notes,
      lot: tx.lot,
      house: tx.house,
      conceptTitle: tx.conceptTitle,
      conceptId: tx.conceptId,
      isConfirmed: true,
      confirmedAt: DateTime.now(),
    );

    double newAmountPaid = 0.0;
    double newExtraAmount = 0.0;
    bool hasUnconfirmed = false;
    bool hasComplete = false;

    for (final transaction in _transactions.where((t) => t.housingPaymentId == housingPaymentId)) {
      if (transaction.isConfirmed) {
        if (transaction.type == 'complete') {
          hasComplete = true;
        }
        newAmountPaid += transaction.amount;
        newExtraAmount += transaction.extraAmount;
      } else {
        hasUnconfirmed = true;
      }
    }

    double newBalance = current.totalDue - newAmountPaid;
    String newStatus;

    if (hasComplete || newBalance <= 0) {
      newAmountPaid = current.totalDue;
      newBalance = 0.0;
      newStatus = 'paid';
    } else if (newAmountPaid > 0) {
      newStatus = 'partial';
    } else {
      newAmountPaid = 0.0;
      newBalance = current.totalDue;
      newStatus = 'pending';
    }

    _payments[idx] = HousingPaymentEntity(
      id: current.id,
      conceptId: current.conceptId,
      residentUid: current.residentUid,
      lot: current.lot,
      house: current.house,
      totalDue: current.totalDue,
      amountPaid: newAmountPaid,
      balance: newBalance,
      paymentStatus: newStatus,
      extraAmount: newExtraAmount,
      paidAt: newStatus == 'paid' ? DateTime.now() : null,
      notes: current.notes,
      hasPendingConfirmation: hasUnconfirmed,
    );
  }

  @override
  Future<void> updateRecordedExpense({
    required String conceptId,
    required double expense,
  }) async {
    final idx = _concepts.indexWhere((c) => c.id == conceptId);
    if (idx != -1) {
      final current = _concepts[idx];
      _concepts[idx] = PaymentConceptEntity(
        id: current.id,
        title: current.title,
        description: current.description,
        totalAmount: current.totalAmount,
        totalUnits: current.totalUnits,
        amountPerUnit: current.amountPerUnit,
        status: current.status,
        createdAt: current.createdAt,
        updatedAt: DateTime.now(),
        recordedExpense: expense,
      );
    }
  }
}

void main() {
  group('Payments UseCases Unit Tests', () {
    late MockPaymentsRepository repository;
    late WatchConceptsUsecase watchConceptsUsecase;
    late RegisterPaymentTransactionUsecase registerPaymentUsecase;

    setUp(() {
      repository = MockPaymentsRepository();
      watchConceptsUsecase = WatchConceptsUsecase(repository);
      registerPaymentUsecase = RegisterPaymentTransactionUsecase(repository);
    });

    test('watchConcepts returns concept list successfully', () async {
      final list = await watchConceptsUsecase.execute().first;
      expect(list.length, 1);
      expect(list.first.title, 'Mantenimiento de Alberca');
      expect(list.first.amountPerUnit, 100.0);
    });

    test('registerPaymentTransaction starts as unconfirmed and applies correctly after confirm', () async {
      // Abono parcial de $40 a una deuda de $100
      await registerPaymentUsecase.execute(
        housingPaymentId: 'hp1',
        amount: 40.0,
        type: 'partial',
        createdBy: 'admin_uid',
      );

      var payments = await repository.watchConceptPayments('1').first;
      var payment = payments.firstWhere((p) => p.id == 'hp1');

      // Check transaction starts as unconfirmed
      expect(payment.amountPaid, 0.0);
      expect(payment.balance, 100.0);
      expect(payment.paymentStatus, 'pending');
      expect(payment.hasPendingConfirmation, true);

      // Resident confirms transaction
      final txs = await repository.watchPaymentTransactions('hp1').first;
      expect(txs.length, 1);
      await repository.confirmPaymentTransaction(
        housingPaymentId: 'hp1',
        transactionId: txs.first.id,
      );

      payments = await repository.watchConceptPayments('1').first;
      payment = payments.firstWhere((p) => p.id == 'hp1');

      expect(payment.amountPaid, 40.0);
      expect(payment.balance, 60.0);
      expect(payment.paymentStatus, 'partial');
      expect(payment.hasPendingConfirmation, false);
    });

    test('registerPaymentTransaction calculates paid status on complete payment after confirm', () async {
      // Pago completo de $100
      await registerPaymentUsecase.execute(
        housingPaymentId: 'hp1',
        amount: 100.0,
        type: 'complete',
        createdBy: 'admin_uid',
      );

      final txs = await repository.watchPaymentTransactions('hp1').first;
      await repository.confirmPaymentTransaction(
        housingPaymentId: 'hp1',
        transactionId: txs.first.id,
      );

      final payments = await repository.watchConceptPayments('1').first;
      final payment = payments.firstWhere((p) => p.id == 'hp1');

      expect(payment.amountPaid, 100.0);
      expect(payment.balance, 0.0);
      expect(payment.paymentStatus, 'paid');
    });

    test('registerPaymentTransaction logs extraAmount correctly without reducing balance after confirm', () async {
      // Pago de extra de $50
      await registerPaymentUsecase.execute(
        housingPaymentId: 'hp1',
        amount: 0.0,
        type: 'partial',
        createdBy: 'admin_uid',
        extraAmount: 50.0,
      );

      final txs = await repository.watchPaymentTransactions('hp1').first;
      await repository.confirmPaymentTransaction(
        housingPaymentId: 'hp1',
        transactionId: txs.first.id,
      );

      final payments = await repository.watchConceptPayments('1').first;
      final payment = payments.firstWhere((p) => p.id == 'hp1');

      expect(payment.amountPaid, 0.0);
      expect(payment.balance, 100.0);
      expect(payment.extraAmount, 50.0);
      expect(payment.paymentStatus, 'pending');
    });
  });
}
