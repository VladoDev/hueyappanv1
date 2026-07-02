import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/payment_concept_entity.dart';
import 'timestamp_converter.dart';

part 'payment_concept_model.freezed.dart';
part 'payment_concept_model.g.dart';

@freezed
abstract class PaymentConceptModel with _$PaymentConceptModel {
  const factory PaymentConceptModel({
    required String id,
    required String title,
    String? description,
    required double totalAmount,
    required int totalUnits,
    required double amountPerUnit,
    required String status,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    @Default(0.0) double recordedExpense,
  }) = _PaymentConceptModel;

  factory PaymentConceptModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentConceptModelFromJson(json);

  factory PaymentConceptModel.fromEntity(PaymentConceptEntity entity) =>
      PaymentConceptModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        totalAmount: entity.totalAmount,
        totalUnits: entity.totalUnits,
        amountPerUnit: entity.amountPerUnit,
        status: entity.status,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        recordedExpense: entity.recordedExpense,
      );
}

extension PaymentConceptModelX on PaymentConceptModel {
  PaymentConceptEntity toEntity() => PaymentConceptEntity(
    id: id,
    title: title,
    description: description,
    totalAmount: totalAmount,
    totalUnits: totalUnits,
    amountPerUnit: amountPerUnit,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
    recordedExpense: recordedExpense,
  );
}
