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
  type: json['type'] as String,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  createdBy: json['createdBy'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$PaymentTransactionModelToJson(
  _PaymentTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'housingPaymentId': instance.housingPaymentId,
  'amount': instance.amount,
  'type': instance.type,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'createdBy': instance.createdBy,
  'notes': instance.notes,
};
