// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentTransactionModel _$PaymentTransactionModelFromJson(
  Map<String, dynamic> json,
) => _PaymentTransactionModel(
  id: json['id'] as String,
  housingPaymentId: json['housingPaymentId'] as String,
  amount: (json['amount'] as num).toDouble(),
  extraAmount: (json['extraAmount'] as num?)?.toDouble() ?? 0.0,
  type: json['type'] as String,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  createdBy: json['createdBy'] as String,
  notes: json['notes'] as String?,
  lot: json['lot'] as String?,
  house: json['house'] as String?,
  conceptTitle: json['conceptTitle'] as String?,
  conceptId: json['conceptId'] as String?,
  isConfirmed: json['isConfirmed'] as bool? ?? true,
  confirmedAt: const NullableTimestampConverter().fromJson(json['confirmedAt']),
);

Map<String, dynamic> _$PaymentTransactionModelToJson(
  _PaymentTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'housingPaymentId': instance.housingPaymentId,
  'amount': instance.amount,
  'extraAmount': instance.extraAmount,
  'type': instance.type,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'createdBy': instance.createdBy,
  'notes': instance.notes,
  'lot': instance.lot,
  'house': instance.house,
  'conceptTitle': instance.conceptTitle,
  'conceptId': instance.conceptId,
  'isConfirmed': instance.isConfirmed,
  'confirmedAt': const NullableTimestampConverter().toJson(
    instance.confirmedAt,
  ),
};
