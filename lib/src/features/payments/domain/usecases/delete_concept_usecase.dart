import '../repositories/payments_repository.dart';

class DeleteConceptUsecase {
  final PaymentsRepository _repository;

  DeleteConceptUsecase(this._repository);

  Future<void> execute(String conceptId) {
    return _repository.deleteConcept(conceptId);
  }
}
