import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/payment_transaction_entity.dart';
import 'timestamp_converter.dart';

part 'payment_transaction_model.freezed.dart';
part 'payment_transaction_model.g.dart';

@freezed
abstract class PaymentTransactionModel with _$PaymentTransactionModel {
  const factory PaymentTransactionModel({
    required String id,
    required String housingPaymentId,
    required double amount,
    required String type,
    @TimestampConverter() required DateTime createdAt,
    required String createdBy,
    String? notes,
  }) = _PaymentTransactionModel;

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionModelFromJson(json);

  factory PaymentTransactionModel.fromEntity(PaymentTransactionEntity entity) =>
      PaymentTransactionModel(
        id: entity.id,
        housingPaymentId: entity.housingPaymentId,
        amount: entity.amount,
        type: entity.type,
        createdAt: entity.createdAt,
        createdBy: entity.createdBy,
        notes: entity.notes,
      );
}

extension PaymentTransactionModelX on PaymentTransactionModel {
  PaymentTransactionEntity toEntity() => PaymentTransactionEntity(
        id: id,
        housingPaymentId: housingPaymentId,
        amount: amount,
        type: type,
        createdAt: createdAt,
        createdBy: createdBy,
        notes: notes,
      );
}
