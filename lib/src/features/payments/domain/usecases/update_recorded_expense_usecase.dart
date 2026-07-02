import '../repositories/payments_repository.dart';

class UpdateRecordedExpenseUsecase {
  final PaymentsRepository _repository;

  UpdateRecordedExpenseUsecase(this._repository);

  Future<void> execute({required String conceptId, required double expense}) {
    return _repository.updateRecordedExpense(
      conceptId: conceptId,
      expense: expense,
    );
  }
}
