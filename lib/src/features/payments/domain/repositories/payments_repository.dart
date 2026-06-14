import '../../domain/entities/payment_concept_entity.dart';
import '../../domain/entities/concept_item_entity.dart';
import '../../domain/entities/housing_payment_entity.dart';
import '../../domain/entities/payment_transaction_entity.dart';

abstract class PaymentsRepository {
  Stream<List<PaymentConceptEntity>> watchConcepts();
  Stream<List<ConceptItemEntity>> watchConceptItems(String conceptId);
  Stream<List<HousingPaymentEntity>> watchNeighborPayments(String lot, String house);
  Stream<List<HousingPaymentEntity>> watchConceptPayments(String conceptId);
  Stream<List<PaymentTransactionEntity>> watchPaymentTransactions(String housingPaymentId);

  Future<void> createConcept(PaymentConceptEntity concept, List<ConceptItemEntity> items);
  Future<void> updateConcept(PaymentConceptEntity concept);
  Future<void> deleteConcept(String conceptId);

  Future<void> registerPaymentTransaction({
    required String housingPaymentId,
    required double amount,
    required String type, // 'partial', 'complete', 'correction'
    required String createdBy,
    bool isAdmin = true,
    double extraAmount = 0.0,
    String? notes,
  });

  Future<void> confirmPaymentTransaction({
    required String housingPaymentId,
    required String transactionId,
  });

  Future<void> updateRecordedExpense({
    required String conceptId,
    required double expense,
  });
}
