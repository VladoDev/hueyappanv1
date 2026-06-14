import '../../domain/entities/housing_payment_entity.dart';
import '../repositories/payments_repository.dart';

class WatchNeighborPaymentsUsecase {
  final PaymentsRepository _repository;

  WatchNeighborPaymentsUsecase(this._repository);

  Stream<List<HousingPaymentEntity>> execute(String lot, String house) {
    return _repository.watchNeighborPayments(lot, house);
  }
}
