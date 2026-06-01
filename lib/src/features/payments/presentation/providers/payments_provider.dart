import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/datasources/payments_firebase_datasource.dart';
import '../../data/repositories/payments_repository_impl.dart';
import '../../domain/entities/concept_item_entity.dart';
import '../../domain/entities/housing_payment_entity.dart';
import '../../domain/entities/payment_concept_entity.dart';
import '../../domain/entities/payment_transaction_entity.dart';
import '../../domain/repositories/payments_repository.dart';
import '../../domain/usecases/create_concept_usecase.dart';
import '../../domain/usecases/delete_concept_usecase.dart';
import '../../domain/usecases/register_payment_transaction_usecase.dart';
import '../../domain/usecases/update_concept_usecase.dart';
import '../../domain/usecases/update_recorded_expense_usecase.dart';
import '../../domain/usecases/watch_concept_payments_usecase.dart';
import '../../domain/usecases/watch_concepts_usecase.dart';
import '../../domain/usecases/watch_neighbor_payments_usecase.dart';
import '../../domain/usecases/watch_payment_transactions_usecase.dart';

// ── Datasource & Repository Providers ──

final paymentsFirebaseDatasourceProvider = Provider<PaymentsFirebaseDatasource>((ref) {
  return PaymentsFirebaseDatasource();
});

final paymentsRepositoryProvider = Provider<PaymentsRepository>((ref) {
  final datasource = ref.watch(paymentsFirebaseDatasourceProvider);
  return PaymentsRepositoryImpl(datasource);
});

// ── Usecase Providers ──

final watchConceptsUsecaseProvider = Provider<WatchConceptsUsecase>((ref) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return WatchConceptsUsecase(repo);
});

final watchConceptPaymentsUsecaseProvider = Provider<WatchConceptPaymentsUsecase>((ref) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return WatchConceptPaymentsUsecase(repo);
});

final watchNeighborPaymentsUsecaseProvider = Provider<WatchNeighborPaymentsUsecase>((ref) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return WatchNeighborPaymentsUsecase(repo);
});

final watchPaymentTransactionsUsecaseProvider = Provider<WatchPaymentTransactionsUsecase>((ref) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return WatchPaymentTransactionsUsecase(repo);
});

final createConceptUsecaseProvider = Provider<CreateConceptUsecase>((ref) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return CreateConceptUsecase(repo);
});

final updateConceptUsecaseProvider = Provider<UpdateConceptUsecase>((ref) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return UpdateConceptUsecase(repo);
});

final deleteConceptUsecaseProvider = Provider<DeleteConceptUsecase>((ref) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return DeleteConceptUsecase(repo);
});

final registerPaymentTransactionUsecaseProvider = Provider<RegisterPaymentTransactionUsecase>((ref) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return RegisterPaymentTransactionUsecase(repo);
});

final updateRecordedExpenseUsecaseProvider = Provider<UpdateRecordedExpenseUsecase>((ref) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return UpdateRecordedExpenseUsecase(repo);
});

// ── Reactive Stream Providers ──

final conceptsStreamProvider = StreamProvider<List<PaymentConceptEntity>>((ref) {
  return ref.watch(watchConceptsUsecaseProvider).execute();
});

final conceptItemsStreamProvider = StreamProvider.family<List<ConceptItemEntity>, String>((ref, conceptId) {
  final repo = ref.watch(paymentsRepositoryProvider);
  return repo.watchConceptItems(conceptId);
});

final neighborPaymentsStreamProvider = StreamProvider.family<List<HousingPaymentEntity>, String>((ref, housingUnit) {
  return ref.watch(watchNeighborPaymentsUsecaseProvider).execute(housingUnit);
});

final conceptPaymentsStreamProvider = StreamProvider.family<List<HousingPaymentEntity>, String>((ref, conceptId) {
  return ref.watch(watchConceptPaymentsUsecaseProvider).execute(conceptId);
});

final paymentTransactionsStreamProvider = StreamProvider.family<List<PaymentTransactionEntity>, String>((ref, paymentId) {
  return ref.watch(watchPaymentTransactionsUsecaseProvider).execute(paymentId);
});

// ── State Action Controller Provider ──

class PaymentsController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> createConcept(
      PaymentConceptEntity concept, List<ConceptItemEntity> items) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(createConceptUsecaseProvider).execute(concept, items);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<bool> updateConcept(PaymentConceptEntity concept) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(updateConceptUsecaseProvider).execute(concept);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<bool> deleteConcept(String conceptId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(deleteConceptUsecaseProvider).execute(conceptId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<bool> registerPaymentTransaction({
    required String housingPaymentId,
    required double amount,
    required String type,
    required String createdBy,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(registerPaymentTransactionUsecaseProvider).execute(
            housingPaymentId: housingPaymentId,
            amount: amount,
            type: type,
            createdBy: createdBy,
            notes: notes,
          );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<bool> updateRecordedExpense({
    required String conceptId,
    required double expense,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(updateRecordedExpenseUsecaseProvider).execute(
            conceptId: conceptId,
            expense: expense,
          );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

final paymentsControllerProvider =
    NotifierProvider.autoDispose<PaymentsController, AsyncValue<void>>(
        PaymentsController.new);

final residentNameProvider = FutureProvider.family<String, String>((ref, uid) async {
  // We can fetch from authFirebaseDatasourceProvider to read resident profiles
  final datasource = ref.read(authFirebaseDatasourceProvider);
  final profile = await datasource.getResidentProfile(uid);
  return profile?.name ?? 'Vecino';
});
