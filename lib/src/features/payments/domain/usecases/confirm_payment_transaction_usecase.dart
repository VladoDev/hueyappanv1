import '../repositories/payments_repository.dart';

class ConfirmPaymentTransactionUsecase {
  final PaymentsRepository _repository;

  ConfirmPaymentTransactionUsecase(this._repository);

  Future<void> execute({
    required String housingPaymentId,
    required String transactionId,
  }) {
    return _repository.confirmPaymentTransaction(
      housingPaymentId: housingPaymentId,
      transactionId: transactionId,
    );
  }
}
