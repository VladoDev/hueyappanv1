import '../../domain/entities/housing_payment_entity.dart';
import '../repositories/payments_repository.dart';

class WatchConceptPaymentsUsecase {
  final PaymentsRepository _repository;

  WatchConceptPaymentsUsecase(this._repository);

  Stream<List<HousingPaymentEntity>> execute(String conceptId) {
    return _repository.watchConceptPayments(conceptId);
  }
}
