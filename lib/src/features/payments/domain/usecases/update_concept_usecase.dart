import '../../domain/entities/payment_concept_entity.dart';
import '../repositories/payments_repository.dart';

class UpdateConceptUsecase {
  final PaymentsRepository _repository;

  UpdateConceptUsecase(this._repository);

  Future<void> execute(PaymentConceptEntity concept) {
    return _repository.updateConcept(concept);
  }
}
