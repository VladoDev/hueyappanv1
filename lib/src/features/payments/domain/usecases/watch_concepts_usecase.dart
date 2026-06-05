import '../../domain/entities/payment_concept_entity.dart';
import '../repositories/payments_repository.dart';

class WatchConceptsUsecase {
  final PaymentsRepository _repository;

  WatchConceptsUsecase(this._repository);

  Stream<List<PaymentConceptEntity>> execute() {
    return _repository.watchConcepts();
  }
}
