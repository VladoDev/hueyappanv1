import '../repositories/payments_repository.dart';

class RegisterPaymentTransactionUsecase {
  final PaymentsRepository _repository;

  RegisterPaymentTransactionUsecase(this._repository);

  Future<void> execute({
    required String housingPaymentId,
    required double amount,
    required String type,
    required String createdBy,
    bool isAdmin = true,
    double extraAmount = 0.0,
    String? notes,
  }) {
    return _repository.registerPaymentTransaction(
      housingPaymentId: housingPaymentId,
      amount: amount,
      type: type,
      createdBy: createdBy,
      isAdmin: isAdmin,
      extraAmount: extraAmount,
      notes: notes,
    );
  }
}
