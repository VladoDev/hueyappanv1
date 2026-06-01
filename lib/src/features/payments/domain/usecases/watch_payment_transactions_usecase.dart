import '../../domain/entities/payment_transaction_entity.dart';
import '../repositories/payments_repository.dart';

class WatchPaymentTransactionsUsecase {
  final PaymentsRepository _repository;

  WatchPaymentTransactionsUsecase(this._repository);

  Stream<List<PaymentTransactionEntity>> execute(String housingPaymentId) {
    return _repository.watchPaymentTransactions(housingPaymentId);
  }
}
