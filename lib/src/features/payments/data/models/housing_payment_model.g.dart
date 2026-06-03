// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'housing_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HousingPaymentModel _$HousingPaymentModelFromJson(Map<String, dynamic> json) =>
    _HousingPaymentModel(
      id: json['id'] as String,
      conceptId: json['conceptId'] as String,
      residentUid: json['residentUid'] as String,
      housingUnit: json['housingUnit'] as String,
      totalDue: (json['totalDue'] as num).toDouble(),
      amountPaid: (json['amountPaid'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      paymentStatus: json['paymentStatus'] as String,
      extraAmount: (json['extraAmount'] as num?)?.toDouble() ?? 0.0,
      paidAt: const NullableTimestampConverter().fromJson(json['paidAt']),
      notes: json['notes'] as String?,
      hasPendingConfirmation: json['hasPendingConfirmation'] as bool? ?? false,
    );

Map<String, dynamic> _$HousingPaymentModelToJson(
  _HousingPaymentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'conceptId': instance.conceptId,
  'residentUid': instance.residentUid,
  'housingUnit': instance.housingUnit,
  'totalDue': instance.totalDue,
  'amountPaid': instance.amountPaid,
  'balance': instance.balance,
  'paymentStatus': instance.paymentStatus,
  'extraAmount': instance.extraAmount,
  'paidAt': const NullableTimestampConverter().toJson(instance.paidAt),
  'notes': instance.notes,
  'hasPendingConfirmation': instance.hasPendingConfirmation,
};
