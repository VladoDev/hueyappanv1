// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concept_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConceptItemModel _$ConceptItemModelFromJson(Map<String, dynamic> json) =>
    _ConceptItemModel(
      id: json['id'] as String,
      conceptId: json['conceptId'] as String,
      label: json['label'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$ConceptItemModelToJson(_ConceptItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conceptId': instance.conceptId,
      'label': instance.label,
      'amount': instance.amount,
      'order': instance.order,
    };
