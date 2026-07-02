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
    @Default(0.0) double extraAmount,
    required String type,
    @TimestampConverter() required DateTime createdAt,
    required String createdBy,
    String? notes,
    String? lot,
    String? house,
    String? conceptTitle,
    String? conceptId,
    @Default(true) bool isConfirmed,
    @NullableTimestampConverter() DateTime? confirmedAt,
  }) = _PaymentTransactionModel;

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionModelFromJson(json);

  factory PaymentTransactionModel.fromEntity(PaymentTransactionEntity entity) =>
      PaymentTransactionModel(
        id: entity.id,
        housingPaymentId: entity.housingPaymentId,
        amount: entity.amount,
        extraAmount: entity.extraAmount,
        type: entity.type,
        createdAt: entity.createdAt,
        createdBy: entity.createdBy,
        notes: entity.notes,
        lot: entity.lot,
        house: entity.house,
        conceptTitle: entity.conceptTitle,
        conceptId: entity.conceptId,
        isConfirmed: entity.isConfirmed,
        confirmedAt: entity.confirmedAt,
      );
}

extension PaymentTransactionModelX on PaymentTransactionModel {
  PaymentTransactionEntity toEntity() => PaymentTransactionEntity(
    id: id,
    housingPaymentId: housingPaymentId,
    amount: amount,
    extraAmount: extraAmount,
    type: type,
    createdAt: createdAt,
    createdBy: createdBy,
    notes: notes,
    lot: lot,
    house: house,
    conceptTitle: conceptTitle,
    conceptId: conceptId,
    isConfirmed: isConfirmed,
    confirmedAt: confirmedAt,
  );
}
