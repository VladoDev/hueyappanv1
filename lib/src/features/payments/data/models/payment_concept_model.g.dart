// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_concept_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentConceptModel _$PaymentConceptModelFromJson(Map<String, dynamic> json) =>
    _PaymentConceptModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      totalUnits: (json['totalUnits'] as num).toInt(),
      amountPerUnit: (json['amountPerUnit'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
      recordedExpense: (json['recordedExpense'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PaymentConceptModelToJson(
  _PaymentConceptModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'totalAmount': instance.totalAmount,
  'totalUnits': instance.totalUnits,
  'amountPerUnit': instance.amountPerUnit,
  'status': instance.status,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'recordedExpense': instance.recordedExpense,
};
