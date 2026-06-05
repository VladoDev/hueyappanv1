import '../../domain/entities/payment_concept_entity.dart';
import '../../domain/entities/concept_item_entity.dart';
import '../repositories/payments_repository.dart';

class CreateConceptUsecase {
  final PaymentsRepository _repository;

  CreateConceptUsecase(this._repository);

  Future<void> execute(PaymentConceptEntity concept, List<ConceptItemEntity> items) {
    return _repository.createConcept(concept, items);
  }
}
