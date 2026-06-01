import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/housing_payment_entity.dart';
import 'timestamp_converter.dart';

part 'housing_payment_model.freezed.dart';
part 'housing_payment_model.g.dart';

@freezed
abstract class HousingPaymentModel with _$HousingPaymentModel {
  const factory HousingPaymentModel({
    required String id,
    required String conceptId,
    required String residentUid,
    required String housingUnit,
    required double totalDue,
    required double amountPaid,
    required double balance,
    required String paymentStatus,
    @NullableTimestampConverter() DateTime? paidAt,
    String? notes,
  }) = _HousingPaymentModel;

  factory HousingPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$HousingPaymentModelFromJson(json);

  factory HousingPaymentModel.fromEntity(HousingPaymentEntity entity) =>
      HousingPaymentModel(
        id: entity.id,
        conceptId: entity.conceptId,
        residentUid: entity.residentUid,
        housingUnit: entity.housingUnit,
        totalDue: entity.totalDue,
        amountPaid: entity.amountPaid,
        balance: entity.balance,
        paymentStatus: entity.paymentStatus,
        paidAt: entity.paidAt,
        notes: entity.notes,
      );
}

extension HousingPaymentModelX on HousingPaymentModel {
  HousingPaymentEntity toEntity() => HousingPaymentEntity(
        id: id,
        conceptId: conceptId,
        residentUid: residentUid,
        housingUnit: housingUnit,
        totalDue: totalDue,
        amountPaid: amountPaid,
        balance: balance,
        paymentStatus: paymentStatus,
        paidAt: paidAt,
        notes: notes,
      );
}
