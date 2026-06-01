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
      housingUnit: 'Lote 120 - Casa A',
      totalDue: 100.0,
      amountPaid: 0.0,
      balance: 100.0,
      paymentStatus: 'pending',
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
  Stream<List<HousingPaymentEntity>> watchNeighborPayments(String housingUnit) {
    return Stream.value(_payments.where((p) => p.housingUnit == housingUnit).toList());
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
    String? notes,
  }) async {
    final idx = _payments.indexWhere((p) => p.id == housingPaymentId);
    if (idx == -1) throw Exception('Adeudo no encontrado');

    final current = _payments[idx];
    double newAmountPaid = current.amountPaid + amount;
    double newBalance = current.totalDue - newAmountPaid;
    String newStatus;

    if (type == 'complete' || newBalance <= 0) {
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
      housingUnit: current.housingUnit,
      totalDue: current.totalDue,
      amountPaid: newAmountPaid,
      balance: newBalance,
      paymentStatus: newStatus,
      paidAt: newStatus == 'paid' ? DateTime.now() : null,
      notes: notes,
    );

    _transactions.add(PaymentTransactionEntity(
      id: 't_${_transactions.length}',
      housingPaymentId: housingPaymentId,
      amount: amount,
      type: type,
      createdAt: DateTime.now(),
      createdBy: createdBy,
      notes: notes,
    ));
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

    test('registerPaymentTransaction calculates partial status and balance correctly', () async {
      // Abono parcial de $40 a una deuda de $100
      await registerPaymentUsecase.execute(
        housingPaymentId: 'hp1',
        amount: 40.0,
        type: 'partial',
        createdBy: 'admin_uid',
      );

      final payments = await repository.watchConceptPayments('1').first;
      final payment = payments.firstWhere((p) => p.id == 'hp1');

      expect(payment.amountPaid, 40.0);
      expect(payment.balance, 60.0);
      expect(payment.paymentStatus, 'partial');
    });

    test('registerPaymentTransaction calculates paid status on complete payment', () async {
      // Pago completo de $100
      await registerPaymentUsecase.execute(
        housingPaymentId: 'hp1',
        amount: 100.0,
        type: 'complete',
        createdBy: 'admin_uid',
      );

      final payments = await repository.watchConceptPayments('1').first;
      final payment = payments.firstWhere((p) => p.id == 'hp1');

      expect(payment.amountPaid, 100.0);
      expect(payment.balance, 0.0);
      expect(payment.paymentStatus, 'paid');
    });
  });
}
